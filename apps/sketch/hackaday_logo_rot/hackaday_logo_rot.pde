PImage logo;
float rot=0;
float scale=0.5;
void setup(){
  logo=loadImage("hack.png");
  size(1920,1080,P3D);
}

void draw(){
  background(0);
  pushMatrix();
  translate(width/2,height*0.6,0);
  rotateY(rot);
  image(logo,-logo.width*scale/2,-logo.height*scale/2,logo.width*scale,logo.height*scale);
  popMatrix();
  rot+=0.02;
}

boolean sketchFullScreen(){
  return true;
}
