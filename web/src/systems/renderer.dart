import '../game_component.dart';
import '../game_system.dart';
import '../world.dart';
import '../components/widget.dart';
import '../services.dart';

class Renderer implements GameSystem {
  List<Widget> widgets = <Widget>[];

  @override
  initialize(World world) { }

  @override
  bool register(GameComponent component) {
    var res = false;
    if (component is Widget) {
      widgets.add(component as Widget);
      widgets.sort((w1, w2) => w1.z.compareTo(w2.z));
      res =  true;
    }
    return res;
  }

  @override
  unregister(GameComponent component) {
    if (component is Widget) {
      widgets.add(component as Widget);
    }
  }

  @override
  update(World world) {
    /*var context = gameOutput.context;
    context.clearRect(0, 0, gameOutput.canvas.width, gameOutput.canvas.height);
    for(var widget in widgets) {
      widget.draw(context);
    }*/
    return;
  }

  @override
  updateRealTime(World world) {
    var context = gameOutput.context;
    context.clearRect(0, 0, gameOutput.canvas.width, gameOutput.canvas.height);
    for(var widget in widgets) {
      widget.draw(context);
    }
  }
}