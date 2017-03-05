import 'dart:html';
import '../game_component.dart';

abstract class Widget extends GameComponent {
  num z = 0;
  Widget(num entity): super(entity);
  draw(CanvasRenderingContext2D context);
}