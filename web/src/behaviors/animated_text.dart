import '../game_component.dart';
import '../world.dart';
import '../components/text_box.dart';

class AnimatedText extends Behavior {
  num fadeOutMillis = 1000;
  num refTime = 0;
  TextBox textBox;

  AnimatedText(TextBox this.textBox, [num entity = World.GENERIC_ENTITY])
      : super(entity) {}

  @override
  update(World world) {
    var deltaTime = 20;
    refTime += deltaTime;
    var alpha = (1000 - refTime) / fadeOutMillis;
    textBox.background.a = alpha;
    textBox.color.a = alpha;
    if (alpha <= 0) deleteMe = true;
  }
}
