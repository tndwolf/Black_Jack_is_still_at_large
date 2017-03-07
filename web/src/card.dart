enum suites { Spades, Clubs, Diamonds, Hearths }

String suiteToString(suites suite) {
  return "${suite.toString().substring(suite.toString().indexOf('.')+1)}";
}

/// Card class
class Card {
  num value;
  suites suite;
  Card(num this.value, suites this.suite);
  @override toString() { return "$value of ${suiteToString(suite)}"; }

  String toShortString() {
    var shortSuite = suite == suites.Clubs ?
    '♣' : suite == suites.Hearths ?
    '♥' : suite == suites.Diamonds ?
    '♦' : '♠';
    var shortValue = (value == 1) ? 'A' : value.toString();
    return '$shortValue$shortSuite';
  }
}