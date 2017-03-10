import 'dart:html';
import 'dart:web_audio';

class AssetsManager {
  AudioContext _audioContext = new AudioContext();
  Map<String, ImageElement> _sprites = <String, ImageElement>{};
  Map<String, AudioBuffer> _sounds = <String, AudioBuffer>{};

  getSprite(String name) {
    return _sprites[name];
  }

  playSound(String name) {
    _audioContext.createBufferSource()
      ..buffer = _sounds[name]
      ..connectNode(_audioContext.destination)
      ..start(0);
  }

  load(List<String> assets) {
    for(var asset in assets) {
      var assetComponents = asset.split('.');
      switch(assetComponents[1]) {
        case 'png': loadImage(asset); break;
        case 'wav': loadSound(asset); break;
      }
    }
  }

  loadImage(String asset) {
    _sprites[asset.split('.')[0]] = new ImageElement(src: 'assets/$asset');
  }

  loadSound(String asset) async {
    HttpRequest req;
    try {
      req = await HttpRequest.request('assets/$asset', responseType: 'arraybuffer');
    } catch (e) {
      print('AssetsManager.loadSound: error getting sound $asset');
      return;
    }
    AudioBuffer audioBuffer = await _audioContext.decodeAudioData(req.response);
    _sounds[asset.split('.')[0]] = audioBuffer;
  }
}