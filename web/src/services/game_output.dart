import 'dart:html';

class GameOutput {
  String asciiFont = '16px Monospace';
  CanvasElement canvas;
  CanvasRenderingContext2D get context => canvas.context2D;

  GameOutput(CanvasElement this.canvas) {}

  examinePlayer() {
    var output = querySelector('#player');
  }

  examineTarget() {

  }
}