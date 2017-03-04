import '../game_component.dart';

class PhysicalObject extends GameComponent {
  String glyph = '@';
  num health;
  num x;
  num y;

  PhysicalObject(num entity): super(entity) {}
}