import '../game_component.dart';
import '../game_system.dart';
import '../world.dart';
import '../components/map.dart';

class Renderer implements GameSystem {
  GameMap map = null;
  List<GameComponent> widgets = <GameComponent>[];

  @override
  initialize(World world) {
    // TODO: implement initialize
  }

  @override
  bool register(GameComponent component) {
    var res = false;
    if(component is GameMap) {
      map = component as Map;
      res = true;
    } else if (component is GameComponent) {
      
    }
    return res;
  }

  @override
  unregister(GameComponent component) {
    // TODO: implement unregister
  }

  @override
  update(World world) {
    // TODO: implement update
  }
}