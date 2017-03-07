import '../services.dart';

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
    switch(template) {
      case 'desert': res = _generateDesert(40, 30); break;
      case 'mine': res = res = _generateMine(40, 30, 2); break;
      default:
        for (var y = 0; y < 480 / 24; y++) {
          var row = '';
          for (var x = 0; x < 640 / 24; x++) {
            row += (rng.nextInt(100) < 90) ? ' ' : '#';
          }
          res.add(row);
        }
        break;
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
        var next = (rng.nextInt(100) > probFree * probFree) ? ' ' : '#';
        if (next == ' ') next = (rng.nextInt(100) > 95) ? '♣' : ' ';
        row.add(next);
      }
      res.add(row);
    }
    start = [0, rng.nextInt(height)];
    num currentX = start[0];
    num currentY = start[1];
    while(currentX < width) {
      //print("MapFactory._generateDesert: Trying to set $currentX, $currentY");
      res[currentY][currentX] = ' ';
      end[1] = currentY;
      var next = rng.nextInt(3);
      switch(next) {
        case 0: currentX++; break;
        case 1: currentY++; break;
        case 2: currentY--; break;
      }
      currentY = (currentY > height - 1) ? height - 1 : (currentY < 0) ? 0 : currentY;
    }
    end[0] = currentX-1;
    //print("MapFactory._generateDesert: Trying to end at $end");
    res[end[1]][end[0]] = '»';
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
      //print("MapFactory._generateMine: Trying to set $currentX, $currentY");
      var runLength = rng.nextInt(caveLength) + 1;
      for (var i = 0;  i < runLength; i++) {
        res[currentY][currentX] = ' ';
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
    var halfWidth = width~/2;
    var halfHeight = height~/2;
    var endQuadrant = [
      (start[0] < halfWidth) ? 1 : 0,
      (start[1] < halfHeight) ? 1 : 0,
    ];
    num i = 0;
    do {
      end = [
        rng.nextInt(halfWidth-1) + endQuadrant[0] * halfWidth,
        rng.nextInt(halfHeight-1) + endQuadrant[1] * halfHeight
      ];
      //print("MapFactory._generateMine: Start was $start");
      //print("MapFactory._generateMine: End quadrant $endQuadrant");
      //print("MapFactory._generateMine: Halfsize $halfWidth, $halfHeight");
      //print("MapFactory._generateMine: Trying to end at $end");
    } while (res[end[1]][end[0]] != ' ' && i++ < 1000);
    if (i > 1000) {
      end = [currentX, currentY];
    }
    //print("MapFactory._generateMine: Trying to end at $end");
    res[end[1]][end[0]] = '>';
    return _doubleListToSingle(res);
  }
}