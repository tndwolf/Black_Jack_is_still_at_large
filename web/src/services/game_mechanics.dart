import '../card.dart';
import '../color.dart';
import '../deck.dart';
import '../game_component.dart';
import '../world.dart';
import '../services.dart';
import '../behaviors/animated_text.dart';
import '../components/game_map.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';
import '../components/render_object.dart';
import '../components/text_box.dart';
import '../systems/grid_manager.dart';

var _levels = [
  {"map": "desert", "enemies": ["nativeBow"]},
  {"map": "mine", "enemies": ["native"]}
];

class GameMechanics {
  Deck deck;
  num currentLevel = 0;
  dynamic nextPlayerMove = null;
  num player = World.INVALID_ENTITY;
  num target = World.INVALID_ENTITY;
  RenderObject selectPointer;
  World _world;

  GameMechanics(World this._world) {
    deck = new Deck();
    selectPointer = new RenderObject(_world.nextEntity)
      ..color = new Color(255, 127, 127)
      ..glyph = "(_)"
      ..x = -10000
      ..z = 10;
    _world.add(selectPointer);
  }

  attack(num attacker, num target) {
    var atkActor = _world.getComponent(Actor, attacker) as Actor;
    var atkPhy = _world.getComponent(PhysicalObject, attacker) as PhysicalObject;
    var defActor = _world.getComponent(Actor, target) as Actor;
    var defPhy = _world.getComponent(PhysicalObject, target) as PhysicalObject;
    try {
      var dam = atkActor.actionResult - defPhy.defense;
      if (dam < 0) {
        print('GameMechanics.attack: missed! $attacker vs $target');
        //TODO: missed(atkPhy, defPhy);
      } else {
        damage(target, dam);
        if(attacker ==  player) {
          gameOutput.examinePlayer(atkActor, atkPhy);
          gameOutput.examineTarget(defActor, defPhy);
        } else if (target == player) {
          gameOutput.examinePlayer(defActor, defPhy);
          //gameOutput.examineTarget(atkActor, atkPhy);
        }
      }
    } catch(ex) {
      print('GameMechanics.attack: unable to attack $attacker vs $target. $ex');
    }
  }

  damage(num entity, num howMuch) {
    var dealt = 0;
    var physical = _world.getComponent(PhysicalObject, entity) as PhysicalObject;
    print('GameMechanics.damage: Dealing $howMuch damage to $entity, health was ${physical.health}');
    while(howMuch > 0 && physical.healthHand.length > 0) {
      if(physical.healthHand.last.value > howMuch) {
        dealt += howMuch;
        physical.healthHand.last.value -= howMuch;
        howMuch = 0;
      } else {
        dealt += physical.healthHand.last.value;
        howMuch -= physical.healthHand.last.value;
        physical.healthHand.removeLast();
      }
    }
    var render = _world.getComponent(RenderObject, entity) as RenderObject;
    if (physical.healthHand.length == 0) {
      kill(entity);
      //print('GameMechanics.damage: Killed $entity');
    } else {
      floatText(dealt.toString(), render.x, render.y, new Color(255, 0, 0));
    }
  }

  draw(num entity, bool newHand) {
    var actor = _world.getComponent(Actor, entity) as Actor;
    try {
      if(newHand) {
        actor.hand.clear();
        actor.hand.add(deck.draw());
      }
      actor.hand.add(deck.draw());
      gameOutput.examinePlayer(actor, _world.getComponent(PhysicalObject, entity) as PhysicalObject);
    } catch(ex) {
      print('GameMechanics.draw: unable to draw for $entity');
    }
  }

  bool executeUserInputs() {
    var res = false;
    if(nextPlayerMove != null) {
      print('GameMechanics.executeUserInputs: running Player input');
      nextPlayerMove();
      res = true;
      nextPlayerMove = null;
      (_world.getComponent(Actor, player) as Actor).initiative += 10;
    } else {
      print('GameMechanics.executeUserInputs: waiting Player input');
    }
    return res;
  }

