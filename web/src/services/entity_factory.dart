import '../card.dart';
import '../color.dart';
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
      var ctemp = temp['color'];
      var color = new Color(ctemp[0], ctemp[1], ctemp[2], ctemp[3]);
      print('EntityFactory.CreateEnemy: template $ctemp to color $color');
      var position = gameMechanics.randomPosition();
      //print('EntityFactory.CreateEnemy: position $position');
      world.add(new Actor(id)
        ..cap = temp['cap']
        ..finalBoss = temp['finalBoss']
        ..fleeThreshold = temp['fleeThreshold']
        ..range = temp['range']);
      var physical = new PhysicalObject(id)
        ..x = position[0]
        ..y = position[1];
      /*physical.defenseHand.last.value = temp['defense'];
      physical.healthHand.last.value = temp['health'];
      if(temp['defenseBonus'] > 0) {
        physical.defenseHand.add(new Card(temp['defenseBonus'], suites.Spades));
      }
      if(temp['healthBonus'] > 0) {
        physical.healthHand.add(new Card(temp['healthBonus'], suites.Hearths));
      }*/
      world.add(physical);
      world.add(new RenderObject(id)
        ..glyph = temp['glyph']
        ..color = new Color(temp['color'][0], temp['color'][1], temp['color'][2], temp['color'][3])
        ..x = grid.map.cellWidth * (position[0] + 0.5)
        ..y = grid.map.cellHeight * (position[1] + 0.5));
    } catch (ex) {
      print('EntityFactory.CreateEnemy: Failed - $ex');
    } finally {
      //print('EntityFactory.CreateEnemy: Created $id from $template');
      return id;
    }
  }
}