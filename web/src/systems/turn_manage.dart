import '../game_component.dart';
import '../game_system.dart';
import '../services.dart';
import '../world.dart';
import '../components/actor.dart';

class TurnManager implements GameSystem {
  List<Actor> actors = <Actor>[];
  num initiative = 0;

  @override
  initialize(World world) {
    actors.clear();
    initiative = 0;
  }

  @override
  bool register(GameComponent component) {
    var res = component is Actor;
    if(res) actors.add(component as Actor);
    return res;
  }

  bool run(Actor actor) {
    var res = false;
    if(actor == gameMechanics.player) {
      res = gameMechanics.executeUserInputs();
    } else {
      gameMechanics.runDefaultAi(actor);
      res = true;
    }
    return res;
  }

  @override
  unregister(GameComponent component) {
    actors.remove(component);
  }

  @override
  update(World world) {
    for(var actor in actors) {
      if (run(actor) == false) break;
      actors.sort((a1, a2) => a1.initiative.compareTo(a2.initiative));
    }
  }
}