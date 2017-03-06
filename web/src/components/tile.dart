import '../color.dart';

class Tile {
  String glyph = '#';
  Color background = new Color(96, 80, 0);
  Color color = new Color();
  bool blockLos = true;
  bool blocksMovement = true;
  bool inLos = false;
  bool isEndOfLevel = false;
  bool visited = false;

  Tile.fromChar(String char) {
    glyph = char;
    switch(glyph) {
    // Note that default values area for walls '#'
      case '.': // floor
      case ' ':
        blockLos = false;
        blocksMovement = false;
        color = new Color(255, 225, 0);
        break;
      case '>': // exits
      case '?':
      case '∩':
        blockLos = false;
        blocksMovement = false;
        isEndOfLevel = true;
        break;
      case '~': // water
        blockLos = false;
        color = new Color(64, 127, 255);
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
