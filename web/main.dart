// Copyright (c) 2017, Luca Carbone. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'src/services.dart' as services;
import 'src/world.dart';

void main() {
  var world = new World();
  world.initialize();
  services.initialize(world);
  services.gameMechanics.generateLevel();
  world.update();
}
