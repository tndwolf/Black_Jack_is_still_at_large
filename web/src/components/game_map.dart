import 'dart:html';
import 'tile.dart';
import 'widget.dart';
import '../color.dart';
import '../game_component.dart';
import '../services.dart';

class GameMap extends GameComponent implements Widget {
  num cellHeight = 16;
  num cellWidth = 16;
  num centerX = 0;
  num centerY = 0;
  List<List<Tile>> _map;
  num get height => _map.length;
  num get width => _map[0].length;
  num get offsetX => 0;//-centerX * cellWidth~/2;
  num get offsetY => 0;//-centerY * cellHeight~/2;
  num x = 0;
  num y = 0;
  num z = 0;

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
  draw(CanvasRenderingContext2D context, [num offsetX = 0, num offsetY = 0]) {
    context.font = gameOutput.asciiFont;
    context.textAlign = 'center';
    context.textBaseline = 'middle';
    var halfCellWidth = cellWidth~/2;
    var halfCellHeight = cellHeight~/2;
    num x = halfCellWidth - offsetX;
    num y = halfCellHeight - offsetY;
    num cellX = 0;
    num cellY = 0;
    for(var row in _map) {
      for(var tile in row) {
        //if (tile.inLos) {
          tile.draw(context, x, y, cellWidth, cellHeight, !gameMechanics.isOccupied(cellX, cellY));
        /*} else if (tile.visited) {
          context.globalAlpha = 0.3;
          tile.draw(context, x, y, cellWidth, cellHeight);
          context.globalAlpha = 1;
        }*/
        x += cellWidth;
        cellX++;
      }
      x = halfCellWidth - offsetX;
      y += cellHeight;
      cellX = 0;
      cellY++;
    }
  }

  @override String toString() {
    var res = new StringBuffer();
    res..write(r'{"type": "GameMap", "entity": ')
      ..write("$entity, ")
      ..write(r'"map": [[');
    var smap = <String>[];
    for(var row in _map) {
      var srow = <String>[];
      for (var tile in row) {
        srow.add(tile.toString());
      }
      smap.add(srow.join(','));
    }
    res.write(smap.join('],['));
    res.write(']]}');
    return res.toString();
  }
}