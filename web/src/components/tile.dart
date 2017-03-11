import 'dart:html';
import '../color.dart';

class Tile {
  String glyph = '#';
  Color background = new Color(96, 80, 0);
  Color color = new Color();
  bool blockLos = true;
  bool blocksMovement = true;
  bool inLos = false;
  bool isEndOfLevel = false;
  bool providesCover = true;
  ImageElement sprite =  null;
  bool visited = false;

  draw(CanvasRenderingContext2D context, num x, num y, num width, num height, [bool showForeground = true]) {
    context.setFillColorRgb(
        background.r, background.g, background.b);
    context.fillRect(x - width~/2, y - height~/2, width, height);
    if(showForeground) {
      context.setFillColorRgb(color.r, color.g, color.b);
      context.fillText(glyph, x, y);
    }
  }

  Tile.fromChar(String char) {
    glyph = char;
    switch(glyph) {
    // Note that default values area for walls '#'
      case '#':
        color = new Color(194, 194, 214);
        background = new Color(61, 61, 67);
        break;
      case '▲':
        color = new Color(255, 215, 0);
        break;
      case '.': // floor
        blockLos = false;
        blocksMovement = false;
        providesCover = false;
        color = new Color(255, 215, 0);
        break;
      case ' ': // floor
        blockLos = false;
        blocksMovement = false;
        providesCover = false;
        color = new Color(255, 225, 0);
        background = new Color(61, 61, 67);
        break;
      case '>': // exits
      case '?':
      case '»':
      case '∩':
        blockLos = false;
        blocksMovement = false;
        isEndOfLevel = true;
        providesCover = false;
        break;
      case '~': // water
        blockLos = false;
        color = new Color(64, 127, 255);
        providesCover = false;
        break;
      case '♣':
        blockLos = false;
        color = new Color(127, 225, 32);
    }
  }

  static Tile get invalidTile => new Tile.fromChar('\\');

  @override String toString() {
    var res = new StringBuffer()
      ..write(r'{"type"="tile", ')
      ..write('\"glyph\"=\"$glyph\", ')
      ..write('\"blockLos\"=$blockLos, ')
      ..write('\"blocksMovement\"=$blocksMovement, ')
      ..write('\"inLos\"=$inLos, ')
      ..write('\"visited\"=$visited, ')
      ..write('\"color\"=$color, ')
      ..write('\"background\"=$background }');
    return res.toString();
  }
}
