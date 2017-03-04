import 'game_component.dart';
import 'game_system.dart';

class World {
  static const num GENERIC_ENTITY = 0;
  static const num INVALID_ENTITY = -1;

  List<Behavior> _behaviors = <Behavior>[];
  List<GameComponent> _components = <GameComponent>[];
  num _lastEntity = 0;
  List<GameSystem> _systems = <GameSystem>[];

  add(GameComponent component) {
    if (component is Behavior) {
      _behaviors.add(component as Behavior);
    } else {
      for(var system in _systems) {
        system.register(component);
      }
      // TODO should check if the component is an orphan...
      _components.add(component);
    }
    _lastEntity = (component.entity > _lastEntity) ? component.entity : _lastEntity;
  }

  initialize() {

  }

  num get nextEntity => _lastEntity + 1;

  update() {
    for(var behavior in _behaviors) {
      behavior.update(this);
    }
    for(var system in _systems) {
      system.update(this);
    }
  }

  @override toString() {
    return "{}";
  }
}