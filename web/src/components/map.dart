import 'dart:html';
import 'widget.dart';
import '../game_component.dart';
import '../services.dart';

class Tile {
  String glyph = '#';
  bool blockLos = true;
  bool blocksMovement = true;
  bool inLos = false;
  bool visited = false;

  Tile.fromChar(String char) {
    glyph = char;
    switch(glyph) {
      // Note that default values area for walls '#'
      case '.': // floor
        blockLos = false;
        blocksMovement = false;
        break;
      case '~': // water
        blockLos = false;
        break;
    }
  }

  static Tile get invalidTile => new Tile.fromChar('\\');
}

class GameMap extends GameComponent implements Widget {
  num cellHeight = 16;
  num cellWidth = 16;
  List<List<Tile>> _map;

  GameMap(num entity, List<String> map): super(entity) {
    _map = <List<Tile>>[];
    for(var row in map) {
      var newRow = <Tile>[];
      for(var char in row) {
        newRow.add(new Tile.fromChar(char));
      }
      _map.add(newRow);
    }
  }

  Tile at(x, y) {
    try {
      return _map[y][x];
    } catch (ex) {
      print("GameMap.At: Invalid access to ($x, $y)");
      return Tile.invalidTile;
    }
  }

  @override
  draw(CanvasRenderingContext2D context) {
    context.font = gameOutput.asciiFont;
    context.textAlign = 'center';
    context.textBaseline = 'middle';
    num x = cellWidth/2;
    num y = cellHeight/2;
    for(var row in _map) {
      for(var tile in row) {
        context.fillText(tile.glyph, x, y);
        x += cellWidth;
      }
      x = cellWidth/2;
      y += cellHeight;
    }
  }
}