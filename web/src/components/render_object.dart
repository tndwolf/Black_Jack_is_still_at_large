import 'dart:html';
import 'widget.dart';
import '../color.dart';
import '../game_component.dart';

class RenderObject extends GameComponent implements Widget {
  String glyph = '@';
  Color color = new Color();
  num x = 0;
  num y = 0;
  num z = 0;

  RenderObject(num entity): super(entity) {}

  @override
  draw(CanvasRenderingContext2D context) {
    context.setFillColorRgb(color.r, color.g, color.b, color.a);
    context.fillText(glyph, x, y);
  }
}