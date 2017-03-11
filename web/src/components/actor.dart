import '../card.dart';
import '../game_component.dart';
import '../services.dart';

class Actor extends GameComponent {
  num get actionResult => gameMechanics.getHandValue(hand);
  num bullets = 6;
  num cap = 21;
  bool finalBoss = false;
  num fleeThreshold = 7;
  List<Card> hand = <Card>[];
  num initiative = 0;
  bool isAlive = true;
  bool isIdentified = false;
  num maxBullets = 6;
  num range = 3;
  bool surprised = true;

  Actor(num entity): super(entity) {}
}