import '../game_component.dart';

class PhysicalObject extends GameComponent {
  num health;
  num x;
  num y;

  PhysicalObject(num entity): super(entity) {}
}