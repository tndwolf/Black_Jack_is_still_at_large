import 'animated_text.dart';
import '../color.dart';
import '../game_component.dart';
import '../world.dart';
import '../services.dart';
import '../components/render_object.dart';

class NextText {
  String text;
  num x;
  num y;
  Color color;
}

class AnimatedTextQueue extends Behavior {
  List<NextText> animations = <NextText>[];
  num waitTime = 500;
  num refTime = 0;

  AnimatedTextQueue([num entity = World.GENERIC_ENTITY])
      : super(entity) {}

  addText(String text, num x, num y, Color color) {
    var next = new NextText()
      ..color = color
      ..text = text
      ..x = x
      ..y = y;
    animations.add(next);
  }

  @override
  update(World world) {
    var deltaTime = 20;
    refTime += deltaTime;
    if (animations.length > 0 && refTime > waitTime) {
      refTime = 0;
      var next = animations.removeAt(0);
      gameMechanics.floatText(next.text, next.x, next.y, next.color);
    }
  }
}
