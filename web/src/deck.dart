import 'card.dart';

class Deck {
  List<Card> cards = <Card>[];
  num _index = 0;

  Deck() {
    for (var suite in suites.values) {
      for(num i = 1; i < 10; i++) {
        cards.add(new Card(i, suite));
      }
    }
    shuffle();
  }

  Card get current => cards[_index];

  Card draw() {
    if(_index >= cards.length) {
      shuffle();
    }
    return cards[_index++];
  }

  void shuffle() {
    cards.shuffle();
    _index = 0;
  }
}