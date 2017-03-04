import 'dart:html';
import 'world.dart';
import 'services/entity_factory.dart';
import 'services/map_factory.dart';
import 'services/user_inputs.dart';

EntityFactory _entityFactory;
MapFactory _mapFactory;
UserInput _userInput;
World _world;

EntityFactory get entityFactory => _entityFactory;

initialize(World world) {
  _world = world;
  _entityFactory = new EntityFactory();
  _mapFactory = new MapFactory();
  _userInput = new UserInput(world, querySelector("#output"));
}
