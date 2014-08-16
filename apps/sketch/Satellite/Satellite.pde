import processing.serial.*;
import saito.objloader.*;
import oscP5.*;
import netP5.*;

OBJModel model;

OscP5 oscP5;
HandManager hm;
CalibrationManager cm;

Serial port;

boolean fullScreen=true;
boolean gloveOn=true;

float lastRotX=0;
float lastRotY=0;
float rotX=0;
float rotY=0;
float velRotX=0;
float velRotY=0;

float transZ=0;

boolean bTexture = true;
boolean bStroke = false;
boolean bMaterial = true;

void setup() {
  hm=new HandManager();
  cm=new CalibrationManager();
  
  if(fullScreen){
    size(displayWidth, displayHeight, OPENGL);    // use OPENGL rendering for bilinear filtering on texture
  }else{
    size(displayWidth/2, displayHeight/2, OPENGL);    // use OPENGL rendering for bilinear filtering on texture
  }
  if(gloveOn){
    println(Serial.list());
    String portName = "/dev/tty.usbmodem1a111";
    port = new Serial(this, portName, 9600);
  }
  oscP5 = new OscP5(this, 3333);
  model = new OBJModel(this, "cassini.obj", "relative", TRIANGLES);
  //model = new OBJModel(this, "Chevrolet Camaro.obj");
  model.scale(8);
  smooth();
  noStroke();
  /*
  perspective(radians(45), 
  float(width)/float(height), 
  10, 150000);
  */
}

void draw() {
  background(0);
  lights();
  hm.frame();
  pushMatrix();
  translate(width/2, height/2, transZ);
  rotateY(rotY);
  rotateX(rotX);
  model.draw();
  popMatrix();
  velRotX*=0.999;
  velRotY*=0.999;
  rotX+=velRotX;
  rotY+=velRotY;
  lastRotX=rotX;
  lastRotY=rotY;
}

boolean sketchFullScreen() {
  return fullScreen;
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
    // turns on and off the texture listed in .mtl file
    if(key == 't') {
        if(!bTexture) {
            model.enableTexture();
            bTexture = true;
        } 
        else {
            model.disableTexture();
            bTexture = false;
        }
    }

    else if(key == 'm') {
        // turns on and off the material listed in .mtl file
        if(!bMaterial) {
            model.enableMaterial();
            bMaterial = true;
        } 
        else {
            model.disableMaterial();
            bMaterial = false;
        }
    }

    else if(key == 's') {
        if(!bStroke) {
            stroke(10, 10, 10);
            bStroke = true;
        } 
        else {
            noStroke();
            bStroke = false;
        }
    }

    // the follwing changes the render modes
    // POINTS mode is a little flakey in OPENGL (known processing bug)
    // the best one to use is the one you exported the obj as
    // when in doubt try TRIANGLES or POLYGON
    else if(key=='1') {
        stroke(10, 10, 10);
        bStroke = true;
        model.shapeMode(POINTS);
    }

    else if(key=='2') {
        stroke(10, 10, 10);
        bStroke = true;
        model.shapeMode(LINES);
    }

    else if(key=='3') {
        model.shapeMode(TRIANGLES);
    }

    else if(key=='4') {
        model.shapeMode(POLYGON);
    }

    else if(key=='5') {
        model.shapeMode(TRIANGLE_STRIP);
    }

    else if(key=='6') {
        model.shapeMode(QUADS);
    }

    else if(key=='7') {
        model.shapeMode(QUAD_STRIP);
    }
}
