import '../services.dart';
import '../data/map_data.dart';

class Block {
  List<String> block;
  dynamic north = 0; // 1 means fill me
  dynamic south = 0; // 1 means fill me
  dynamic east = 0; // 1 means fill me
  dynamic west = 0; // 1 means fill me
}

class MapFactory {
  var start = [2, 2];
  var end = [2, 2];

  List<String> _doubleListToSingle(List<List<String>> source) {
    var res = <String>[];
    for(var row in source) {
      res.add(row.join());
    }
    return res;
  }

  List<String> generate(String template) {
    var res = <String>[];
    var source = mapData[template];
    if(source != null && source['blocks'] != null) {
      res = _generateFromBlocks(source);
    } else if(source != null && source['type'] == 'desert') {
      res = _generateMine(40, 30, 2);
    } else {
      for (var y = 0; y < 480 / 24; y++) {
        var row = '';
        for (var x = 0; x < 640 / 24; x++) {
          row += (rng.nextInt(100) < 90) ? '.' : '#';
        }
        res.add(row);
      }
    }
    return res;
  }

  List<String> _generateDesert(num width, num height) {
    num halfHeight = (height/2).round();
    var res = <List<String>>[];
    for (var y = 0; y < height; y++) {
      var row = <String>[];
      for (var x = 0; x < width; x++) {
        int probFree = 10 * (halfHeight - y).abs() ~/ halfHeight;  //(y < height/2) ? 1 : 100;
        var next = (rng.nextInt(100) > probFree * probFree) ? '.' : '#';
        if (next == '.') next = (rng.nextInt(100) > 95) ? '♣' : '.';
        row.add(next);
      }
      res.add(row);
    }
    start = [0, rng.nextInt(height)];
    num currentX = start[0];
    num currentY = start[1];
    while(currentX < width) {
      print("MapFactory._generateDesert: Trying to set $currentX, $currentY");
      res[currentY][currentX] = '.';
      var next = rng.nextInt(3);
      switch(next) {
        case 0: currentX++; break;
        case 1: currentY++; break;
        case 2: currentY--; break;
      }
      currentY = (currentY > height - 1) ? height - 1 : (currentY < 0) ? 0 : currentY;
    }
    return _doubleListToSingle(res);
  }

  List<String> _generateMine(num width, num height, num caveLength) {
    var res = <List<String>>[];
    for (var y = 0; y < height; y++) {
      var row = <String>[];
      for (var x = 0; x < width; x++) {
        row.add('#');
      }
      res.add(row);
    }
    start = [rng.nextInt(width), rng.nextInt(height)];
    num currentX = start[0];
    num currentY = start[1];
    var direction = [1, 0];
    while(currentX < width - 2) {
      print("MapFactory._generateMine: Trying to set $currentX, $currentY");
      var runLength = rng.nextInt(caveLength) + 1;
      for (var i = 0;  i < runLength; i++) {
        res[currentY][currentX] = '.';
        currentX += direction[0];
        currentY += direction[1];
        currentY = (currentY > height - 2) ? height - 2 : (currentY < 1) ? 1 : currentY;
        currentX = (currentX > width - 2) ? width - 2 : (currentX < 1) ? 1 : currentX;
      }

      var next = rng.nextInt(4);
      switch(next) {
        case 0: direction = [1, 0]; break;
        case 1: direction = [-1, 0]; break;
        case 2: direction = [0, 1]; break;
        case 3: direction = [0, -1]; break;
      }
    }
    return _doubleListToSingle(res);
  }

  List<String> _generateFromBlocks(Map source) {
    var blocks = source['blocks'];
    var howManyToEnd = source['howManyToEnd'];
    var root = _randomDataBlock(blocks);
    Block last = root;
    for(var i = 0; i < howManyToEnd; i++) {
      last = _addBlock(root, last, blocks);
    }
  }

  Block _addBlock(Block root, Block last, List dataBlocks) {
    Block res;
    if (last.east == 1) {
      last.east = _randomDataBlock(dataBlocks);
    } else if (last.south == 1) {
      last.south = _randomDataBlock(dataBlocks);
    } else if (last.north == 1) {
      last.north = _randomDataBlock(dataBlocks);
    } else if (last.west == 1) {
      //last.east = _randomDataBlock(dataBlocks);
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