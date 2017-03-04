import '../game_component.dart';
import '../game_system.dart';
import '../world.dart';
import '../components/game_map.dart';
import '../components/physical_object.dart';
import '../services.dart';

class GridManager implements GameSystem {
  num fovRadius = 9;
  GameMap _map;
  List<PhysicalObject> _objects = <PhysicalObject>[];

  calculateFoV(num cx, num cy) {
    var minX = (cx - fovRadius < 0) ? 0 : cx - fovRadius;
    var minY = (cy - fovRadius < 0) ? 0 : cy - fovRadius;
    var maxX = (cx + fovRadius < _map.width) ? cx - fovRadius : _map.width;
    var maxY = (cy + fovRadius < _map.height) ? cy - fovRadius : _map.height;
    for(num y = minY; y < maxY; y++) {
      for(num x = minX; x < maxX; x++) {
        _map.at(x, y).inLos = inLoS(cx, cy, x, y);
      }
    }
  }

  @override
  initialize(World world) {
    // TODO: implement initialize
  }

  bool inLoS(num x0, num y0, num x1, num y1){
    var tmp;
    var steep = (y1-y0).abs() > (x1-x0).abs();
    if(steep){
      //swap x0,y0
      tmp=x0; x0=y0; y0=tmp;
      //swap x1,y1
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
    var ystep = y0 < y1 ? 1 : -1;
    var y = y0;

    for(num x = x0+1; x <= x1-1; x++){
      if(!(steep ? map[sign*x][y] != '#' : map[y][sign*x] != '#')) {
        if (x < x1-1) return false;
      }
      err = (err - dy);
      if(err < 0){
        y += ystep;
        err += dx;
      }
    }
    return true;
  }

  @override
  bool register(GameComponent component) {
    var res = false;
    if(component is GameMap) {
      _map = component as GameMap;
      res = true;
    } else if(component is PhysicalObject) {
      _objects.add(component as PhysicalObject);
      res = true;
    }
    return res;
  }

  @override
  unregister(GameComponent component) {
    // TODO: implement unregister
  }

  @override
  update(World world) {
    var player = world.getComponent(PhysicalObject, gameMechanics.player) as PhysicalObject;
    calculateFoV(player.x, player.y);
  }
}