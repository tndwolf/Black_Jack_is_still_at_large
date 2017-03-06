import '../card.dart';
import '../services.dart';
import '../world.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';
import '../components/render_object.dart';
import '../data/entity_templates.dart';
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
      ..x = x
      ..y = y);
    world.add(new RenderObject(id)
      ..x = grid.map.cellWidth * (x + 0.5)
      ..y = grid.map.cellHeight * (y + 0.5)
      ..z = 1);
    return id;
  }

  num CreateEnemy(World world, String template) {
    var grid = world.getSystem(GridManager) as GridManager;
    num id = world.nextEntity;
    print('EntityFactory.CreateEnemy: $id from $template');
    try {
      var temp = entityTemplates[template];
      var position = gameMechanics.randomPosition();
      world.add(new Actor(id)
        ..cap = temp['cap']
        ..fleeThreshold = temp['fleeThreshold']);
      world.add(new RenderObject(id)
        ..glyph = 'B'
        ..x = grid.map.cellWidth * (x + 0.5)
        ..y = grid.map.cellHeight * (y + 0.5));
    } catch (ex) {
      print('EntityFactory.CreateEnemy: Failed - $ex');
    }

    var x = rng.nextInt(grid.map.width - 2) + 1;
    var y = rng.nextInt(grid.map.height - 2) + 1;
    world.add(new Actor(id));
    world.add(new PhysicalObject(id)
      ..x = x
      ..y = y
      ..healthHand.add(new Card(2, suites.Hearths)));
    world.add(new RenderObject(id)
      ..glyph = 'B'
      ..x = grid.map.cellWidth * (x + 0.5)
      ..y = grid.map.cellHeight * (y + 0.5));
    return id;
  }
}