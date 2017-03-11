import 'dart:html';
import '../color.dart';
import '../services.dart';
import '../world.dart';
import '../services/game_mechanics.dart';

class UserInput {
  Element _focusElement;
  bool stopInputs = false;
  World _world;

  UserInput(World this._world, Element this._focusElement) {
    querySelector("body").onKeyPress.listen(onKeyPressed);
  }

  onKeyPressed(KeyboardEvent evt) {
    switch (gameMechanics.state) {
      case GameState.DEAD:
        gameOutput.clear();
        gameMechanics.hideFade();
        gameMechanics.showTitle();
        gameMechanics.generateLevel();
        gameMechanics.state = GameState.TITLE;
        break;
      case GameState.HELP:
        gameMechanics.hideFade();
        gameMechanics.state = GameState.PLAY;
        gameMechanics.displayLevelIntro();
        break;
      case GameState.PLAY:
        _onKeyPressed(evt);
        break;
      case GameState.TITLE:
        //gameMechanics.hideFade();
        gameMechanics.showHelp();
        gameMechanics.state = GameState.HELP;
        break;
    }
  }

  _onKeyPressed(KeyboardEvent evt) {
    //if(_focusElement.focus == false) {
    if(stopInputs == false) {
      var keyEvent = new KeyEvent.wrap(evt);
      print("UserInput.onKeyPressed: ${keyEvent.keyCode}");
      if (keyEvent.keyCode == 97) { // a
        gameMechanics.move(gameMechanics.player, -1, 0);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 100) { // d
        gameMechanics.move(gameMechanics.player, 1, 0);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 119) { // s
        gameMechanics.move(gameMechanics.player, 0, -1);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 115) { // w
        gameMechanics.move(gameMechanics.player, 0, 1);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 99 || keyEvent.keyCode == 46) { // c, .
        gameMechanics.move(gameMechanics.player, 0, 0);
        gameMechanics.runAis();
      } else if (keyEvent.keyCode == 113) { // q
        gameMechanics.updateVisibility();
        gameMechanics.selectNext();
      } else if (keyEvent.keyCode == 102) { // f
        gameMechanics.attack(gameMechanics.player, gameMechanics.target);
        gameMechanics.runAis();
        gameMechanics.draw(gameMechanics.player, true);
      } else if (keyEvent.keyCode == 101) { // e
        if(gameMechanics.draw(gameMechanics.player, false) == true) {
          print("BUSTED");
          gameMechanics.draw(gameMechanics.player, true);
          gameMechanics.floatTextDeferred('BUSTED', null ,new Color(255, 0, 255));
          gameMechanics.runAis();
        } else {
          gameMechanics.updateVisibility();
        }
      } else {
        print("Unknown command");
      }
      //print("New position ${world.player}");
      _world.update();
    }
  }
}
