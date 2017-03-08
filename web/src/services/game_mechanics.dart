import '../card.dart';
import '../color.dart';
import '../deck.dart';
import '../game_component.dart';
import '../world.dart';
import '../services.dart';
import '../behaviors/animated_text.dart';
import '../behaviors/animated_text_queue.dart';
import '../components/game_map.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';
import '../components/render_object.dart';
import '../components/text_box.dart';
import '../systems/grid_manager.dart';

var _levels = [
  {
    "map": "desert",
    "description": [
      "- DEAD MAN'S CANYON -",
      "Find your way trough the canyon",
      "The the old mines lie to the East →",
      "Good Luck!"
    ],
    "enemies": ["native"],
    "howMany": 4
  },
  {
    "map": "desert",
    "description": [
      "- INSIDE DEAD MAN'S CANYON -",
      "The natives know of you",
      "Prepare your irons"
    ],
    "enemies": ["native", "nativeBow"],
    "howMany": 6
  },
  {
    "map": "mine",
    "description": [
      "- MINES, TOP FLOOR -",
      "The bandit-s lair is in the mines",
      "They deal in lead",
      "Beware"
    ],
    "enemies": ["bandit"],
    "howMany": 6
  },
  {
    "map": "mine",
    "description": ["Mines, first floor"],
    "enemies": ["bandit", "outlaw"],
    "howMany": 6
  },
  {
    "map": "mine",
    "description": ["- THE OLD MINES -", "The deeper layer of the mines"],
    "enemies": ["outlaw", "outlaw", "liutenent"],
    "howMany": 6
  },
  {
    "map": "mine",
    "description": ["♠ BLACK JACK'S LAIR ♠", "Confront the man himself"],
    "enemies": ["outlaw", "outlaw", "liutenent"],
    "howMany": 6,
    "spawnBoss": true
  }
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
  }

  attack(num attacker, num target) {
    var atkActor = _world.getComponent(Actor, attacker) as Actor;
    var atkPhy =
        _world.getComponent(PhysicalObject, attacker) as PhysicalObject;
    var defActor = _world.getComponent(Actor, target) as Actor;
    var defPhy = _world.getComponent(PhysicalObject, target) as PhysicalObject;
    try {
      print('GameMechanics.attack: Test ${atkActor.actionResult} vs ${defPhy.defense}');
      var dam = atkActor.actionResult - defPhy.defense;
      if (dam < 1) {
        print('GameMechanics.attack: missed! $attacker vs $target');
        //TODO: missed(atkPhy, defPhy);
        floatTextDeferred('Missed', _world.getComponent(RenderObject, target) as RenderObject, new Color(255, 0, 255));
        gameOutput.playSound('miss_01');
      } else {
        print('GameMechanics.attack: hit! $dam');
        damage(target, dam);
        gameOutput.playSound('shot_01');
        if (attacker == player) {
          gameOutput.examinePlayer(atkActor, atkPhy);
          gameOutput.examineTarget(defActor, defPhy);
        } else if (target == player) {
          gameOutput.examinePlayer(defActor, defPhy);
          //gameOutput.examineTarget(atkActor, atkPhy);
        }
      }
    } catch (ex) {
      print('GameMechanics.attack: unable to attack $attacker vs $target. $ex');
    }
  }

  damage(num entity, num howMuch) {
    var dealt = 0;
    _world.getComponent(Actor, entity) as Actor..isIdentified = true;
    var physical =
        _world.getComponent(PhysicalObject, entity) as PhysicalObject;
    print(
        'GameMechanics.damage: Dealing $howMuch damage to $entity, health was ${physical.health}');
    while (howMuch > 0 && physical.healthHand.length > 0) {
      if (physical.healthHand.last.value > howMuch) {
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
      floatTextDeferred(dealt.toString(), render, new Color(255, 0, 0));
    }
  }

  bool draw(num entity, bool newHand) {
    var actor = _world.getComponent(Actor, entity) as Actor;
    try {
      if (newHand) {
        actor.hand.clear();
        actor.hand.add(deck.draw());
      }
      actor.hand.add(deck.draw());
      if(entity == player) {
        gameOutput.examinePlayer(
            actor,
            _world.getComponent(PhysicalObject, entity) as PhysicalObject);
      }
    } catch (ex) {
      print('GameMechanics.draw: unable to draw for $entity');
    }
    if(entity == player) {
      print('GameMechanics.draw: ${actor.actionResult} vs ${actor.cap}');
      print('GameMechanics.draw: ${actor.actionResult > actor.cap}');
    }
    return actor.actionResult > actor.cap;
  }

  bool executeUserInputs() {
    var res = false;
    if (nextPlayerMove != null) {
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

  floatText(String text, num x, num y, Color color, {num fadeOutMillis: 500}) {
    var tb = new TextBox(World.GENERIC_ENTITY)
      ..color = color
      ..text = text
      ..x = x
      ..y = y
      ..width = text.length * 16;
    _world.add(tb);
    _world.add(new AnimatedText(tb)
      ..animationPixelPerSec = [0, -32]
      ..fadeOutMillis = fadeOutMillis);
  }

  floatTextCentered(String text, Color color, [num fadeTime = 500]) {
    var ani = _world.getComponent(AnimatedTextQueue, World.GENERIC_ENTITY)
        as AnimatedTextQueue;
    if (ani != null) {
      print("GameMechanics.floatTextDeferred: found previous");
      ani.addCenteredText(text, color, fadeTime);
    } else {
      print("GameMechanics.floatTextDeferred: new one");
      _world.add(new AnimatedTextQueue(World.GENERIC_ENTITY)
        ..addCenteredText(text, color, fadeTime));
    }
  }

  floatTextDeferred(String text, RenderObject render, Color color) {
    if (render == null) {
      // HACK: this is an horrible hack... but it saves time and refactoring...
      render = _world.getComponent(RenderObject, player) as RenderObject;
    }
    //print("GameMechanics.floatTextDeferred: texting");
    var ani = _world.getComponent(AnimatedTextQueue, render.entity)
        as AnimatedTextQueue;
    //print("GameMechanics.floatTextDeferred: fa qualcosa");
    if (ani != null) {
      //print("GameMechanics.floatTextDeferred: found previous");
      ani.addText(text, render, color);
    } else {
      //print("GameMechanics.floatTextDeferred: new one");
      _world.add(
          new AnimatedTextQueue(render.entity)..addText(text, render, color));
    }
  }

  floatTextOn(String text, RenderObject render, Color color) {
    var tb = new TextBox(World.GENERIC_ENTITY)
      ..color = color
      ..text = text
      ..x = render.x
      ..y = render.y
      ..width = text.length * 16;
    _world.add(tb);
    _world.add(new AnimatedText(tb)
      ..animationPixelPerSec = [0, -32]
      ..fadeOutMillis = 500);
  }

  bool inRange(PhysicalObject from, PhysicalObject to, num range) {
    var dx = from.x - to.x;
    var dy = from.y - to.y;
    return dx * dx + dy * dy < range * range;
  }

  generateLevel([List<GameComponent> oldPlayer = null]) {
    _world.clear();
    var map = new GameMap(
        _world.nextEntity, mapFactory.generate(_levels[currentLevel]['map']));
    //print("GameMechanics.generateLevel: $map");
    _world.add(map);
    if (oldPlayer == null) {
      player = entityFactory.CreatePlayer(_world);
    } else {
      print("GameMechanics.generateLevel: Copying player");
      for (var component in oldPlayer) {
        _world.add(component);
      }
    }
    setPosition(player, mapFactory.start[0], mapFactory.start[1]);
    draw(player, true);
    gameOutput.examinePlayer(_world.getComponent(Actor, player) as Actor,
        _world.getComponent(PhysicalObject, player) as PhysicalObject);
    for (num i = 0; i < _levels[currentLevel]['howMany']; i++) {
      entityFactory.CreateEnemy(
          _world, randomItem(_levels[currentLevel]['enemies']));
    }
    if (_levels[currentLevel]['spawnBoss'] != null) {
      entityFactory.CreateEnemy(_world, 'boss');
      map.at(mapFactory.end[0], mapFactory.end[1])..isEndOfLevel = false;
    }
    selectPointer = new RenderObject(World.GENERIC_ENTITY)
      ..color = new Color(255, 127, 127)
      ..glyph = "( )"
      ..x = -10000
      ..z = 100;
    _world.add(selectPointer);
    for(var text in _levels[currentLevel]['description']) {
      floatTextCentered(text, new Color(255, 255, 255), 1000);
    }
  }

  num getHandValue(List<Card> hand, {num cap: 1000, bool acesAsEleven: true}) {
    var res = 0;
    var aces = 0;
    //var figures = 0;
    for (var card in hand) {
      res += card.value;
      if (card.value == 1 && acesAsEleven) aces++;
    }
    while (aces > 0 && res + 10 <= cap) {
      aces--;
      res += 10;
    }
    return res;
  }

  bool isAlive(num entity) {
    try {
      return (_world.getComponent(Actor, entity) as Actor).isAlive;
    } catch (ex) {
      return false;
    }
  }

  kill(num entity) {
    var actor = _world.getComponent(Actor, entity) as Actor;
    actor.isAlive = false;
    actor.deleteMe = true;
    var render = _world.getComponent(RenderObject, entity) as RenderObject;
    render.glyph = '%';
    render.color = new Color(255, 0, 0);
    floatTextDeferred('DEAD', render, new Color(255, 0, 0));
    if(actor.finalBoss == true) winGame();
  }

  bool move(num entity, num dx, num dy) {
    var res = false;
    var grid = _world.getSystem(GridManager) as GridManager;
    var physical =
        _world.getComponent(PhysicalObject, entity) as PhysicalObject;
    var render = _world.getComponent(RenderObject, entity) as RenderObject;
    try {
      var ex = physical.x + dx;
      var ey = physical.y + dy;
      var endCell = grid.map.at(ex, ey);
      if (endCell.blocksMovement == false && grid.isOccupied(ex, ey) == false) {
        res = true;
        physical.x = ex;
        physical.y = ey;
        render.x = (ex + 0.5) * grid.map.cellWidth;
        render.y = (ey + 0.5) * grid.map.cellHeight;
        if (entity == target) {
          selectPointer.x = (ex + 0.5) * grid.map.cellWidth;
          selectPointer.y = (ey + 0.5) * grid.map.cellHeight;
        }
        if (entity == player && endCell.isEndOfLevel) {
          currentLevel++;
          generateLevel(_world.getEntity(player));
          _world.update();
        }
        //floatTextDeferred('MOVE', render, new Color(255, 0, 255));
      }
    } catch (ex) {
      print('GameMechanics.move: unable to move $entity');
    } finally {
      draw(entity, true);
      return res;
    }
  }

  moveTo(PhysicalObject from, num toX, num toY, bool flee) {
    var dx = (toX - from.x).sign * (flee ? -1 : 1);
    var dy = (toY - from.y).sign * (flee ? -1 : 1);
    if (move(from.entity, dx, dy)) return;
    else move(from.entity, rng.nextInt(3)-1, rng.nextInt(3)-1);
  }

  List<num> randomPosition() {
    var grid = _world.getSystem(GridManager) as GridManager;
    var i = 0;
    var x = -1;
    var y = -1;
    do {
      x = rng.nextInt(grid.map.width);
      y = rng.nextInt(grid.map.height);
    } while (
      grid.isWalkable(x, y) == true
      && grid.isOccupied(x, y) == false
      && i++ < 1000);
    return [x, y];
  }

  dynamic randomItem(List<dynamic> source) {
    return source[rng.nextInt(source.length)];
  }

  runAis() {
    var ais = _world.getAll(Actor);
    for (var ai in ais) {
      if (ai.entity != player) runDefaultAi(ai as Actor);
    }
  }

  runDefaultAi(Actor actor) {
    if (actor.isAlive == false) return;
    //print('GameMechanics.runDefaultAi: running AI of ${actor.entity}');
    var grid = _world.getSystem(GridManager) as GridManager;
    var physical =
        _world.getComponent(PhysicalObject, actor.entity) as PhysicalObject;
    if (grid.isInLos(physical.x, physical.y)) {
      var target =
          _world.getComponent(PhysicalObject, player) as PhysicalObject;
      if (inRange(physical, target, actor.range)) {
        print('GameMechanics.runDefaultAi: attack ${actor.entity} vs $player');
        attack(actor.entity, player);
        draw(actor.entity, true);
      } else {
        if (physical.health > actor.fleeThreshold) {
          moveTo(physical, target.x, target.y, false);
          draw(actor.entity, true);
        } else {
          var render =
              _world.getComponent(RenderObject, actor.entity) as RenderObject;
          floatTextDeferred('Fleeing', render, new Color(255, 255, 0));
          moveTo(physical, target.x, target.y, true);
          draw(actor.entity, true);
        }
      }
    } else {
      move(actor.entity, rng.nextInt(3)-1, rng.nextInt(3)-1);
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
      for (var i = 0; i < inFoV.length - 1; i++) {
        if (target == inFoV[i]) {
          target = inFoV[i + 1];
          gameOutput.examineTarget(_world.getComponent(Actor, target) as Actor,
              _world.getComponent(PhysicalObject, target) as PhysicalObject);
          var render =
              _world.getComponent(RenderObject, target) as RenderObject;
          selectPointer.x = render.x;
          selectPointer.y = render.y;
          return;
        }
      }
      target = inFoV[0];
      gameOutput.examineTarget(_world.getComponent(Actor, target) as Actor,
          _world.getComponent(PhysicalObject, target) as PhysicalObject);
      var render = _world.getComponent(RenderObject, target) as RenderObject;
      selectPointer.x = render.x;
      selectPointer.y = render.y;
      //print('GameMechanics.selectNext: select pointer ${selectPointer.x}, ${selectPointer.y}');
    } catch (ex) {
      //print('GameMechanics.selectNext: some odd bug...');
    }
  }

  setInput(dynamic function) {
    nextPlayerMove = function;
  }

  setPosition(num entity, num x, num y) {
    var grid = _world.getSystem(GridManager) as GridManager;
    var physical =
        _world.getComponent(PhysicalObject, entity) as PhysicalObject;
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
      for (var obj in objects) {
        var physical =
            _world.getComponent(PhysicalObject, obj.entity) as PhysicalObject;
        var render =
            _world.getComponent(RenderObject, obj.entity) as RenderObject;
        render.color.a = grid.isInLos(physical.x, physical.y) ? 1 : 0.2;
        //print('GameMechanics.updateVisibility: ${obj.entity} to ${render.color.a}');
      }
    } catch (ex) {
      //print('GameMechanics.updateVisibility: some odd bug...');
    }
  }

  winGame() {
    userInput.stopInputs = true;
    var winText = [
      "As you pull the trigger",
      "Black Jack falls to the ground",
      "A fuming hole between his eyes...",
      "...You won",
      "The other badits flee as you kneel",
      "taking your trophy from the body",
      "Before starting your long way back.",
      "CONGRATULATIONS!"
    ];
    for(var text in winText) {
      floatTextCentered(text, new Color(0, 255, 255), 1000);
    }
  }
}
