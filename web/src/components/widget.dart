import 'dart:html';
import '../game_component.dart';

abstract class Widget extends GameComponent {
  num x;
  num y;
  num z;
  Widget(num entity): super(entity);
  draw(CanvasRenderingContext2D context, [num offsetX = 0, num offsetY = 0]);
}