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
  num _waitTime = 0;
  num waitTime = 750;
  num refTime = 0;

  AnimatedTextQueue([num entity = World.GENERIC_ENTITY])
      : super(entity) {}

  addCenteredText(String text, Color color) {
    var next = new NextText()
      ..color = color
      ..text = text
      ..renderer = null;
    animations.add(next);
  }

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
    //print('AnimatedTextQueue: in queue ${animations.length}, next in ${_waitTime - refTime}');
    if (animations.length > 0 && refTime > _waitTime) {
      refTime = 0;
      _waitTime = waitTime;
      var next = animations.removeAt(0);
      //print('AnimatedTextQueue: creating text ${next.text}, next in ${_waitTime - refTime}');
      if (next.renderer == null) {
        gameMechanics.floatText(
            next.text, gameOutput.width~/2, gameOutput.height~/2, next.color);
      } else {
        gameMechanics.floatText(
            next.text, next.renderer.x, next.renderer.y, next.color);
      }
    } else if (animations.length == 0 && refTime > _waitTime) {
      deleteMe = true;
    } else {
      //print('AnimatedTextQueue: next in ${_waitTime - refTime}');
    }
  }
}
