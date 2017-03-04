import '../services.dart';

class MapFactory {
  List<String> generate() {
    var res = <String>[];
    for(var y = 0; y < 24; y++) {
      var row = '';
      for(var x = 0; x < 32; x++) {
        row += (rng.nextInt(100) < 90 ) ? '.' : '#';
      }
      res.add(row);
    }
    return res;
  }
}