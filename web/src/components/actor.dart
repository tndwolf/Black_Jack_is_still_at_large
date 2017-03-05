import '../card.dart';
import '../game_component.dart';
import '../services.dart';

class Actor extends GameComponent {
  num get actionResult => gameMechanics.getHandValue(hand);
  num cap = 21;
  List<Card> hand = <Card>[];

  Actor(num entity): super(entity) {}
}