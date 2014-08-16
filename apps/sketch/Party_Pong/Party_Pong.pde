import processing.serial.*;
import oscP5.*;
import netP5.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

OscP5 oscP5;
HandManager hm;
MusicPlayer mp;
CalibrationManager cm;
Serial port;

Minim minim;
SoundPlayer sp;

Pong pong;

boolean fullScreen=true;
boolean gloveOn=false;

void setup(){
  if (fullScreen) {
    size(displayWidth, displayHeight, P3D);
  } else {
    size(displayWidth/2, displayHeight/2, P3D);
  }

  minim=new Minim(this);
  sp=new SoundPlayer(minim);
  
  pong=new Pong(displayWidth-100,displayHeight-100);
  oscP5 = new OscP5(this, 3333);
  hm=new HandManager();
  cm=new CalibrationManager();
  smooth();
  strokeCap(ROUND);
  background(0);

  if (gloveOn) {
    println(Serial.list());
    String portName = "/dev/tty.usbmodem1c41";
    port = new Serial(this, portName, 9600);
  }
}

void draw(){
  hm.frame();
  background(0);
  lights();
  pushMatrix();
  translate(width/2, height/2, 0);
  pong.frame();
  popMatrix();
}

boolean sketchFullScreen(){
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
