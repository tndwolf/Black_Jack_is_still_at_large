// Copyright (c) 2017, Luca Carbone. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'src/services.dart' as services;
import 'src/world.dart';

var assets = [
  'reload_01.wav',
  'shot_01.wav',
  'miss_01.wav',
  'hat.png',
  'hat_blood.png',
  'title.png'
];

void main() {
  var world = new World();
  world.initialize();
  services.initialize(world);
  services.loadAssets(assets);
  services.gameMechanics.generateLevel();
  world.update();
  world.updateRealTime();
  services.gameOutput.clear();
  services.gameMechanics.showTitle();
}
