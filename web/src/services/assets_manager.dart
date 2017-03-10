import 'dart:html';
import 'dart:web_audio';

class AssetsManager {
  AudioContext _audioContext = new AudioContext();
  Map<String, AudioBuffer> _sounds = <String, AudioBuffer>{};

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

  }

  loadSound(String asset) async {
    //var gainNode = _audioContext.createGain();
    HttpRequest req;
    try {
      req = await HttpRequest.request('assets/$asset', responseType: 'arraybuffer');
    } catch (e) {
      print('AssetsManager.loadSound: error getting sound $asset');
      return;
    }
    AudioBuffer audioBuffer = await _audioContext.decodeAudioData(req.response);
    //var source = _audioContext.createBufferSource();
    //source.buffer = audioBuffer;
    //source.connectNode(gainNode, 0, 0);
    //source.connectNode(_audioContext.destination);
    _sounds[asset.split('.')[0]] = audioBuffer;
  }
}