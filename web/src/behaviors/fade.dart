import '../game_component.dart';
import '../components/widget.dart';
import '../world.dart';
import 'dart:html';

class fade extends Behavior implements Widget {
  List<String> text = <String>[];
  @override  num x = 0;
  @override  num y = 0;
  @override  num z = 8;

  fade([num entity = World.GENERIC_ENTITY]): super(entity) {}

  @override
  draw(CanvasRenderingContext2D context) {
    // TODO: implement draw
  }

  @override
  update(World world) {
    return;
  }
}