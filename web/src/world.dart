import 'dart:async';
import 'game_component.dart';
import 'game_system.dart';
import 'systems/grid_manager.dart';
import 'systems/renderer.dart';
import 'systems/turn_manage.dart';

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

  clear() {
      _components.clear();
      _behaviors.clear();
      for(var system in _systems) {
        system.clear();
      }
  }

  List<GameComponent> getAll(Type type) {
    var res = _components.where((c) => c.runtimeType == type);
    if (res.length == 0) {
      res = _behaviors.where((c) => c.runtimeType == type);
    }
    return res.toList();
  }

  GameComponent getComponent(Type type, num entity) {
    var res = _components.firstWhere((c) => c.runtimeType == type && c.entity == entity, orElse: null);
    if (res == null) {
      res = _behaviors.firstWhere((c) => c.runtimeType == type && c.entity == entity, orElse: null);
    }
    return res;
  }

  List<GameComponent> getEntity(num entity) {
    var res = _components.where((c) => c.entity == entity);
    return res.toList();
  }

  GameSystem getSystem(Type type) {
    var res = _systems.firstWhere((s) => s.runtimeType == type);
    return res;
  }

  initialize() {
    _systems.clear();
    _components.clear();
    _behaviors.clear();
    _systems.add(new GridManager()..initialize(this));
    _systems.add(new Renderer()..initialize(this));
    //_systems.add(new TurnManager()..initialize(this));
  }

  num get nextEntity => _lastEntity + 1;

  update() {
    //print('World.update: start');
    /*for(var behavior in _behaviors) {
      behavior.update(this);
    }*/
    for(var system in _systems) {
      system.update(this);
    }
    //new Timer(new Duration(milliseconds:20), update);
  }

  updateRealTime() {
    for(var behavior in _behaviors) {
      behavior.update(this);
    }
    for(var system in _systems) {
      system.updateRealTime(this);
    }
    new Timer(new Duration(milliseconds:20), updateRealTime);
  }

  @override toString() {
    return "{}";
  }
}