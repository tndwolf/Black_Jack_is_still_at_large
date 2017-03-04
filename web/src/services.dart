import 'dart:html';
import 'world.dart';
import 'services/entity_factory.dart';
import 'services/game_mechanics.dart';
import 'services/game_output.dart';
import 'services/map_factory.dart';
import 'services/user_inputs.dart';

EntityFactory _entityFactory;
GameMechanics _gameMechanics;
GameOutput _gameOutput;
MapFactory _mapFactory;
UserInput _userInput;
World _world;

EntityFactory get entityFactory => _entityFactory;
GameMechanics get gameMechanics => _gameMechanics;
GameOutput get gameOutput => _gameOutput;
MapFactory get mapFactory => _mapFactory;

initialize(World world) {
  var outCanvas = querySelector("#output");
  _world = world;
  _entityFactory = new EntityFactory();
  _gameOutput = new GameOutput(outCanvas);
  _mapFactory = new MapFactory();
  _userInput = new UserInput(world, outCanvas);
  _gameMechanics = new GameMechanics(world);
}
