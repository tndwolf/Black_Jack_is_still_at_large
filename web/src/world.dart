import 'game_component.dart';
import 'game_system.dart';
import 'systems/grid_manager.dart';
import 'systems/renderer.dart';

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

  GameComponent getComponent(Type type, num entity) {
    var res = _components.firstWhere((c) => c.runtimeType == type && c.entity == entity, orElse: null);
    if (res == null) {
      res = _behaviors.firstWhere((c) => c.runtimeType == type && c.entity == entity, orElse: null);
    }
    return res;
  }

  GameSystem getSystem(Type type) {
    var res = _systems.firstWhere((s) => s.runtimeType == type);
    return res;
  }

  initialize() {
    _systems.add(new GridManager()..initialize(this));
    _systems.add(new Renderer()..initialize(this));
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