  floatText(String text, num x, num y, Color color) {
    var tb = new TextBox(World.GENERIC_ENTITY)
      ..color = color
      ..text = text
      ..x = x
      ..y = y
      ..width = text.length * 16;
    _world.add(tb);
    _world.add(new AnimatedText(tb)
      ..animationPixelPerSec = [0, -16]
      ..fadeOutMillis = 500);
  }

  bool inRange(PhysicalObject from, PhysicalObject to, num range) {
    var dx = from.x - to.x;
    var dy = from.y - to.y;
    return dx * dx + dy * dy < range * range;
  }

  generateLevel([List<GameComponent> oldPlayer = null]) {
    _world.clear();
    var map = new GameMap(_world.nextEntity, mapFactory.generate(_levels[currentLevel]['map']));
    //print("GameMechanics.generateLevel: $map");
    _world.add(map);
    if (oldPlayer == null) {
      player = entityFactory.CreatePlayer(_world);
    } else {
      print("GameMechanics.generateLevel: Copying player");
      for(var component in oldPlayer) {
        _world.add(component);
      }
    }
    setPosition(player, mapFactory.start[0], mapFactory.start[1]);
    draw(player, true);
    for(num i = 0; i < 1; i++) {
      entityFactory.CreateEnemy(_world, randomItem(_levels[currentLevel]['enemies']));
    }
  }

  num getHandValue(List<Card> hand, {num cap: 1000, bool acesAsEleven: true}) {
    var res = 0;
    var aces = 0;
    //var figures = 0;
    for(var card in hand) {
      res += card.value;
      if (card.value == 1 && acesAsEleven) aces++;
    }
    while(aces > 0 && res + 10 <= cap) {
      aces--;
      res += 10;
    }
    return res;
  }

  kill(num entity) {
    var actor = _world.getComponent(Actor, entity) as Actor;
    actor.isAlive = false;
    actor.deleteMe = true;
    var render = _world.getComponent(RenderObject, entity) as RenderObject;
    render.glyph = '%';
    render.color = new Color(255, 0, 0);
    floatText('DEAD', render.x, render.y, new Color(255, 0, 0));
  }

  bool move(num entity, num dx, num dy) {
    var res = false;
    var grid = _world.getSystem(GridManager) as GridManager;
    var physical = _world.getComponent(PhysicalObject, entity) as PhysicalObject;
    var render = _world.getComponent(RenderObject, entity) as RenderObject;
    try {
      var ex = physical.x + dx;
      var ey = physical.y + dy;
      var endCell = grid.map.at(ex, ey);
      if (endCell.blocksMovement == false) {
        res = true;
        physical.x = ex;
        physical.y = ey;
        render.x = (ex + 0.5) * grid.map.cellWidth;
        render.y = (ey + 0.5) * grid.map.cellHeight;
        if(entity == target) {
          selectPointer.x = (ex + 0.5) * grid.map.cellWidth;
          selectPointer.y = (ey + 0.5) * grid.map.cellHeight;
        }
        if(entity == player && endCell.isEndOfLevel) {
          currentLevel++;
          generateLevel(_world.getEntity(player));
          _world.update();
        }
      }
    } catch(ex) {
      print('GameMechanics.move: unable to move $entity');
    } finally {
      return res;
    }
  }

  moveTo(PhysicalObject from, num toX, num toY, bool flee) {
    var dx = (toX - from.x).sign * (flee ? -1 : 1);
    var dy = (toY - from.y).sign * (flee ? -1 : 1);
    if (move(from.entity, dx, dy)) return;
  }

  List<num> randomPosition() {
    var map = (_world.getSystem(GridManager) as GridManager).map;
    var i = 0;
    var x = -1;
    var y = -1;
    do {
      x = rng.nextInt(map.width);
      y = rng.nextInt(map.height);
    } while (map.at(x, y).blocksMovement == true && i++ < 1000);
    return [x, y];
  }

