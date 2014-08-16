class Band {
  float rotY=0;
  ArrayList<PVector> points;
  float xMin, xMax, yMin, yMax, zMin, zMax;
  PVector geoCenter, gravCenter;
  BandManager parent;
  Band() {
    rotY=bm.rotY;
    points = new ArrayList<PVector>();
    geoCenter=new PVector(0, 0, 0);
    gravCenter=new PVector(0, 0, 0);
  }
  int getLength() {
    return points.size();
  }
  void addPoint(PVector _point) {
    if (points.size()==0) {
      println("adding first point "+_point.x+"/"+_point.y+"/"+_point.z);
      xMax=_point.x;
      yMax=_point.y;
      zMax=_point.z;
      xMin=_point.x;
      yMin=_point.y;
      zMin=_point.z;
    } else {
      println("adding another point "+_point.x+"/"+_point.y+"/"+_point.z);
      xMax=max(xMax, _point.x);
      yMax=max(yMax, _point.y);
      zMax=max(zMax, _point.z);
      xMin=min(xMin, _point.x);
      yMin=min(yMin, _point.y);
      zMin=min(zMin, _point.z);
    }
    points.add(_point);
  }
  void center() {
    geoCenter = new PVector((xMax+xMin)/2.0, (yMax+yMin)/2.0, (zMax+zMin)/2.0);
    xMax-=geoCenter.x;
    yMax-=geoCenter.y;
    zMax-=geoCenter.z;
    for (int i=0; i<points.size (); i++) {
      PVector thisPoint = points.get(i);
      thisPoint.set(thisPoint.x-geoCenter.x, thisPoint.y-geoCenter.y, thisPoint.z-geoCenter.z);
    }
    /*
    float gravX=0, gravY=0, gravZ=0;
     for (int i=0; i<points.size (); i++) {
     PVector thisPoint=points.get(i);
     gravX+=thisPoint.x;
     gravY+=thisPoint.y;
     gravZ+=thisPoint.z;
     }
     gravX/=points.size();
     gravY/=points.size();
     gravZ/=points.size();
     gravCenter=new PVector(gravX,gravY,gravZ);
     */
  }

  void drawPoints() {
    if (points.size()>1) {
      for (float a=0.25; a<=1; a+=0.25) {
        PVector lastPoint=points.get(0);
        float tpBeat=mp.fftMix.getBand(0);
        for (int i=1; i<points.size (); i++) {
          PVector thisPoint=points.get(i);
          float hue=map(i, 1, points.size()-1, 0, 255);
          int band=round(log(i))%mp.fftMix.specSize();
          tpBeat=0.8*tpBeat+0.2*mp.fftMix.getBand(band);
          float scaler=tpBeat*sqrt(band+1)/100.0;
          strokeWeight(5+(1.0-a)*50*scaler);
          stroke(hue, 255, 255, a*255);
          noFill();
          line(lastPoint.x, lastPoint.y, lastPoint.z, thisPoint.x, thisPoint.y, thisPoint.z);
          point(thisPoint.x, thisPoint.y, thisPoint.z);
          lastPoint=thisPoint;
        }
      }
    }
  }
  void drawPointsSpectrum() {
    if (points.size()>1) {
      for (float a=0.25; a<=1; a+=0.25) {
        PVector lastPoint=points.get(0).get();
        float tpBeat=mp.fftMix.getBand(0);
        for (int i=1; i<points.size (); i++) {
          PVector thisPoint=points.get(i).get();
          float hue=map(i, 1, points.size()-1, 0, 255);
          int band=round(log(i))%mp.specSize;
          tpBeat=0.8*tpBeat+0.2*mp.fftMix.getBand(band);
          float scaler=tpBeat*sqrt(band+1)/100.0;
          thisPoint.mult(1+scaler/40);
          strokeWeight(5+(1.0-a)*50*scaler);
          stroke(hue, 255, 255, a*255);
          noFill();
          pushMatrix();
          rotateY(rotY-scaler*0.1);
          //rotateZ(-scaler*0.1);
          line(lastPoint.x, lastPoint.y, lastPoint.z, thisPoint.x, thisPoint.y, thisPoint.z);
          point(thisPoint.x, thisPoint.y, thisPoint.z);
          popMatrix();
          lastPoint=thisPoint;
        }
      }
    }
  }
  void drawPointsScope() {
    if (points.size()>1) {
      for (float a=0.25; a<=1; a+=0.25) {
        PVector lastPoint=points.get(0).get();
        float lastSampleOffset=0;
        float tpSample=mp.samplesMix.get(0);
        for (int i=1; i<points.size (); i++) {
          PVector thisPoint=points.get(i).get();
          float hue=map(i, 1, points.size()-1, 0, 255);
          int band=round(log(i))%mp.specSize;
          int sample=i%mp.bufferSize;
          tpSample=0.8*tpSample+0.2*mp.samplesMix.get(sample);
          float sampleOffset=mp.samplesMix.get(sample)*50;
          strokeWeight(2+(1.0-a)*20);
          stroke(hue, 255, 255, a*255);
          noFill();
          pushMatrix();
          rotateY(rotY);
          //rotateZ(-scaler*0.1);
          line(lastPoint.x, lastPoint.y, lastPoint.z+lastSampleOffset, thisPoint.x, thisPoint.y, thisPoint.z+sampleOffset);
          point(thisPoint.x, thisPoint.y, thisPoint.z+sampleOffset);
          popMatrix();
          lastPoint=thisPoint;
          lastSampleOffset = sampleOffset;
        }
      }
    }
  }
}

