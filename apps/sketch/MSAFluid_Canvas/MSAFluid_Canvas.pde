import java.io.File;
import processing.serial.*;

import msafluid.*;
import processing.opengl.*;
import javax.media.opengl.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
HandManager hm;
CalibrationManager cm;
Serial port;

boolean fullScreen=true;
boolean gloveOn=true;

final float FLUID_WIDTH = 120;

float invWidth, invHeight;    // inverse of screen dimensions
float aspectRatio, aspectRatio2;

MSAFluidSolver2D fluidSolver;

ParticleSystem particleSystem;

PImage imgFluid;

boolean drawFluid = true;

void setup() {
  if(fullScreen){
    size(displayWidth, displayHeight, P3D);    // use OPENGL rendering for bilinear filtering on texture
  }else{
    size(displayWidth/2, displayHeight/2, P3D);    // use OPENGL rendering for bilinear filtering on texture
  }
  smooth();
  
  oscP5 = new OscP5(this,3333);
  
  hm=new HandManager();
  cm=new CalibrationManager();

  invWidth = 1.0f/width;
  invHeight = 1.0f/height;
  aspectRatio = width * invHeight;
  aspectRatio2 = aspectRatio * aspectRatio;

  // create fluid and set options
  fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
  fluidSolver.enableRGB(true).setFadeSpeed(0.003).setDeltaT(0.5).setVisc(0.0001);

  // create image to hold fluid picture
  imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);

  // create particle system
  particleSystem = new ParticleSystem();
  
  if(gloveOn){
    println(Serial.list());
    String portName = "/dev/tty.usbmodem1a111";
    port = new Serial(this, portName, 9600);
  }
}


void mouseMoved() {
  println("mouseNOW  "+mouseX+"/"+mouseY);
  println("mousePAST "+pmouseX+"/"+pmouseY);
  float mouseNormX = mouseX * invWidth;
  float mouseNormY = mouseY * invHeight;
  float mouseVelX = (mouseX - pmouseX) * invWidth;
  float mouseVelY = (mouseY - pmouseY) * invHeight;
  addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, 1);
}

void draw() {
  hm.frame();
  fluidSolver.update();

  if (drawFluid) {
    for (int i=0; i<fluidSolver.getNumCells(); i++) {
      int d = 2;
      imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d);
    }  
    imgFluid.updatePixels();//  fastblur(imgFluid, 2);
    image(imgFluid, 0, 0, width, height);
  }
  particleSystem.updateAndDraw();
}

void mousePressed() {
  drawFluid ^= true;
}



// add force and dye to fluid, and create particles
void addForce(float x, float y, float dx, float dy, float multi) {
  float speed = dx * dx  + dy * dy * aspectRatio2;    // balance the x and y components of speed with the screen aspect ratio

  if (speed > 0) {
    if (x<0) x = 0; 
    else if (x>1) x = 1;
    if (y<0) y = 0; 
    else if (y>1) y = 1;

    float colorMult = 5;
    float velocityMult = 30.0f * multi;

    int index = fluidSolver.getIndexForNormalizedPosition(x, y);

    color drawColor;

    colorMode(HSB, 360, 1, 1);
    float hue = ((x + y) * 180 + frameCount) % 360;
    drawColor = color(hue, 1, 1);
    colorMode(RGB, 1);  

    fluidSolver.rOld[index]  += red(drawColor) * colorMult;
    fluidSolver.gOld[index]  += green(drawColor) * colorMult;
    fluidSolver.bOld[index]  += blue(drawColor) * colorMult;

    particleSystem.addParticles(x * width, y * height, round(200*multi));
    fluidSolver.uOld[index] += dx * velocityMult;
    fluidSolver.vOld[index] += dy * velocityMult;
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  if(theOscMessage.addrPattern().equals("/hands/ID-centralXYZ")){
    int handID = theOscMessage.get(0).intValue();
    float handX = theOscMessage.get(1).floatValue();
    float handY = theOscMessage.get(2).floatValue();
    float handZ = theOscMessage.get(3).floatValue();
    //println(handX+"/"+handY+"/"+handZ);
    hm.update(handID,handX,handY,handZ);
  }
}



void keyPressed()
{
  switch(key)
  {
  case 'r': 
    renderUsingVA ^= true; 
    println("renderUsingVA: " + renderUsingVA);
    println(frameRate);
    break;
  }
}



boolean sketchFullScreen() {
  return fullScreen;
}
