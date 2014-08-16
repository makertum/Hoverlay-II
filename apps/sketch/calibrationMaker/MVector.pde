static class MVector {
  float x, y, z;
  static float[][] stack= {
    { 
      1.0, 0.0, 0.0, 0.0
    }
    , 
    { 
      0.0, 1.0, 0.0, 0.0
    }
    , 
    { 
      0.0, 0.0, 1.0, 0.0
    }
    , 
    { 
      0.0, 0.0, 0.0, 1.0
    }
  };
  MVector(float ix, float iy, float iz) {
    set(ix, iy, iz);
  }
  // BASIC VECTOR METHODS
  MVector get() {
    return new MVector(x, y, z);
  }
  void set(float sx, float sy, float sz) {
    x=sx;
    y=sy;
    z=sz;
  }
  void set(float[] s) {
    x=s[0];
    y=s[1];
    z=s[2];
  }
  float[] array() {
    float[] vector= {
      x, y, z
    };
    return vector;
  }
  float[] worldArray() {
    float[] vector= {
      x, y, z, 1.0
    };
    return vector;
  }
  // BASIC VECTOR MATHS
  MVector getOrtho() {
    MVector ex=new MVector(1, 0, 0);
    if (MVector.angleBetween(this, ex)!=0) {
      MVector ortho = ex.cross(this);
      ortho.normalize();
      return ortho;
    }
    MVector ey=new MVector(1, 0, 0);
    if (MVector.angleBetween(this, ey)!=0) {
      MVector ortho = ey.cross(this);
      ortho.normalize();
      return ortho;
    }
    MVector ez=new MVector(1, 0, 0);
    if (MVector.angleBetween(this, ez)!=0) {
      MVector ortho = ez.cross(this);
      ortho.normalize();
      return ortho;
    }
    return this;
  }
  void add(MVector vector) {
    x+=vector.x;
    y+=vector.y;
    z+=vector.z;
  }
  void sub(MVector vector) {
    x-=vector.x;
    y-=vector.y;
    z-=vector.z;
  }
  void mult(float scalar) {
    x*=scalar;
    y*=scalar;
    z*=scalar;
  }
  void div(float scalar) {
    x/=scalar;
    y/=scalar;
    z/=scalar;
  }
  float mag() {
    return sqrt(pow(x, 2)+pow(y, 2)+pow(z, 2));
  }
  float dist(MVector vector) {
    return sqrt(pow(x-vector.x, 2)+pow(y-vector.y, 2)+pow(z-vector.z, 2));
  }
  float dist(float vx, float vy, float vz) {
    return dist(new MVector(vx, vy, vz));
  }
  float dot(MVector vector) {
    return x*vector.x+y*vector.y+z*vector.z;
  }
  MVector cross(MVector vector) {
    return new MVector(y*vector.z-z*vector.y, 
    z*vector.x-x*vector.z, 
    x*vector.y-y*vector.x);
  }
  void normalize() {
    div(mag());
  }
  void limit(float limit) {
    if (mag()>limit) {
      normalize();
      mult(limit);
    }
  }
  void setMag(float nmag) {
    if (mag()!=nmag) {
      normalize();
      mult(nmag);
    }
  }
  static float angleBetween(MVector vectorA, MVector vectorB) {
    return acos(vectorA.dot(vectorB)/(vectorA.mag()*vectorB.mag()));
  }
  // MATRIX-BASED TRANSFORMATIONS
  static void mmult(float[][] matrix) {
    float[][] newstack=new float[4][4];
    for (int a=0; a<4; a++) {
      for (int m=0; m<4; m++) {
        newstack[a][m]=0;
        for (int i=0; i<4; i++) {
          newstack[a][m]+=matrix[a][i]*stack[i][m];
        }
      }
    }
    setStack(newstack);
  }
  
  
  static void setStack(float[][] newstack) {
    arrayCopy(newstack,stack);
  }
  static void copyStack(float[][] src, float[][] dst) {
    for(int z=0;z<4;z++){
      for(int s=0;s<4;s++){
        dst[z][s]=src[z][s];
      }
    }
  }

  static void identify() {
    float[][] idnt= {
      { 
        1.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 1.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 1.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    setStack(idnt);
  }

  static void xRotateStack(float a) {
    float[][] rotx= {
      { 
        1.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, cos(a), -sin(a), 0.0
      }
      , 
      { 
        0.0, sin(a), cos(a), 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(rotx);
  }

  static void yRotateStack(float a) {
    float[][] roty= {
      { 
        cos(a), 0.0, sin(a), 0.0
      }
      , 
      { 
        0.0, 1.0, 0.0, 0.0
      }
      , 
      { 
        -sin(a), 0.0, cos(a), 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(roty);
  }

  static void zRotateStack(float a) {
    float[][] rotz= {
      { 
        cos(a), -sin(a), 0.0, 0.0
      }
      , 
      { 
        sin(a), cos(a), 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 1.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(rotz);
  }

  static void xyzTranslation(float tx, float ty, float tz) {
    float[][] txyz= {
      { 
        1.0, 0.0, 0.0, tx
      }
      , 
      { 
        0.0, 1.0, 0.0, ty
      }
      , 
      { 
        0.0, 0.0, 1.0, tz
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(txyz);
  }

  static void xyzScaling(float sx, float sy, float sz) {
    float[][] txyz= {
      { 
        sx, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, sy, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, sz, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(txyz);
  }

  static void xProjection() {
    float[][] xpro= {
      { 
        0.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 1.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 1.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(xpro);
  }

  static void yProjection() {
    float[][] ypro= {
      { 
        1.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 1.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(ypro);
  }

  static void zProjection() {
    float[][] zpro= {
      { 
        1.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 1.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0.0, 1.0
      }
    };
    mmult(zpro);
  }

  static void perspectify(float d) {
    float[][] pers= {
      { 
        1.0, 0.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 1.0, 0.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 1.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 1.0/d, 1.0
      }
    };
    mmult(pers);
  }
  
  static void zFix(float f) {
    float[][] pers= {
      { 
        1.0, 0.0, f, 0.0
      }
      , 
      { 
        0.0, 1.0, f, 0.0
      }
      , 
      { 
        0.0, 0.0, 1.0, 0.0
      }
      , 
      { 
        0.0, 0.0, 0, 1.0
      }
    };
    mmult(pers);
  }

  static void smult(float scalar) {
    for (int z=0; z<4; z++) {
      for (int s=0; s<4; s++) {
        stack[z][s]+=stack[z][s]*scalar;
      }
    }
  }

  void xRotateVector(float angle) {
    identify();
    xRotateStack(angle);
    transform();
  }

  void yRotateVector(float angle) {
    identify();
    yRotateStack(angle);
    transform();
  }

  void zRotateVector(float angle) {
    identify();
    zRotateStack(angle);
    transform();
  }

  void transform() {
    float[] original=worldArray();
    float[] transformed=new float[4];
    for (int a=0; a<4; a++) {
      transformed[a]=0;
      for (int i=0; i<4; i++) {
        transformed[a]+=stack[a][i]*original[i];
      }
    }
    set(transformed[0]/transformed[3], transformed[1]/transformed[3], transformed[2]/transformed[3]);
  }
}

