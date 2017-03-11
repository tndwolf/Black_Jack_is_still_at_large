import 'dart:html';
import 'widget.dart';
import '../color.dart';
import '../game_component.dart';
import '../services.dart';

class TextBox extends GameComponent implements Widget {
  Color background = new Color(0, 0, 0);
  Color color = new Color(255, 255, 255);
  num height = 16;
  String text = '';
  num width = 32;
  @override num x = 0;
  @override num y = 0;
  @override num z = 10;

  TextBox(num entity): super(entity) { }

  @override
  draw(CanvasRenderingContext2D context, [num offsetX = 0, num offsetY = 0]) {
    context.font = gameOutput.asciiFont;
    context.textAlign = 'center';
    context.textBaseline = 'middle';

    //var halfWidth = width ~/ 2;
    //var halfHeight = height ~/ 2;
    //context.setFillColorRgb(background.r, background.g, background.b, background.a);
    //context.fillRect(x - halfWidth, y - halfHeight, width, height);
    context.setStrokeColorRgb(background.r, background.g, background.b, background.a);
    context.lineWidth = 3;
    context.strokeText(text, x - offsetX, y - offsetY);
    context.setFillColorRgb(color.r, color.g, color.b, color.a);
    context.fillText(text, x - offsetX, y - offsetY);
  }
}