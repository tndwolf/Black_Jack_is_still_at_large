import '../services.dart';
import '../data/map_data.dart';

class Block {
  List<String> block;
  Block north = 0; // 1 means fill me
  Block south = 0; // 1 means fill me
  Block east = 0; // 1 means fill me
  Block west = 0; // 1 means fill me
}

class MapFactory {
  var startX = [2, 2];
  var endX = [2, 2];

  List<String> generate(String template) {
    var res = <String>[];
    var source = mapData[template];
    if(source['blocks'] != null) {
      res = _generateFromBlocks(source);
    } else {
      for (var y = 0; y < 480 / 16; y++) {
        var row = '';
        for (var x = 0; x < 640 / 16; x++) {
          row += (rng.nextInt(100) < 90) ? '.' : '#';
        }
        res.add(row);
      }
    }
    return res;
  }

  List<String> _generateFromBlocks(Map source) {
    var blocks = source['blocks'];
    var howManyToEnd = source['howManyToEnd'];
    var root = _randomDataBlock(blocks);
    Block reference = root;
    for(var i in howManyToEnd) {
      reference = _addBlock(reference, blocks);
    }
  }

  Block _addBlock(Block root, List dataBlocks) {
    Block res;
    if (root.east == 1) {

    }
    return res;
  }

  Block _randomDataBlock(List dataBlocks) {
    var reference = dataBlocks[rng.nextInt(dataBlocks.length)];
    var res = new Block()
      ..block = reference['layout'];
    for(var exit in reference['exits']) {
      switch(exit) {
        case 'N': res.north = 1; break;
        case 'S': res.south = 1; break;
        case 'E': res.east = 1; break;
        case 'W': res.west = 1; break;
      }
    }
    return res;
  }
}