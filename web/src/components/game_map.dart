import 'dart:html';
import 'widget.dart';
import '../color.dart';
import '../game_component.dart';
import '../services.dart';

class Tile {
  String glyph = '#';
  Color background = new Color(127, 100, 0);
  Color color = new Color();
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
        color = new Color(255, 225, 0);
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
      for(var c = 0; c < row.length; c++) {
        newRow.add(new Tile.fromChar(row[c]));
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
    var halfCellWidth = cellWidth/2;
    var halfCellHeight = cellHeight/2;
    num x = halfCellWidth;
    num y = halfCellHeight;
    for(var row in _map) {
      for(var tile in row) {
        context.setFillColorRgb(tile.background.r, tile.background.g, tile.background.b);
        context.fillRect(x - halfCellWidth, y - halfCellHeight, cellWidth, cellHeight);
        context.setFillColorRgb(tile.color.r, tile.color.g, tile.color.b);
        context.fillText(tile.glyph, x, y);
        x += cellWidth;
      }
      x = cellWidth/2;
      y += cellHeight;
    }
  }
}