import 'game_component.dart';
import 'world.dart';

abstract class GameSystem {
  initialize(World world);
  bool register(GameComponent component);
  unregister(GameComponent component);
  update(World world);
  updateRealTime(World world);
}