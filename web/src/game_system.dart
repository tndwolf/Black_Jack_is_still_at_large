import 'game_component.dart';
import 'world.dart';

abstract class GameSystem {
  clear();
  initialize(World world);
  bool register(GameComponent component);
  update(World world);
  updateRealTime(World world);
}