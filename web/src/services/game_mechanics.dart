import '../world.dart';
import '../services.dart';
import '../components/game_map.dart';

class GameMechanics {
  World _world;

  GameMechanics(World this._world) { }

  generateLevel() {
    var map = new GameMap(_world.nextEntity, mapFactory.generate());
    print(map);
    _world.add(map);
  }
}