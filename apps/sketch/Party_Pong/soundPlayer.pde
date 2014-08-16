class SoundPlayer {
  Minim minim;
  ArrayList<AudioPlayer> players;
  FFT fft;
  int songCounter=0;
  String[] fileNames;
  SoundPlayer(Minim _minim) {
    minim=_minim;
    println("Heey!");
    File folder = new File(sketchPath("sounds"));
    java.io.FilenameFilter audioFilter = new java.io.FilenameFilter() {
      boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(".mp3") || name.toLowerCase().endsWith(".wav");
      }
    };
    fileNames = folder.list(audioFilter);
    println(fileNames.length + " music files in specified directory:");
    for (int i = 0; i < fileNames.length; i++) {
      println(sketchPath("sounds/"+fileNames[i]));
    }
    players=new ArrayList<AudioPlayer>();
    for (int i = 0; i < fileNames.length; i++) {
      players.add(minim.loadFile(sketchPath("sounds/"+fileNames[i])));
    }
  }
  
  void play(String _name){
    for(int i=0;i<fileNames.length;i++){
      if(_name.equals(fileNames[i])){
        AudioPlayer thisPlayer=players.get(i);
        thisPlayer.play();
        thisPlayer.rewind();
        return;
      }
    }
    println("error: sample not found!");
  }
}

