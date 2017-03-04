var suites = ["Spades", "Clubs", "Diamonds", "Hearths"];

/// Card class
class Card {
  num value;
  String suite;
  Card(num this.value, String this.suite);
  @override toString() { return "$value of $suite"; }
}