import '../color.dart';
import '../game_component.dart';
import '../components/widget.dart';
import '../world.dart';
import 'dart:html';

class Fade extends Behavior implements Widget {
  num _alpha = 0;
  Color background = new Color(0, 0, 0);
  Color color = new Color(255, 255, 255);
  num fadeMillis;
  num fadeOutMillis = 1000;
  num fadeInMillis = 1000;
  bool _fadingOut = false;
  num refTime = 0;
  num textRowsSpacing = 24;
  List<String> text = <String>[];
  @override  num x = 0;
  @override  num y = 0;
  @override  num z = 1000;

  Fade([num entity = World.GENERIC_ENTITY]): super(entity) {}

  fadeOut() { _fadingOut = true; }

  @override
  draw(CanvasRenderingContext2D context) {
    //print('Fade.draw: drawing');
    //_alpha = (fadeMillis - refTime) / fadeMillis;
    context.setFillColorRgb(background.r, background.g, background.b, _alpha);
    context.fillRect(0, 0, context.canvas.width, context.canvas.height);
    num y = this.y;
    for(var row in text) {
      context.setFillColorRgb(color.r, color.g, color.b, _alpha);
      context.textAlign = 'center';
      context.textBaseline = 'middle';
      context.fillText(row, context.canvas.width ~/ 2, y);
      y += textRowsSpacing;
    }
  }

  @override
  update(World world) {
    print('Fade.update: updating');
    var deltaTime = 20;
    refTime += deltaTime;
    fadeMillis = _fadingOut ? fadeInMillis : fadeOutMillis;
    if (_fadingOut) {
      _alpha = (fadeMillis - refTime) / fadeMillis;
      // 1------0.5------0
    } else {
      _alpha = refTime / fadeMillis;
    }
  }
}