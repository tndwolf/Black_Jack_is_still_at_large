import 'world.dart';

abstract class Behavior extends GameComponent {
  Behavior(num entity): super(entity);
  Behavior.fromJson(Map json): super.fromJson(json);
  update(World world);
}

abstract class GameComponent {
  bool deleteMe = false;
  num entity;
  GameComponent(num this.entity);
  GameComponent.fromJson(Map json);
  //@override String toString();
}