class BandManager {
  ArrayList<Band> bands;
  float rotY;
  int minLength;
  BandManager() {
    bands = new ArrayList<Band>();
    rotY=0;
    minLength=5;
  }
  void addBand(Band _band) {
    if (_band.getLength()>minLength) {
      _band.center();
      bands.add(_band);
    }
  }
  void clearBands() {
    bands = new ArrayList<Band>();
  }
  void frame() {
    for (int i=0; i<bands.size (); i++) {
      Band thisBand=bands.get(i);
      pushMatrix();
      translate(thisBand.geoCenter.x, thisBand.geoCenter.y, thisBand.geoCenter.z);
      rotateY(rotY);
      if(i%2==0){
        bands.get(i).drawPointsSpectrum();
      }else{
        bands.get(i).drawPointsScope();
      }
      translate(-thisBand.geoCenter.x, -thisBand.geoCenter.y, -thisBand.geoCenter.z);
      popMatrix();
    }
    rotY+=0.01;
  }
  void undo(){
    if(bands.size()>0){
      bands.remove(bands.size()-1);
    }
  }
}

