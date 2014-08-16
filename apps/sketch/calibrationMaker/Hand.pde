class Hand {
  int id;
  float[] lowPass;
  float[] raw, praw;
  float[] pos, ppos;
  long timeout;
  long ttl=25;
  Hand(int _id, float _x, float _y, float _z) {
    id=_id;
    lowPass=new float[3];
    lowPass[0]=_x;
    lowPass[1]=_y;
    lowPass[2]=_z;
    raw=new float[3];
    praw=new float[3];
    pos = new float[3];
    ppos = new float[3];
    initPos();
    timeout=ttl;
  }
  void calcPos() {
    arrayCopy(raw, praw);
    arrayCopy(lowPass, raw);
    arrayCopy(pos, ppos);
    pos= cm.getTransformed(raw);
  };
  void initPos() {
    arrayCopy(lowPass,raw);
    arrayCopy(raw,praw);
    pos= cm.getTransformed(raw);
    arrayCopy(pos,ppos);
  };
  void update(float _x, float _y, float _z) {
    timeout=ttl;
    lowPass[0]=0.5*lowPass[0]+0.5*_x;
    lowPass[1]=0.5*lowPass[1]+0.5*_y;
    lowPass[2]=0.5*lowPass[2]+0.5*_z;
  }

  void frame(int _i) {
    calcPos();
    strokeWeight(2);
    line(0, 0, 0, pos[0], pos[1], pos[2]);
    strokeWeight(10);
    pushMatrix();
    translate(pos[0], pos[1], pos[2]);
    sphere(10);
    popMatrix();
  }

  void age() {
    timeout--;
  }
}

