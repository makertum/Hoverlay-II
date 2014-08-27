// Hoverlay II honeycomb gcode generator
// created by Moritz Walter, 2014
// licensed under GPL V3
// all infos at iamnotachoice.com/hoverlay-2

float top_width=39;
float bottom_width=39;// 51
float col_offset=0; //6
float total_length=160;
float total_height=40;
int rows=12; // 16
int cols=30; // 40

// calculating geometry
float col_length=4*(total_length)/(3*cols+0.5);
float top_row_width=2*(top_width)/(rows+1);
float bottom_row_width=2*(bottom_width)/(rows+1);

float nozzle_temp=255;
float bed_temp=110;

float print_speed = 40;
float travel_speed = 150;
float first_layer_speed = 0.25;
float retraction_speed = 40;
float retraction_length = 2;

float brim_distance=5;
float brim_layers=2;

float bed_width=200;
float bed_depth=180;

float material_density=0.00104; // g/mm^3

int xy_digits=3;
int z_digits=3;
int e_digits=5;

String file_name="supercomb_air.gcode";

float nozzle_diameter=0.2;
float filament_diameter=1.7;
float extrusion_width=0.3;
float layer_height=0.2;
float extrusion_multiplier=1.0;


// STATE VARS
float current_x=0;
float current_y=0;
float current_z=0;
float lastX=0;
float lastY=0;
float lastZ=0;
float current_feedrate=0;
float last_feedrate=0;
float total_extrusion=0;

float nozzle_area=nozzle_diameter*nozzle_diameter/4*PI;
float filament_area=filament_diameter*filament_diameter/4*PI;

float bed_x_offset=(bed_width-total_length)/2;
float bed_y_offset=(bed_depth-bottom_width-col_offset)/2;

String[] gcode=new String[0];

void setup() {
  startCode();
  makeThing();
  endCode();
  saveToFile();
  println("Finished. Used "+total_extrusion/1000+" m of filament");
}

void draw() {
}

void addLine(String _line) {
  gcode = (String[])append(gcode, _line);
}

void startCode() {
  addLine("G21 ; set units to millimeters");
  addLine("M190 S"+round(bed_temp)+" ; wait for bed temperature to be reached");
  addLine("M104 S"+round(nozzle_temp)+" ; set temperature");
  addLine("G28 ; home all axes");
  addLine("G1 Z5 F5000 ; lift nozzle");
  addLine("; M105; fan off");
  addLine("G92 E0 ; set extruded length zero");
  addLine("; G0 E20 ; grab some filament");
  addLine("G92 E0 ; set extruded length zero again");
  addLine("M109 S"+round(nozzle_temp)+" ; wait for temperature to be reached");
  addLine("G90 ; use absolute coordinates");
  addLine("G92 E0");
  addLine("M83 ; use relative distances for extrusion");
  addLine("M106 S127");
  addLine("G1 E"+digitize(-retraction_length, e_digits)+" F"+round(retraction_speed*60));
}

void endCode() {
  addLine("G91 ; set to relative positioning");
  addLine("G0 E-20 ; retract filament;");
  addLine("G90 ; set to absolute positioning");
  addLine("G92 E0 ; set extruded length zero");
  addLine("M104 S0 ; turn off extruder temperature");
  addLine("M140 S0 ; turn off heated bed temperature");
  addLine("G0 X195 Y175 ; move out of the way");
  addLine("M84 ; disable motors");
}


void makeThing() {
  for (float z=0.2;z<=total_height;z+=0.2) {
    println("making layer "+z);
    addLayer(z);
  }
}

void addLayer(float z) {
  travelZ(z);
  if (current_z<=layer_height*brim_layers) {
    brim(current_z);
  }
  float layer_width=map(z-layer_height/2, 0, total_height, bottom_width, top_width);
  float layer_row_width=map(z-layer_height/2, 0, total_height, bottom_row_width, top_row_width);
  float layer_col_offset=map(z-layer_height/2, 0, total_height, col_offset, 0);
  for (float y=0;y<rows;y+=2) {
    for (float x=0;x<cols;x++) {
      hexagon(
      bed_x_offset  +0.5*col_length  +x*0.75*col_length, 
      bed_y_offset  +(x%2+y+1)*layer_row_width/2+layer_col_offset, 
      z, 
      col_length, 
      layer_row_width,
      x==0, 
      y==0, 
      x==cols-1, 
      x%2==0
        );
    }
  }
}

float digitize(float _num, int _digits) {
  float factor=pow(10, _digits);
  return ((float)round(_num*factor))/factor;
}

void saveToFile() {
  saveStrings(file_name, gcode);
}

