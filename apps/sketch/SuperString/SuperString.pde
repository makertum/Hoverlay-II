import processing.serial.*;
import oscP5.*;
import netP5.*;

import ddf.minim.*;
import ddf.minim.analysis.*;



OscP5 oscP5;
HandManager hm;
BandManager bm;
MusicPlayer mp;
CalibrationManager cm;
Serial port;

boolean fullScreen=true;
boolean gloveOn=true;

void setup() {
  oscP5 = new OscP5(this, 3333);
  hm=new HandManager();
  cm=new CalibrationManager();
  bm=new BandManager();
  if (fullScreen) {
    size(displayWidth, displayHeight, P3D);
  } else {
    size(displayWidth/2, displayHeight/2, P3D);
  }
  smooth();
  noStroke();
  /*
  perspective(radians(45), 
  float(width)/float(height), 
  10, 150000);
  */
  colorMode(HSB, 255);
  strokeCap(ROUND);
  background(0);

  mp=new MusicPlayer(this);

  if (gloveOn) {
    println(Serial.list());
    String portName = "/dev/tty.usbmodem1a111";
    port = new Serial(this, portName, 9600);
  }
}

void draw() {
  mouse();
  mp.frame();
  //hint(DISABLE_DEPTH_MASK);
  //hint(ENABLE_DEPTH_MASK);
  //hint(DISABLE_DEPTH_TEST);
  //hint(ENABLE_DEPTH_SORT);
  //hint(DISABLE_DEPTH_SORT);
  background(0);
  //lights();
  pushMatrix();
  translate(width/2, height/2);
  hm.frame();
  bm.frame();
  popMatrix();
}

boolean sketchFullScreen() {
  return fullScreen;
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/hands/ID-centralXYZ")) {
    int handID = theOscMessage.get(0).intValue();
    float handX = theOscMessage.get(1).floatValue();
    float handY = theOscMessage.get(2).floatValue();
    float handZ = theOscMessage.get(3).floatValue();
    //println(handX+"/"+handY+"/"+handZ);
    hm.update(handID, handX, handY, handZ);
  }
}

void keyPressed() {
  switch(key) {
  case ' ':
    bm.clearBands();
    break;
  case 'z':
    bm.undo();
    break;
  case CODED:
    switch(keyCode) {
    case LEFT:
      mp.previous();
      break;
    case RIGHT:
      mp.next();
      break;
    }
    break;
  }
}

void mouse() {
  if (mousePressed) {
    float[] warped= {
    (float)mouseX-width/2, (float)mouseY-height/2, -20f
    };
    float[] dewarped=cm.dewarp(warped);
    hm.update(-1, dewarped[0], dewarped[1], dewarped[2]);
  }
}

void mouseReleased() {
  float[] warped= {
    (float)mouseX-width/2, (float)mouseY-height/2, 20f
  };
  float[] dewarped=cm.dewarp(warped);
  hm.update(-1, dewarped[0], dewarped[1], dewarped[2]);
}

