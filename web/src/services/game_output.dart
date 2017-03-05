import 'dart:html';
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
    output.appendText('Defense: ${physical.defense}');
    output.append(new BRElement());
    output.appendText('Health: ${physical.health}');
    output.append(new BRElement());
    for(var card in physical.healthHand) {
      output.appendText('- $card');
      output.append(new BRElement());
    }
    output.appendText('Hand: ${gameMechanics.getHandValue(actor.hand, cap: actor.cap)} / ${actor.cap}');
    output.append(new BRElement());
    for(var card in actor.hand) {
      output.appendText('- $card');
      output.append(new BRElement());
    }
  }

  examineTarget(Actor actor, PhysicalObject physical) {
    var output = querySelector('#target');
    output.innerHtml = '';
    output.appendText('Defense: ${physical.defense}');
    output.append(new BRElement());
    output.appendText('Health: ${physical.health}');
    output.append(new BRElement());
    for(var card in physical.healthHand) {
      output.appendText('- $card');
      output.append(new BRElement());
    }
    output.appendText('Hand: ${gameMechanics.getHandValue(actor.hand, cap: actor.cap)} / ${actor.cap}');
    output.append(new BRElement());
    for(var card in actor.hand) {
      output.appendText('- $card');
      output.append(new BRElement());
    }
  }
}