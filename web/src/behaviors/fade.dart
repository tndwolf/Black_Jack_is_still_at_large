import '../color.dart';
import '../game_component.dart';
import '../components/widget.dart';
import '../services.dart';
import '../world.dart';
import 'dart:html';

class Fade extends Behavior implements Widget {
  num _alpha = 0;
  Color background = new Color(0, 0, 0);
  ImageElement backgroundImage = null;
  Color color = new Color(255, 255, 255);
  num fadeMillis;
  num fadeOutMillis = 1000;
  num fadeInMillis = 1000;
  bool _fadingOut = false;
  num refTime = 0;
  bool special = false; // HACK: just to finish in time... too sleepy
  num textRowsSpacing = 24;
  List<String> text = <String>[];
  @override  num x = 0;
  @override  num y = 0;
  @override  num z = 1000;

  Fade([num entity = World.GENERIC_ENTITY]): super(entity) {}

  fadeOut() { _fadingOut = true; }

  @override
  draw(CanvasRenderingContext2D context, [num offsetX = 0, num offsetY = 0]) {
    context.setFillColorRgb(background.r, background.g, background.b, _alpha);
    //print('Fade.draw: $_alpha, fadeMillis $fadeMillis, $fadeInMillis, $fadeOutMillis');
    context.fillRect(0, 0, context.canvas.width, context.canvas.height);
    if(backgroundImage != null) {
      context.globalAlpha = _alpha;
      context.drawImageScaled(backgroundImage, 0, 0, context.canvas.width, context.canvas.height);
      context.globalAlpha = 1;
    }
    num y = this.y;
    for(var row in text) {
      context.font = gameOutput.asciiFont;
      context.setFillColorRgb(color.r, color.g, color.b, _alpha);
      context.textAlign = 'center';
      context.textBaseline = 'middle';
      context.fillText(row, context.canvas.width ~/ 2, y);
      y += textRowsSpacing;
    }
    if(special) {
      context.font = gameOutput.westernFont;
      context.fillText("Black jacK", context.canvas.width ~/ 2, 120);
      context.font = gameOutput.asciiFont;
      context.fillText("Is still at large", context.canvas.width ~/ 2, 172);
    }
    if (_alpha <= 0) {
      deleteMe = true;
    }
  }

  @override
  update(World world) {
    //print('Fade.update: updating');
    var deltaTime = 20;
    refTime += deltaTime;
    fadeMillis = _fadingOut ? fadeInMillis : fadeOutMillis;
    if (_fadingOut) {
      _alpha = (fadeMillis - refTime) / fadeMillis;
    } else {
      _alpha = refTime / fadeMillis;
    }
    _alpha = _alpha < 0 ? 0 : _alpha == double.INFINITY ? 1 : _alpha;
  }
}