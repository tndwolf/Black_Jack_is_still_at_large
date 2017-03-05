import '../card.dart';
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
  num player = World.INVALID_ENTITY;
  num target = World.INVALID_ENTITY;
  World _world;

  GameMechanics(World this._world) {
    deck = new Deck();
  }

  attack(num attacker, num target) {
    var atkActor = _world.getComponent(Actor, attacker) as Actor;
    var atkPhy = _world.getComponent(PhysicalObject, attacker) as PhysicalObject;
    var defActor = _world.getComponent(Actor, target) as Actor;
    var defPhy = _world.getComponent(PhysicalObject, target) as PhysicalObject;
    try {

    } catch(ex) {
      print('GameMechanics.attack: unable to attack $attacker vs $target');
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

  generateLevel() {
    var map = new GameMap(_world.nextEntity, mapFactory.generate());
    //print("GameMechanics.generateLevel: $map");
    _world.add(map);
    player = entityFactory.CreatePlayer(_world);
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

  selectNext() {
    var grid = _world.getSystem(GridManager) as GridManager;
    try {
      var inFoV = grid.getAllInFoV();
      if (inFoV.length == 0) return;
      for(var i = 0; i < inFoV.length - 1; i++) {
        if(target == inFoV[i]) {
          target = inFoV[i + 1];
          //gameOutput.examineTarget();
          return;
        }
      }
      target = inFoV[0];
      //gameOutput.examineTarget();
    } catch(ex) {
      print('GameMechanics.selectNext: some odd bug...');
    }
  }
}