  dynamic randomItem(List<dynamic> source) {
    return source[rng.nextInt(source.length)];
  }

  runAis() {
    var ais = _world.getAll(Actor);
    for(var ai in ais) {
      if (ai.entity != player)
      runDefaultAi(ai as Actor);
    }
  }

  runDefaultAi(Actor actor) {
    if (actor.isAlive == false) return;
    //print('GameMechanics.runDefaultAi: running AI of ${actor.entity}');
    var grid = _world.getSystem(GridManager) as GridManager;
    var physical = _world.getComponent(PhysicalObject, actor.entity) as PhysicalObject;
    if (grid.isInLos(physical.x, physical.y)) {
      var target = _world.getComponent(PhysicalObject, player) as PhysicalObject;
      if(inRange(physical, target, actor.range)) {
        print('GameMechanics.runDefaultAi: attack ${actor.entity} vs $player');
        attack(actor.entity, player);
        draw(actor.entity, true);
      } else {
        if (physical.health > actor.fleeThreshold) {
          moveTo(physical, target.x, target.y, false);
          draw(actor.entity, true);
        } else {
          var render = _world.getComponent(RenderObject, actor.entity) as RenderObject;
          floatText('Flee', render.x, render.y, new Color(255, 255, 0));
          moveTo(physical, target.x, target.y, true);
          draw(actor.entity, true);
        }
      }
    }
    actor.initiative += 10;
    gameMechanics.updateVisibility();
  }

  selectNext() {
    var grid = _world.getSystem(GridManager) as GridManager;
    try {
      var inFoV = grid.getAllInFoV();
      inFoV.remove(player);
      print("GameMechanics.selectNext: InFov ${inFoV.length}, old $target");
      if (inFoV.length == 0) return;
      for(var i = 0; i < inFoV.length - 1; i++) {
        if(target == inFoV[i]) {
          target = inFoV[i + 1];
          gameOutput.examineTarget(
            _world.getComponent(Actor, target) as Actor,
            _world.getComponent(PhysicalObject, target) as PhysicalObject
          );
          var render = _world.getComponent(RenderObject, target) as RenderObject;
          selectPointer.x = render.x;
          selectPointer.y = render.y;
          return;
        }
      }
      target = inFoV[0];
      gameOutput.examineTarget(
          _world.getComponent(Actor, target) as Actor,
          _world.getComponent(PhysicalObject, target) as PhysicalObject
      );
      var render = _world.getComponent(RenderObject, target) as RenderObject;
      selectPointer.x = render.x;
      selectPointer.y = render.y;
    } catch(ex) {
      //print('GameMechanics.selectNext: some odd bug...');
    }
  }

  setInput(dynamic function) {
    nextPlayerMove = function;
  }

  setPosition(num entity, num x, num y) {
    var grid = _world.getSystem(GridManager) as GridManager;
    var physical = _world.getComponent(PhysicalObject, entity) as PhysicalObject;
    var render = _world.getComponent(RenderObject, entity) as RenderObject;
    physical.x = x;
    physical.y = y;
    render.x = (x + 0.5) * grid.map.cellWidth;
    render.y = (y + 0.5) * grid.map.cellHeight;
  }

  updateVisibility() {
    var objects = _world.getAll(PhysicalObject);
    var grid = _world.getSystem(GridManager) as GridManager;
    try {
      for(var obj in objects) {
        var physical = _world.getComponent(PhysicalObject, obj.entity) as PhysicalObject;
        var render = _world.getComponent(RenderObject, obj.entity) as RenderObject;
        render.color.a = grid.isInLoS(physical.x, physical.y) ? 1 : 0.2;
        //print('GameMechanics.updateVisibility: ${obj.entity} to ${render.color.a}');
      }
    } catch(ex) {
      //print('GameMechanics.updateVisibility: some odd bug...');
    }
  }
}