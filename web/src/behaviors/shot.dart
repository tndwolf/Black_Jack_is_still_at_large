import '../color.dart';
import '../game_component.dart';
import '../components/widget.dart';
import '../world.dart';
import 'dart:html';

class Shot extends Behavior implements Widget {
  num _alpha = 0;
  Color color = new Color(189, 212, 219);
  num fadeMillis = 150;
  num refTime = 0;
  num startX = 0;
  num startY = 0;
  @override num x = 0;
  @override num y = 0;
  @override num z = 1000;

  Shot([num entity = World.GENERIC_ENTITY]): super(entity) {}

  @override
  draw(CanvasRenderingContext2D context, [num offsetX = 0, num offsetY = 0]) {
    context.setFillColorRgb(color.r, color.g, color.b, _alpha);
    context.beginPath();
    context.lineWidth = 1;
    context.moveTo(startX - offsetX, startY - offsetY);
    context.lineTo(x - offsetX, y - offsetY);
    context.stroke();
    context.closePath();
    if (_alpha <= 0) {
      deleteMe = true;
    }
  }

  @override
  update(World world) {
    var deltaTime = 20;
    refTime += deltaTime;
    _alpha = (fadeMillis - refTime) / fadeMillis;
    _alpha = _alpha < 0 ? 0 : _alpha == double.INFINITY ? 1 : _alpha;
  }
}