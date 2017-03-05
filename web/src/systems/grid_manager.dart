import '../game_component.dart';
import '../game_system.dart';
import '../world.dart';
import '../components/game_map.dart';
import '../components/physical_object.dart';
import '../services.dart';

class GridManager implements GameSystem {
  num fovClearance = 1;
  num fovRadius = 9;
  GameMap map;
  List<PhysicalObject> _objects = <PhysicalObject>[];

  calculateFoV(num cx, num cy) {
    map.centerX = cx;
    map.centerY = cy;
    clearFoV(cx, cy);
    var minX = (cx - fovRadius < 0) ? 0 : cx - fovRadius;
    var minY = (cy - fovRadius < 0) ? 0 : cy - fovRadius;
    var maxX = (cx + fovRadius < map.width) ? cx + fovRadius : map.width;
    var maxY = (cy + fovRadius < map.height) ? cy + fovRadius : map.height;
    //print("GridManger.calculateFoV: $minX,$minY to $maxX,$maxY");
    var fovRadiusSquared = fovRadius * fovRadius;
    for(num y = minY; y < maxY; y++) {
      for(num x = minX; x < maxX; x++) {
        //if((x-cx) * x + y * y < fovRadiusSquared)
        {
          var cell = map.at(x, y)
            ..inLos = inLoS(cx, cy, x, y);
          if (cell.inLos) cell.visited = true;
        }
      }
    }
  }

  clearFoV(num cx, num cy) {
    var fovClearRadius = fovRadius + fovClearance;
    var minX = (cx - fovClearRadius < 0) ? 0 : cx - fovClearRadius;
    var minY = (cy - fovClearRadius < 0) ? 0 : cy - fovClearRadius;
    var maxX = (cx + fovClearRadius < map.width) ? cx + fovClearRadius : map.width;
    var maxY = (cy + fovClearRadius < map.height) ? cy + fovClearRadius : map.height;
    //print("GridManger.calculateFoV: $minX,$minY to $maxX,$maxY");
    for(num y = minY; y < maxY; y++) {
      for(num x = minX; x < maxX; x++) {
        {
          map.at(x, y).inLos = false;
        }
      }
    }
  }

  List<num> getAllInFoV() {
    var res = <num>[];
    for(var obj in _objects) {
      if (map.at(obj.x, obj.y).inLos) res.add(obj.entity);
    }
    return res;
  }

  @override
  initialize(World world) {
    map = null;
    _objects.clear();
  }

  bool inLoS(num x0, num y0, num x1, num y1){
    var tmp;
    var steep = (y1-y0).abs() > (x1-x0).abs();
    if(steep){
      tmp=x0; x0=y0; y0=tmp;
      tmp=x1; x1=y1; y1=tmp;
    }

    num sign = 1;
    if(x0>x1){
      sign = -1;
      x0 *= -1;
      x1 *= -1;
    }
    var dx = x1-x0;
    var dy = (y1-y0).abs();
    var err = ((dx/2));
    var yStep = y0 < y1 ? 1 : -1;
    var y = y0;

    for(num x = x0; x <= x1-1; x++){
      {
        var checkY = steep ? sign * x : y;
        var checkX = steep ? y : sign * x;
        var tile = map.at(checkX, checkY);
        if (tile.blockLos) return false;
      }
      err = (err - dy);
      if(err < 0){
        y += yStep;
        err += dx;
      }
    }
    return true;
  }

  bool isInLos(num x, num y) {
    return map.at(x, y).inLos;
  }

  @override
  bool register(GameComponent component) {
    var res = false;
    if(component is GameMap) {
      map = component as GameMap;
      res = true;
    } else if(component is PhysicalObject) {
      _objects.add(component as PhysicalObject);
      res = true;
    }
    return res;
  }

  @override
  unregister(GameComponent component) {
    if(component is PhysicalObject) {
      _objects.remove(component);
    }
  }

  @override
  update(World world) {
    var player = world.getComponent(PhysicalObject, gameMechanics.player) as PhysicalObject;
    calculateFoV(player.x, player.y);
  }

  @override
  updateRealTime(World world) { return; }
}