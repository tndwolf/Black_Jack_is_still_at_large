import 'dart:html';
import '../components/actor.dart';
import '../components/physical_object.dart';

class GameOutput {
  String asciiFont = '16px Monospace';
  CanvasElement canvas;
  CanvasRenderingContext2D get context => canvas.context2D;

  GameOutput(CanvasElement this.canvas) {}

  examinePlayer(Actor actor, PhysicalObject physical) {
    var output = querySelector('#player');
    output.innerHtml = '';
    output.appendText('Defense: ${physical.health}');
    output.append(new BRElement());
    output.appendText('Health: ${physical.health}');
    output.append(new BRElement());
    output.appendText('Hand: ');
    output.append(new BRElement());
    for(var card in actor.hand) {
      output.appendText('- $card');
      output.append(new BRElement());
    }
  }

  examineTarget(PhysicalObject physical) {
    var output = querySelector('#target');
    output.innerHtml = '';
    output.appendText('Defense: ${physical.health}');
    output.append(new BRElement());
    output.appendText('Health: ${physical.health}');
    output.append(new BRElement());
    output.appendText('Hand: ');
    output.append(new BRElement());
    for(var card in actor.hand) {
      output.appendText('- $card');
      output.append(new BRElement());
    }
  }
}