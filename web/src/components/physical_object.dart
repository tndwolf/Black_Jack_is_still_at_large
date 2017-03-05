import '../card.dart';
import '../game_component.dart';
import '../services.dart';

class PhysicalObject extends GameComponent {
  List<Card> defenseHand = <Card>[];
  List<Card> healthHand = <Card>[];
  num get defense => gameMechanics.getHandValue(defenseHand);
  num get health => gameMechanics.getHandValue(healthHand);
  num x;
  num y;

  PhysicalObject(num entity): super(entity) {
    defenseHand.add(new Card(10, suites.Spades));
    healthHand.add(new Card(10, suites.Hearths));
  }
}