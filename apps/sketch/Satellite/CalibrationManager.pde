class CalibrationManager {
  String calibrationPath;
  String translationPath;
  String scalingPath;
  String rotationPath;
  String zFixPath;

  float[] translation= {
    -0.5, -0.5, 0
  };
  float[] scaling= {
    800, 600, 500
  };
  float[] rotation= {
    0, 0, 0
  };
  float zFix=5;

  MVector vector;
  CalibrationManager() {
    calibrationPath=sketchPath("calibration");
    println("calibrationPath: "+calibrationPath);
    translationPath=calibrationPath+"/translation.txt";
    println("translationPath: "+translationPath);
    scalingPath=calibrationPath+"/scaling.txt";
    println("scalingPath: "+scalingPath);
    rotationPath=calibrationPath+"/rotation.txt";
    println("rotationPath: "+rotationPath);
    zFixPath=calibrationPath+"/zFix.txt";
    println("zFixPath: "+zFixPath);
    loadSettings();
    vector=new MVector(0, 0, 0);
    setupMatrix();
  }

  float[] prewarp(float[] _raw) {
    float[] prewarped = {
      (_raw[0]+translation[0])*scaling[0]*zFix*_raw[2], 
      (_raw[1]+translation[1])*scaling[1]*zFix*_raw[2], 
      (_raw[2]+translation[2])*scaling[2]
    };
    return prewarped;
  };

  float[] getTransformed(float[] _raw) {
    vector.set(prewarp(_raw));
    vector.transform();
    return vector.array();
  }

  void setupMatrix() {
    MVector.identify();
    MVector.xRotateStack(rotation[0]);
    MVector.yRotateStack(rotation[1]);
    MVector.zRotateStack(rotation[2]);
  }

  void rotateX(float _inc) {
    rotation[0]+=_inc;
    setupMatrix();
  }

  void rotateY(float _inc) {
    rotation[1]+=_inc;
    setupMatrix();
  }
  void rotateZ(float _inc) {
    rotation[2]+=_inc;
    setupMatrix();
  }
  void setCenter(float[] _raw) {
    translation[0]=-_raw[0];
    translation[1]=-_raw[1];
    translation[2]=-_raw[2];
  }
  void calibrateX(float _x) {
    scaling[0]=(float)(width)/abs(_x+translation[0]);
  }
  void calibrateY(float _y) {
    scaling[1]=(float)(height)/abs(_y+translation[1]);
  }
  void saveSettings() {
    saveStrings(translationPath, stringifyFloat(translation));
    saveStrings(scalingPath, stringifyFloat(scaling));
    saveStrings(rotationPath, stringifyFloat(rotation));
    saveStrings(zFixPath, stringifyFloat(zFix));
    println("settings saved!");
  }
  void loadSettings() {
    File translationFile=new File(translationPath);
    if (translationFile.exists()) {
      translation=floatifyStrings(loadStrings(translationPath));
    }
    File scalingFile=new File(scalingPath);
    if (scalingFile.exists()) {
      scaling=floatifyStrings(loadStrings(scalingPath));
    }
    File rotationFile=new File(rotationPath);
    if (rotationFile.exists()) {
      rotation=floatifyStrings(loadStrings(rotationPath));
    }
    File zFixFile=new File(zFixPath);
    if (zFixFile.exists()) {
      zFix=floatifyString(loadStrings(zFixPath));
    }
    println("settings loaded");
  }

  String[] stringifyFloat(float[] floats) {
    String[] strings = new String[floats.length];
    for (int i=0; i<floats.length; i++) {
      strings[i]=Float.toString(floats[i]);
    }
    return strings;
  }
  String[] stringifyFloat(float _float) {
    String[] strings = new String[1];
    strings[0] = Float.toString(_float);
    return strings;
  }
  float[] floatifyStrings(String[] strings) {
    float[] floats = new float[strings.length];
    for (int i=0; i<strings.length; i++) {
      floats[i]=Float.valueOf(strings[i]);
    }
    return floats;
  }
  float floatifyString(String[] strings) {
    return Float.valueOf(strings[0]);
  }
}

