import '../card.dart';
import '../game_component.dart';

class Actor extends GameComponent {
  num cap = 21;
  List<Card> hand = <Card>[];

  Actor(num entity): super(entity) {}
}