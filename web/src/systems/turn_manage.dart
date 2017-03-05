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
    if(res) {
      var actor = component as Actor;
      actors.add(actor);
      if (actor.initiative < 1) actor.initiative = initiative + 1;
    }
    return res;
  }

  bool run(Actor actor) {
    var res = false;
    if(actor.entity == gameMechanics.player) {
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
      else {
        initiative = actor.initiative;
      }
    }
    actors.sort((a1, a2) => a1.initiative.compareTo(a2.initiative));
  }

  @override
  updateRealTime(World world) { return; }
}