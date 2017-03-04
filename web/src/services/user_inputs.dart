import 'dart:html';
import '../world.dart';

class UserInput {
  Element _focusElement;
  World _world;

  UserInput(World this._world, Element this._focusElement) {
    querySelector("body").onKeyPress.listen(onKeyPressed);
  }

  onKeyPressed(KeyboardEvent evt) {
    //if(_focusElement.focus == false) {
      var keyEvent = new KeyEvent.wrap(evt);
      print("Received ${keyEvent.keyCode}");
      /*if(keyEvent.keyCode == 97) world.move(world.player, -1, 0);
      else if(keyEvent.keyCode == 100) world.move(world.player, 1, 0);
      else if(keyEvent.keyCode == 119) world.move(world.player, 0, -1);
      else if(keyEvent.keyCode == 115) world.move(world.player, 0, 1);
      else if(keyEvent.keyCode == 113) world.selectNext();
      else if(keyEvent.keyCode == 101) attack();
      else if(keyEvent.keyCode == 32) draw(false);
      else print("Unknown command");*/
      //print("New position ${world.player}");
      _world.update();
    //}
  }
}