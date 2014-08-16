import java.io.File; 
import oscP5.*;
import netP5.*;
OscP5 oscP5;
HandManager hm;
CalibrationManager cm;

boolean fullScreen=true;

void setup() {
  hm=new HandManager();
  cm=new CalibrationManager();
  oscP5 = new OscP5(this, 3333);
  if(fullScreen){
    size(displayWidth, displayHeight, OPENGL);    // use OPENGL rendering for bilinear filtering on texture
  }else{
    size(displayWidth/2, displayHeight/2, OPENGL);    // use OPENGL rendering for bilinear filtering on texture
  }
  /*
  perspective(radians(45), 
   float(width)/float(height), 
   10, 150000);
   */
  smooth();
}

void draw() {
  ortho();
  if (hm.hands.size()>0) {
    if (hm.hands.get(0).pos[2]<0) {
      background(255);
    } else {
      background(0);
    }
  }
  lights();
  textSize(10);
  text(cm.calibrationPath,10,10);
  pushMatrix();
  translate(width/2, height/2, 0);
  sphere(10);
  stroke(0, 0, 255);
  hm.frame();
  if (hm.hands.size()>1) {
    Hand handA=hm.hands.get(0);
    Hand handB=hm.hands.get(1);
    pushMatrix();
    translate((handA.pos[0]+handB.pos[0])/2,(handA.pos[1]+handB.pos[1])/2,(handA.pos[2]+handB.pos[2])/2);
    textSize(32);
    fill(255,0,0);
    text(""+dist(handA.pos[0], handA.pos[1], handA.pos[2], handB.pos[0], handB.pos[1], handB.pos[2]), 0, -50, 0);
    popMatrix();
  }
  popMatrix();
}


void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
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
  case 'c':
    if (hm.hands.size()>0) {
      Hand hand=hm.hands.get(0);
      cm.setCenter(hand.raw);
    }
    break;
  case 'x':
    if (hm.hands.size()>0) {
      Hand hand=hm.hands.get(0);
      cm.calibrateX(hand.raw[0]);
    }
    break;
  case 'y':
    if (hm.hands.size()>0) {
      Hand hand=hm.hands.get(0);
      cm.calibrateY(hand.raw[1]);
    }
    break;
  case 'w':
    cm.rotateX(0.005);
    break;
  case 's':
    cm.rotateX(-0.005);
    break;
  case 'd':
    cm.rotateX(0.005);
    break;
  case 'a':
    cm.rotateX(-0.005);
    break;
  case 'f':
    cm.saveSettings();
    break;
  case 'g':
    cm.loadSettings();
    break;
  case CODED:
    break;
  }
}


boolean sketchFullScreen() {
  return fullScreen;
}

