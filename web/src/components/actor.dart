import '../card.dart';
import '../game_component.dart';

class Actor extends GameComponent {
  List<Card> hand = <Card>[];

  Actor(num entity): super(entity) {}
}