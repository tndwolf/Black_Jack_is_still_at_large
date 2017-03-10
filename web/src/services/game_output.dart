import 'dart:html';
import 'dart:web_audio';
import '../card.dart';
import '../services.dart';
import '../components/actor.dart';
import '../components/physical_object.dart';

class GameOutput {
  String asciiFont = '24px Monospace';
  AudioContext audioContext = new AudioContext();
  CanvasElement canvas;
  CanvasRenderingContext2D get context => canvas.context2D;
  num get height => canvas.height;
  num get width => canvas.width;

  GameOutput(CanvasElement this.canvas) {}

  examinePlayer(Actor actor, PhysicalObject physical, bool hasCover) {
    var output = querySelector('#player');
    output.innerHtml = '';
    printHand(output, 'Defense', physical.defense, physical.defenseHand);
    output.append(new BRElement());
    printHand(output, 'Health', physical.health, physical.healthHand);
    output.append(new BRElement());
    printHand(output, 'Action', gameMechanics.getHandValue(actor.hand, cap: actor.cap), actor.hand);
    output.append(new BRElement());
    if(hasCover) {
      output.append(new SpanElement()..text = 'Cover'..className = 'cover');
    }
  }

  examineTarget(Actor actor, PhysicalObject physical, bool hasCover) {
    var output = querySelector('#target');
    output.innerHtml = '';
    if (actor.isIdentified) {
      printHand(output, 'Defense', physical.defense, physical.defenseHand);
      output.append(new BRElement());
      printHand(output, 'Health', physical.health, physical.healthHand);
      output.append(new BRElement());
      output.appendText('Range: ${actor.range}');
      output.append(new BRElement());
      if(actor.isAlive) {
        if (physical.health < actor.fleeThreshold) {
          output.append(new SpanElement()
            ..text = 'Fleeing'
            ..className = 'fleeing');
          output.append(new BRElement());
        }
        if (hasCover) {
          output.append(new SpanElement()
            ..text = 'Cover'
            ..className = 'cover');
        }
      } else {
        output.append(new SpanElement()
          ..text = 'Dead'
          ..className = 'dead');
      }
    } else {
      output.appendText('Defense: ???');
      output.append(new BRElement());
      output.append(new BRElement());
      output.appendText('Health: ???');
      output.append(new BRElement());
      output.append(new BRElement());
      output.appendText('Range: ???');
    }
    //printHand(output, 'Action', gameMechanics.getHandValue(actor.hand, cap: actor.cap), actor.hand);
    output.append(new ParagraphElement()..text = physical.description);
  }

  playSound(String soundId) async {
    assetsManager.playSound(soundId);
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