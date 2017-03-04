import 'dart:html';
import '../game_component.dart';

abstract class Widget extends GameComponent {
  Widget(num entity): super(entity);
  draw(CanvasRenderingContext2D context);
}