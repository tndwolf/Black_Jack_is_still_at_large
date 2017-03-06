import '../game_component.dart';
import '../world.dart';
import '../components/text_box.dart';

class AnimatedText extends Behavior {
  List<num> animationPixelPerSec = [0, 0];
  num fadeOutMillis = 1000;
  num refTime = 0;
  TextBox textBox;

  AnimatedText(TextBox this.textBox, [num entity = World.GENERIC_ENTITY])
      : super(entity) {}

  @override
  update(World world) {
    var deltaTime = 20;
    refTime += deltaTime;
    { // color
      var alpha = (1000 - refTime) / fadeOutMillis;
      textBox.background.a = alpha;
      textBox.color.a = alpha;
      if (alpha <= 0) {
        deleteMe = true;
        textBox.deleteMe = true;
      }
    }
    { // position
      textBox.x += animationPixelPerSec[0] * (deltaTime / 1000);
      textBox.y += animationPixelPerSec[1] * (deltaTime / 1000);
    }
  }
}
