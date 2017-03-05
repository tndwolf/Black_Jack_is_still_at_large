import '../world.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';
import '../components/render_object.dart';
import '../systems/grid_manager.dart';

class EntityFactory {
  num CreatePlayer(World world) {
    var grid = world.getSystem(GridManager) as GridManager;
    num id = world.nextEntity;
    print('EntityFactory.CreatePlayer: $id');
    var x = 6;
    var y = 6;
    world.add(new Actor(id));
    world.add(new PhysicalObject(id)
      ..glyph = '@'
      ..health = 10
      ..x = x
      ..y = y);
    world.add(new RenderObject(id)
      ..x = grid.map.cellWidth * (x + 0.5)
      ..y = grid.map.cellHeight * (y + 0.5));
    return id;
  }
}