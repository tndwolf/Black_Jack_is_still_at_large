import '../world.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';

class EntityFactory {
  num CreatePlayer(World world) {
    num id = world.nextEntity;
    var actor = new Actor(id);
    world.add(actor);
    var physical = new PhysicalObject(id)
      ..glyph = '@'
      ..health = 10;
    world.add(physical);
  }
}