import '../card.dart';
import '../color.dart';
import '../deck.dart';
import '../world.dart';
import '../services.dart';
import '../components/game_map.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';
import '../components/render_object.dart';
import '../systems/grid_manager.dart';

class GameMechanics {
  Deck deck;
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

  damage(num target, num howMuch) {
    print('GameMechanics.damage: Dealing $howMuch damage to $target');
    var physical = _world.getComponent(PhysicalObject, target) as PhysicalObject;
    while(howMuch > 0) {
      if(physical.healthHand.last.value > howMuch) {
        physical.healthHand.last.value -= howMuch;
        howMuch = 0;
      } else {
        howMuch -= physical.healthHand.last.value;
        physical.healthHand.removeLast();
      }
    }
    if (getHandValue(physical.healthHand) < 1) {
      print('GameMechanics.damage: Killed $target');
    }
  }

  draw(num entity) {
    var actor = _world.getComponent(Actor, entity) as Actor;
    try {
      actor.hand.add(deck.draw());
      gameOutput.examinePlayer(actor, _world.getComponent(PhysicalObject, entity) as PhysicalObject);
    } catch(ex) {
      print('GameMechanics.draw: unable to draw for $entity');
    }
  }

  bool executeUserInputs() {
    var res = false;
    if(nextPlayerMove != null) {
      nextPlayerMove();
      res = true;
    }
    return res;
  }

  generateLevel() {
    var map = new GameMap(_world.nextEntity, mapFactory.generate());
    //print("GameMechanics.generateLevel: $map");
    _world.add(map);
    player = entityFactory.CreatePlayer(_world);
    for(num i = 0; i < 1; i++) {
      entityFactory.CreateEnemy(_world);
    }
  }

  num getHandValue(List<Card> hand, [num cap = 1000]) {
    var res = 0;
    var aces = 0;
    //var figures = 0;
    for(var card in hand) {
      res += card.value;
      if (card.value == 1) aces++;
    }
    while(aces > 0 && res + 10 <= cap) {
      aces--;
      res += 10;
    }
    return res;
  }

  move(num entity, num dx, num dy) {
    var grid = _world.getSystem(GridManager) as GridManager;
    var physical = _world.getComponent(PhysicalObject, player) as PhysicalObject;
    var renderer = _world.getComponent(RenderObject, player) as RenderObject;
    try {
      var ex = physical.x + dx;
      var ey = physical.y + dy;
      var endCell = grid.map.at(ex, ey);
      if (endCell.blocksMovement == false) {
        physical.x = ex;
        physical.y = ey;
        renderer.x = (ex + 0.5) * grid.map.cellWidth;
        renderer.y = (ey + 0.5) * grid.map.cellHeight;
      }
    } catch(ex) {
      print('GameMechanics.move: unable to move $entity');
    }
  }

  runDefaultAi(Actor actor) {
    //var physical = _world.getComponent(PhysicalObject, actor.entity) as PhysicalObject;
    move(actor.entity, rng.nextInt(3) - 1, rng.nextInt(3) - 1);
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
      print('GameMechanics.selectNext: some odd bug...');
    }
  }

  setInput(dynamic function) {
    nextPlayerMove = function;
  }
}