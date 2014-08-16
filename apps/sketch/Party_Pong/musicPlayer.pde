class MusicPlayer {
  PApplet parent;
  Minim minim;
  ArrayList<AudioPlayer> players;
  FFT fftMix, fftLeft, fftRight;
  int songCounter=0;
  int bufferSize=0;
  int specSize=0;
  String[] fileNames;
  AudioBuffer samplesLeft, samplesRight, samplesMix;
  MusicPlayer(PApplet _parent) {
    parent=_parent;
    minim = new Minim(_parent);
    println("Heey!");
    File folder = new File(sketchPath("music"));
    java.io.FilenameFilter audioFilter = new java.io.FilenameFilter() {
      boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(".mp3") || name.toLowerCase().endsWith(".wav");
      }
    };
    fileNames = folder.list(audioFilter);
    println(fileNames.length + " music files in specified directory:");
    for (int i = 0; i < fileNames.length; i++) {
      println(sketchPath("music/"+fileNames[i]));
    }
    players=new ArrayList<AudioPlayer>();
    for (int i = 0; i < fileNames.length; i++) {
      players.add(minim.loadFile(sketchPath("music/"+fileNames[i])));
    }
    next();
  }
  void frame() {
    if (getCurrentPlayer().isPlaying()) {
      samplesLeft=getCurrentPlayer().left;
      samplesRight=getCurrentPlayer().right;
      samplesMix=getCurrentPlayer().mix;
      fftMix.forward(samplesMix);
      fftLeft.forward(samplesLeft);
      fftRight.forward(samplesRight);
    } else {
      next();
      frame();
    }
  }
  void next() {
    if (fileNames.length>0) {
      getCurrentPlayer().pause();
      getCurrentPlayer().rewind();
      songCounter++;
      songCounter%=fileNames.length;
      getCurrentPlayer().play();
      fftMix = new FFT(getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      fftLeft = new FFT( getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      fftRight = new FFT( getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      bufferSize=getCurrentPlayer().bufferSize();
      specSize=fftMix.specSize();
    }
  }
  void previous() {
    if (fileNames.length>0) {
      getCurrentPlayer().pause();
      getCurrentPlayer().rewind();
      songCounter--;
      songCounter%=fileNames.length;
      getCurrentPlayer().play();
      fftMix = new FFT(getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      fftLeft = new FFT( getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      fftRight = new FFT( getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      bufferSize=getCurrentPlayer().bufferSize();
      specSize=fftMix.specSize();
    }
  }
  void current() {
    if (fileNames.length>0) {
      getCurrentPlayer().pause();
      getCurrentPlayer().rewind();
      getCurrentPlayer().play();
      fftMix = new FFT(getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      fftLeft = new FFT( getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      fftRight = new FFT( getCurrentPlayer().bufferSize(), getCurrentPlayer().sampleRate());
      bufferSize=getCurrentPlayer().bufferSize();
      specSize=fftMix.specSize();
    }
  }
  AudioPlayer getCurrentPlayer() {
    return players.get(songCounter);
  }
}

