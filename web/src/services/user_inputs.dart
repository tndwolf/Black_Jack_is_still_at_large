import 'dart:html';
import '../services.dart';
import '../world.dart';

class UserInput {
  Element _focusElement;
  bool stopInputs = false;
  World _world;

  UserInput(World this._world, Element this._focusElement) {
    querySelector("body").onKeyPress.listen(onKeyPressed);
  }

  onKeyPressed(KeyboardEvent evt) {
    //if(_focusElement.focus == false) {
    if(stopInputs == false) {
      var keyEvent = new KeyEvent.wrap(evt);
      //print("UserInput.onKeyPressed: ${keyEvent.keyCode}");
      if (keyEvent.keyCode == 97) {
        gameMechanics.move(gameMechanics.player, -1, 0);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 100) {
        gameMechanics.move(gameMechanics.player, 1, 0);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 119) {
        gameMechanics.move(gameMechanics.player, 0, -1);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 115) {
        gameMechanics.move(gameMechanics.player, 0, 1);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 113) { // q
        gameMechanics.selectNext();
      } else if (keyEvent.keyCode == 101) { // e
        gameMechanics.attack(gameMechanics.player, gameMechanics.target);
        gameMechanics.runAis();
        gameMechanics.draw(gameMechanics.player, true);
      } else if (keyEvent.keyCode == 32) { // space
        gameMechanics.draw(gameMechanics.player, false);
      } else {
        print("Unknown command");
      }
      //print("New position ${world.player}");
      _world.update();
    }
  }
}
