import 'animated_text.dart';
import '../color.dart';
import '../game_component.dart';
import '../world.dart';
import '../services.dart';
import '../components/render_object.dart';

class NextText {
  String text;
  RenderObject renderer;
  Color color;
}

class AnimatedTextQueue extends Behavior {
  List<NextText> animations = <NextText>[];
  num waitTime = 500;
  num refTime = 0;

  AnimatedTextQueue([num entity = World.GENERIC_ENTITY])
      : super(entity) {}

  addText(String text, RenderObject renderer, Color color) {
    var next = new NextText()
      ..color = color
      ..text = text
      ..renderer = renderer;
    animations.add(next);
  }

  @override
  update(World world) {
    var deltaTime = 20;
    refTime += deltaTime;
    print('AnimatedTextQueue: in queue ${animations.length}');
    if (animations.length > 0 && refTime > waitTime) {
      refTime = 0;
      var next = animations.removeAt(0);
      print('AnimatedTextQueue: next text ${next.text}');
      gameMechanics.floatText(next.text, next.renderer.x, next.renderer.y, next.color);
    }
  }
}
