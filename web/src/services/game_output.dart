import 'dart:html';
import '../card.dart';
import '../services.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';

class GameOutput {
  String asciiFont = '24px Monospace';
  CanvasElement canvas;
  CanvasRenderingContext2D get context => canvas.context2D;

  GameOutput(CanvasElement this.canvas) {}

  examinePlayer(Actor actor, PhysicalObject physical) {
    var output = querySelector('#player');
    output.innerHtml = '';
    printHand(output, 'Defense', physical.defense, physical.defenseHand);
    output.append(new BRElement());
    printHand(output, 'Health', physical.health, physical.healthHand);
    output.append(new BRElement());
    printHand(output, 'Action', gameMechanics.getHandValue(actor.hand, cap: actor.cap), actor.hand);
  }

  examineTarget(Actor actor, PhysicalObject physical) {
    var output = querySelector('#target');
    output.innerHtml = '';
    if (actor.isIdentified) {
      printHand(output, 'Defense', physical.defense, physical.defenseHand);
      output.append(new BRElement());
      printHand(output, 'Health', physical.health, physical.healthHand);
      output.append(new BRElement());
    } else {
      output.appendText('Defense: ???');
      output.append(new BRElement());
      output.appendText('Health: ???');
      output.append(new BRElement());
    }
    //printHand(output, 'Action', gameMechanics.getHandValue(actor.hand, cap: actor.cap), actor.hand);
    output.append(new ParagraphElement()..text = physical.description);
  }

  printHand(Element output, String name, num value, List<Card> hand) {
    output.appendText('$name: $value');
    output.append(new BRElement());
    for(var card in hand) {
      var span = new SpanElement()
          ..className = (card.suite == suites.Spades || card.suite == suites.Clubs) ? 'card dark_suite' : 'card red_suite'
          ..text = card.toShortString();
      output.append(span);
    }
  }
}