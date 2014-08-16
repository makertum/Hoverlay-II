class Pong {
  MVector playerA, playerB, ball, ballV, ballTest, bonusBubble;
  float defaultPaddleHeight, bonusPaddleHeight, paddleHeightA, paddleHeightB, paddleWidth, paddleMargin, borderWidth, borderDepth, bonusBubbleRadius, ballRadius, fieldWidth, fieldHeight, startV, vInc, rAnge;
  int bonusBubbleCounter, bonusBubbleDuration, bonusCounterA, bonusCounterB, bonusDuration;
  boolean contactPA, contactPB, contactT, contactB, paused;
  char lastContact;
  Pong(float _width, float _height) {
    paddleMargin=100;
    paddleWidth=30;
    defaultPaddleHeight=150;
    bonusPaddleHeight=300;
    ballRadius=15;
    paddleHeightA=defaultPaddleHeight;
    paddleHeightB=defaultPaddleHeight;
    borderWidth=5;
    borderDepth=5;
    fieldWidth=_width;
    fieldHeight=_height;
    startV=5;
    vInc=0.1;
    rAnge=radians(45);
    playerA=new MVector(-fieldWidth/2+paddleMargin, 0, 0);
    playerB=new MVector(fieldWidth/2-paddleMargin, 0, 0);
    ball=new MVector(0, 0, 0);
    if (random(1)>0.5) {
      ballV=new MVector(startV, 0, 0);
    } else {
      ballV=new MVector(-startV, 0, 0);
    }
    ballV.zRotateVector(random(0, rAnge)-rAnge/2);
    contactPA=false;
    contactPB=false;
    contactT=false;
    contactB=false;
    paused=true;
    lastContact=' ';

    bonusBubbleRadius=50;
    bonusBubble=new MVector(0, 0, 0);
    bonusBubbleCounter=0;
    bonusCounterA=0;
    bonusCounterB=0;
    bonusBubbleDuration=round(30*frameRate);
    bonusDuration=round(30*frameRate);
  }

  void frame() {
    if (!paused) {
      //getInputs();
      bonus();
      collisions();
    }
    drawElements();
  }

  void pause() {
    paused=true;
  }
  void run() {
    paused=false;
  }

  void setPlayerA(float _y) {
    float yA=constrain(_y, -fieldHeight/2+paddleHeightA/2, fieldHeight/2-paddleHeightA/2);
    playerA.set(playerA.x, yA, playerA.z);
  }

  void setPlayerB(float _y) {
    float yB=constrain(_y, -fieldHeight/2+paddleHeightB/2, fieldHeight/2-paddleHeightB/2);
    playerB.set(playerB.x, yB, playerB.z);
  }
  /*
  void getInputs() {
   float yA=constrain(mouseY-height/2, -fieldHeight/2+paddleHeightA/2, fieldHeight/2-paddleHeightA/2);
   float yB=constrain(mouseY-height/2, -fieldHeight/2+paddleHeightB/2, fieldHeight/2-paddleHeightB/2);
   playerA.set(playerA.x, yA, playerA.z);
   playerB.set(playerB.x, yB, playerB.z);
   }
   */

  void drawElements() {
    noStroke();
    ellipseMode(RADIUS);
    if (bonusBubbleCounter>0) {
      //stroke(0);
      //strokeWeight(1);
      fill(0, 255, 0);
      pushMatrix();
      translate(bonusBubble.x, bonusBubble.y, bonusBubble.z);
      sphere(bonusBubbleRadius);
      popMatrix();
    }
    noStroke();
    //stroke(0);
    //strokeWeight(0.5);
    fill(255);
    pushMatrix();
    translate(ball.x, ball.y, ball.z);
    sphere(ballRadius);
    popMatrix();
    
    // borders
    noFill();
    stroke(255);
    pushMatrix();
      translate(0,fieldHeight/2+ballRadius,-borderDepth/2);
      box(fieldWidth,borderWidth,borderDepth);
    popMatrix();
    pushMatrix();
      translate(0,-fieldHeight/2-ballRadius,-borderDepth/2);
      box(fieldWidth,borderWidth,borderDepth);
    popMatrix();
    pushMatrix();
      translate(-fieldWidth/2-ballRadius,0,-borderDepth/2);
      box(borderWidth,fieldHeight,borderDepth);
    popMatrix();
    pushMatrix();
      translate(fieldWidth/2+ballRadius,0,-borderDepth/2);
      box(borderWidth,fieldHeight,borderDepth);
    popMatrix();
    
    
    
    stroke(0);
    strokeWeight(1);
    fill(255);
    // playerA paddle
    pushMatrix();
      translate(playerA.x-paddleWidth, playerA.y, playerA.z);
      box(paddleWidth, paddleHeightA, paddleWidth);
    popMatrix();
    // playerB paddle
    pushMatrix();
      translate(playerB.x+paddleWidth, playerB.y, playerB.z);
      box(paddleWidth, paddleHeightB, paddleWidth);
    popMatrix();
  }

  void bonus() {
    bonusBubbleDuration=round(30*frameRate);
    bonusDuration=round(30*frameRate);
    if (bonusBubbleCounter==0) {
      if (random(10*frameRate)<1.0) {
        sp.play("smw_vine.wav");
        bonusBubble=new MVector(random(fieldWidth/2)-fieldWidth/4, random(fieldHeight/2)-fieldHeight/4, 0);
        bonusBubbleCounter=bonusBubbleDuration;
        println("creating bonus bubble!");
      }
    } else {
      bonusBubbleCounter--;
      if (bonusBubbleCounter==0) {
        sp.play("smw_stomp_bones.wav");
      }
    }

    if (bonusCounterA>0) {
      paddleHeightA = bonusPaddleHeight;
      bonusCounterA--;
    } else {
      paddleHeightA = defaultPaddleHeight;
    }
    if (bonusCounterB>0) {
      paddleHeightB = bonusPaddleHeight;
      bonusCounterB--;
    } else {
      paddleHeightB = defaultPaddleHeight;
    }
  }

  void collisions() {
    ballTest=ball.get();
    ballTest.add(ballV);
    PVector intersectPA=segIntersection(ball.x, ball.y, ballTest.x, ballTest.y, playerA.x, playerA.y+paddleHeightA/2, playerA.x, playerA.y-paddleHeightA/2);
    PVector intersectPB=segIntersection(ball.x, ball.y, ballTest.x, ballTest.y, playerB.x, playerB.y+paddleHeightB/2, playerB.x, playerB.y-paddleHeightB/2);
    PVector intersectT=segIntersection(ball.x, ball.y, ballTest.x, ballTest.y, -fieldWidth/2, -fieldHeight/2, fieldWidth/2, -fieldHeight/2);
    PVector intersectB=segIntersection(ball.x, ball.y, ballTest.x, ballTest.y, -fieldWidth/2, fieldHeight/2, fieldWidth/2, fieldHeight/2);
    PVector intersectL=segIntersection(ball.x, ball.y, ballTest.x, ballTest.y, -fieldWidth/2, -fieldHeight/2, -fieldWidth/2, fieldHeight/2);
    PVector intersectR=segIntersection(ball.x, ball.y, ballTest.x, ballTest.y, fieldWidth/2, -fieldHeight/2, fieldWidth/2, fieldHeight/2);
    if (intersectPA!=null && !contactPA) {
      println("Hit Paddle A");
      sp.play("smw_stomp.wav");
      lastContact='A';
      contactPA=true;
      MVector pivot=new MVector(intersectPA);
      float rotation=2.0*rAnge*(pivot.y-playerA.y)/paddleHeightA;
      println(rotation);
      ballTest.sub(pivot);
      ballTest.mirrorX();
      ballTest.zRotateVector(rotation);
      ballTest.add(pivot);
      ballV.mirrorX();
      ballV.zRotateVector(rotation);
      ballV.setMag(ballV.mag()+vInc);
    } else {
      contactPA=false;
    }
    if (intersectPB!=null && !contactPB) {
      println("Hit Paddle B");
      sp.play("smw_stomp.wav");
      contactPB=true;
      lastContact='B';
      MVector pivot=new MVector(intersectPB);
      float rotation=2.0*rAnge*(pivot.y-playerB.y)/paddleHeightB;
      ballTest.sub(pivot);
      ballTest.mirrorX();
      ballTest.zRotateVector(-rotation);
      ballTest.add(pivot);
      ballV.mirrorX();
      ballV.zRotateVector(-rotation);
      ballV.setMag(ballV.mag()+vInc);
    } else {
      contactPB=false;
    }
    if (intersectT!=null && !contactT) {
      sp.play("smw_kick.wav");
      contactT=true;
      MVector pivot=new MVector(intersectT);
      ballTest.sub(pivot);
      ballTest.mirrorY();
      ballTest.add(pivot);
      ballV.mirrorY();
    } else {
      contactT=false;
    }
    if (intersectB!=null && !contactB) {
      sp.play("smw_kick.wav");
      contactB=true;
      MVector pivot=new MVector(intersectB);
      ballTest.sub(pivot);
      ballTest.mirrorY();
      ballTest.add(pivot);
      ballV.mirrorY();
    } else {
      contactB=false;
    }
    if (intersectL!=null) {
      sp.play("smw_lemmy_wendy_incorrect.wav");
      lastContact=' ';
      float currentV=ballV.mag();
      ballTest.set(0, 0, 0);
      ballV.set(-1, 0, 0);
      ballV.setMag(currentV);
      ballV.zRotateVector(random(0, rAnge)-rAnge/2);
    }
    if (intersectR!=null) {
      sp.play("smw_lemmy_wendy_incorrect.wav");
      lastContact=' ';
      float currentV=ballV.mag();
      ballTest.set(0, 0, 0);
      ballV.set(1, 0, 0);
      ballV.setMag(currentV);
      ballV.zRotateVector(random(0, rAnge)-rAnge/2);
    }
    if (bonusBubbleCounter>0 && lastContact!=' ' && dist(ball.x, ball.y, ball.z, bonusBubble.x, bonusBubble.y, bonusBubble.z)<bonusBubbleRadius+ballRadius) {
      switch (lastContact) {
      case 'A':
        sp.play("smw_power-up.wav");
        bonusCounterA=bonusDuration;
        bonusBubbleCounter=0;
        break;
      case 'B':
        sp.play("smw_power-up.wav");
        bonusCounterB=bonusDuration;
        bonusBubbleCounter=0;
        break;
      }
    }
    ball=ballTest.get();
  }


  PVector lineIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
  {
    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3; 
    float b_dot_d_perp = bx*dy - by*dx;
    if (b_dot_d_perp == 0) {
      return null;
    }
    float cx = x3-x1; 
    float cy = y3-y1;
    float t = (cx*dy - cy*dx) / b_dot_d_perp; 

    return new PVector(x1+t*bx, y1+t*by);
  }


  // Line Segment Intersection

  PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) 
  { 
    float bx = x2 - x1; 
    float by = y2 - y1; 
    float dx = x4 - x3; 
    float dy = y4 - y3;
    float b_dot_d_perp = bx * dy - by * dx;
    if (b_dot_d_perp == 0) {
      return null;
    }
    float cx = x3 - x1;
    float cy = y3 - y1;
    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    if (t < 0 || t > 1) {
      return null;
    }
    float u = (cx * by - cy * bx) / b_dot_d_perp;
    if (u < 0 || u > 1) { 
      return null;
    }
    return new PVector(x1+t*bx, y1+t*by);
  }
}