void hexagon(float x, float y, float z, float w, float h, boolean firstX, boolean firstY, boolean lastX, boolean even) {

  float x0=x-w/2;
  float x1=x-w/4;
  float x2=x+w/4;
  float x3=x+w/2;
  float x4=x+w/4;
  float x5=x-w/4;
  float x6=x-w/2;

  float y0=y;
  float y1=y+h/2;
  float y2=y+h/2;
  float y3=y;
  float y4=y-h/2;
  float y5=y-h/2;
  float y6=y;

  float e01=dist(x0, y0, x1, y1)*extrusion_width*layer_height/filament_area*extrusion_multiplier;
  float e12=dist(x1, y1, x2, y2)*extrusion_width*layer_height/filament_area*extrusion_multiplier;
  float e23=dist(x2, y2, x3, y3)*extrusion_width*layer_height/filament_area*extrusion_multiplier;
  float e34=dist(x3, y3, x4, y4)*extrusion_width*layer_height/filament_area*extrusion_multiplier;
  float e45=dist(x4, y4, x5, y5)*extrusion_width*layer_height/filament_area*extrusion_multiplier;
  float e56=dist(x5, y5, x6, y6)*extrusion_width*layer_height/filament_area*extrusion_multiplier;

  if (firstX && firstY) {
    travelXY(x0, y0);
    tract();
    extrude(x1, y1);
    extrude(x2, y2);
    extrude(x3, y3);
    extrude(x4, y4);
    extrude(x5, y5);
    extrude(x6, y6);
    travelXY(x1, y1);
  }
  else if (firstY) {
    if (even) {
      travelXY(x1, y1);
      extrude(x2, y2);
      extrude(x3, y3);
      extrude(x4, y4);
      extrude(x5, y5);
      extrude(x6, y6);
      travelXY(x1, y1);
      travelXY(x2, y2);
    }
    else {
      travelXY(x0, y0);
      extrude(x1, y1);
      extrude(x2, y2);
      extrude(x3, y3);
      extrude(x4, y4);
      extrude(x5, y5);
      travelXY(x5, y5);
      travelXY(x4, y4);
    }
  }
  else if (firstX) {
    travelXY(x5, y5);
    tract();
    extrude(x0, y0);
    extrude(x1, y1);
    extrude(x2, y2);
    extrude(x3, y3);
  }
  else if(lastX){
    travelXY(x0, y0);
    extrude(x1, y1);
    extrude(x2, y2);
    extrude(x3, y3);
    extrude(x4, y4);
  }
  else {
    if (even) {
      travelXY(x0, y0);
      extrude(x1, y1);
      extrude(x2, y2);
      extrude(x3, y3);
    }
    else {
      travelXY(x0, y0);
      extrude(x1, y1);
      extrude(x2, y2);
      extrude(x3, y3);
    }
  }
  if (lastX) {
    retract();
  }
}

void brim(float z) {
  float x_dimension=total_length;
  float y_dimension=bottom_width+col_offset;

  float x0=bed_x_offset-brim_distance;
  float x1=bed_x_offset+brim_distance+x_dimension;
  float x2=bed_x_offset+brim_distance+x_dimension;
  float x3=bed_x_offset-brim_distance;
  float x4=bed_x_offset-brim_distance;

  float y0=bed_y_offset-brim_distance;
  float y1=bed_y_offset-brim_distance;
  float y2=bed_y_offset+brim_distance+y_dimension;
  float y3=bed_y_offset+brim_distance+y_dimension;
  float y4=bed_y_offset-brim_distance;

  travelXY(x0, y0);
  tract();
  extrude(x1, y1);
  extrude(x2, y2);
  extrude(x3, y3);
  extrude(x4, y4);
  retract();
}

void extrude(float _x, float _y) {
  current_x=_x;
  current_y=_y;
  if (current_z>layer_height) {
    current_feedrate=print_speed;
  }
  else {
    current_feedrate=first_layer_speed*print_speed;
  }
  float extrusion=dist(lastX, lastY, current_x, current_y)*extrusion_width*layer_height/filament_area*extrusion_multiplier;
  if (last_feedrate!=current_feedrate) {
    addLine("G1 X"+digitize(current_x, xy_digits)+" Y"+digitize(current_y, xy_digits)+" E"+digitize(extrusion, e_digits)+" F"+round(current_feedrate*60));
  }
  else {
    addLine("G1 X"+digitize(current_x, xy_digits)+" Y"+digitize(current_y, xy_digits)+" E"+digitize(extrusion, e_digits));
  }
  lastX=current_x;
  lastY=current_y;
  last_feedrate=current_feedrate;
  total_extrusion+=extrusion;
}

void travelXY(float _x, float _y) {
  current_x=_x;
  current_y=_y;
  current_feedrate=travel_speed;
  if (last_feedrate!=current_feedrate) {
    addLine("G1 X"+digitize(current_x, xy_digits)+" Y"+digitize(current_y, xy_digits)+" F"+round(current_feedrate*60));
  }
  else {
    addLine("G1 X"+digitize(current_x, xy_digits)+" Y"+digitize(current_y, xy_digits));
  }
  lastX=current_x;
  lastY=current_y;
  last_feedrate=current_feedrate;
}

void travelZ(float _z) {
  current_z=_z;
  current_feedrate=travel_speed;
  if (last_feedrate!=current_feedrate) {
    addLine("G1 Z"+digitize(current_z, z_digits)+" F"+round(current_feedrate*60));
  }
  else {
    addLine("G1 Z"+digitize(current_z, z_digits));
  }
  lastZ=current_z;
  last_feedrate=current_feedrate;
}

void tract() {
  current_feedrate=retraction_speed;
  addLine("G1 E"+digitize(retraction_length, e_digits)+" F"+round(current_feedrate*60));
  last_feedrate=current_feedrate;
}

void retract() {
  current_feedrate=retraction_speed;
  addLine("G1 E"+digitize(-retraction_length, e_digits)+" F"+round(current_feedrate*60));
  last_feedrate=current_feedrate;
}

