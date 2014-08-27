// Hoverlay II brighntness booster mk1
// licensed under GPL V3
// all infos at iamnotachoice.com/hoverlay-2
// all dimensions in mm

// BASIC CONFIGURATION

fan_size=60; // select your fan size here from 40, 60 or 80 (other values won't work!)

walls=1;	// thickness of printed walls
base=2;	// thickness of printed baseplate (must be a bit thicker because we're printing bridges here)
fan_dist=30;	// distance between fan and hoverlay side panel
fan_screw_diameter=2.5; // how large are your screws
fan_screw_length=8;	// how long are your screws (should be 8mm screws)
fan_screw_nipple_diameter=6; // how strong are the screw nipples ;)
fan_screw_nipple_length=fan_dist;
tube_walls=2;
tube_length=3.5;

// EXTENDED CONFIGURATION

hole_diameter=25;
snappy_diameter=27;
snappy_width=5;
snappy_clearance=1;
snappy_bendable=38;

// CONSTANTS

fan_screw_dist_80mm=71.5;
fan_screw_dist_60mm=50;
fan_screw_dist_40mm=32;

housing_p0_40mm=[-17.014,20,0];
housing_p1_40mm=[17.014,20,0];
housing_p0_60mm=[-13.892,40,0];
housing_p1_60mm=[13.892,40,0];
housing_p0_80mm=[-10.77,60,0];
housing_p1_80mm=[10.77,60,0];
housing_p2=[23.259,-20,0];
housing_p3=[-23.259,-20,0];

// PREPROCESSING

housing_p0i_40mm=[housing_p0_40mm[0]+walls,housing_p0_40mm[1]-walls,base];
housing_p1i_40mm=[housing_p1_40mm[0]-walls,housing_p1_40mm[1]-walls,base];

housing_p0i_60mm=[housing_p0_60mm[0]+walls,housing_p0_60mm[1]-walls,base];
housing_p1i_60mm=[housing_p1_60mm[0]-walls,housing_p1_60mm[1]-walls,base];

housing_p0i_80mm=[housing_p0_80mm[0]+walls,housing_p0_80mm[1]-walls,base];
housing_p1i_80mm=[housing_p1_80mm[0]-walls,housing_p1_80mm[1]-walls,base];

housing_p2i=[housing_p2[0]-walls,housing_p2[1]+walls,base];
housing_p3i=[housing_p3[0]+walls,housing_p3[1]+walls,base];

fan_center=[(housing_p2[0]+housing_p3[0])/2,(housing_p2[1]+housing_p3[1])/2+fan_size/2,fan_dist];

fan_p0=[fan_center[0]-fan_size/2,fan_center[1]+fan_size/2,fan_center[2]];
fan_p1=[fan_center[0]+fan_size/2,fan_center[1]+fan_size/2,fan_center[2]];
fan_p2=[fan_center[0]+fan_size/2,fan_center[1]-fan_size/2,fan_center[2]];
fan_p3=[fan_center[0]-fan_size/2,fan_center[1]-fan_size/2,fan_center[2]];

fan_p0i=[fan_center[0]-fan_size/2+walls,fan_center[1]+fan_size/2-walls,fan_center[2]];
fan_p1i=[fan_center[0]+fan_size/2-walls,fan_center[1]+fan_size/2-walls,fan_center[2]];
fan_p2i=[fan_center[0]+fan_size/2-walls,fan_center[1]-fan_size/2+walls,fan_center[2]];
fan_p3i=[fan_center[0]-fan_size/2+walls,fan_center[1]-fan_size/2+walls,fan_center[2]];

// TEH CODE

module tube_cutout(){
	translate([0,0,base/2])
		cylinder(r=hole_diameter/2-tube_walls,h=base,center=true, $fn=64);
}

module tube(){
	translate([0,0,-tube_length/2-walls/2])
			intersection(){
				difference(){
					cylinder(r=hole_diameter/2,h=tube_length+walls,center=true, $fn=64);
					cylinder(r=hole_diameter/2-tube_walls,h=tube_length+walls,center=true, $fn=64);
				}
			cube([hole_diameter,2/3*hole_diameter,tube_length+walls],center=true);
		}
}

module snappy(){
		intersection(){
			union(){
				translate([0,0,-tube_length-walls/2])
					difference(){
						cylinder(r1=hole_diameter/2,r2=snappy_diameter/2,h=walls,center=true, $fn=64);
						cylinder(r=hole_diameter/2-tube_walls,h=walls,center=true, $fn=64);
					}
				translate([0,0,-tube_length/2-walls/2])
					difference(){
						cylinder(r=hole_diameter/2,h=tube_length+walls,center=true, $fn=64);
						cylinder(r=hole_diameter/2-tube_walls,h=tube_length+walls,center=true, $fn=64);
					}
			}
			translate([0,0,-tube_length/2-walls/2])
			cube([snappy_width,snappy_diameter,tube_length+walls],center=true);
		}
}

module snappy_cutout(){
	translate([snappy_width/2+snappy_clearance/2,0,base/2])
		cube([snappy_clearance,snappy_bendable,base],center=true);
	translate([-snappy_width/2-snappy_clearance/2,0,base/2])
		cube([snappy_clearance,snappy_bendable,base],center=true);
	
}


module duct(){
	difference(){
		union(){
			difference(){
				if (fan_size==40){
					difference(){
						outer_duct(housing_p0_40mm, housing_p1_40mm);
						inner_duct(housing_p0i_40mm, housing_p1i_40mm);
					}
				} else if (fan_size==60){
					difference(){
						outer_duct(housing_p0_60mm, housing_p1_60mm);
						inner_duct(housing_p0i_60mm, housing_p1i_60mm);
					}
				} else if (fan_size==80){
					difference(){
						outer_duct(housing_p0_80mm, housing_p1_80mm);
						inner_duct(housing_p0i_80mm, housing_p1i_80mm);
					}
				}
				tube_cutout();
				snappy_cutout();
			}
			if (fan_size==40){
				screw_nipples(fan_screw_dist_40mm);
			} else if (fan_size==60){
				screw_nipples(fan_screw_dist_60mm);
			} else if (fan_size==80){
				screw_nipples(fan_screw_dist_80mm);
			}
		}
		if (fan_size==40){
			screw_cutouts(fan_screw_dist_40mm);
		} else if (fan_size==60){
			screw_cutouts(fan_screw_dist_60mm);
		} else if (fan_size==80){
			screw_cutouts(fan_screw_dist_80mm);
		}
	}
}

module inner_duct(housing_p0i, housing_p1i){
	polyhedron(
		points=[
			housing_p0i,
			housing_p1i,
			housing_p2i,
			housing_p3i,
			fan_p0i,
			fan_p1i,
			fan_p2i,
			fan_p3i
		],
		faces=[
			[2,1,0], 	// mount
			[3,2,0],
			[4,5,6],		// fan
			[4,6,7],
			[0,4,3],		// left
			[3,4,7],
			[2,5,1],		// right
			[6,5,2],
			[0,1,4],		// top
			[5,4,1],
			[2,3,7],		// bottom
			[2,7,6]
		]
	);
}

module outer_duct(housing_p0, housing_p1){
	polyhedron(
		points=[
			housing_p0,
			housing_p1,
			housing_p2,
			housing_p3,
			fan_p0,
			fan_p1,
			fan_p2,
			fan_p3
		],
		faces=[
			[2,1,0], 	// mount
			[3,2,0],
			[4,5,6],		// fan
			[4,6,7],
			[0,4,3],		// left
			[3,4,7],
			[2,5,1],		// right
			[6,5,2],
			[0,1,4],		// top
			[5,4,1],
			[2,3,7],		// bottom
			[2,7,6]
		]
	);
}

module screw_cutouts(fan_screw_dist){
	intersection(){
		if (fan_size==40){
			inner_duct(housing_p0i_40mm, housing_p1i_40mm);
		} else if (fan_size==60){
			inner_duct(housing_p0i_60mm, housing_p1i_60mm);
		} else if (fan_size==80){
			inner_duct(housing_p0i_80mm, housing_p1i_80mm);
		}
		union(){
			translate(fan_center){
				translate([-fan_screw_dist/2,fan_screw_dist/2,-fan_screw_length/2])
					cylinder(r=fan_screw_diameter/2, h=fan_screw_length, center=true, $fn=10);
				translate([fan_screw_dist/2,fan_screw_dist/2,-fan_screw_length/2])
					cylinder(r=fan_screw_diameter/2, h=fan_screw_length, center=true, $fn=10);
				translate([-fan_screw_dist/2,-fan_screw_dist/2,-fan_screw_length/2])
					cylinder(r=fan_screw_diameter/2, h=fan_screw_length, center=true, $fn=10);
				translate([fan_screw_dist/2,-fan_screw_dist/2,-fan_screw_length/2])
					cylinder(r=fan_screw_diameter/2, h=fan_screw_length, center=true, $fn=10);
			}
		}
	}
}
module screw_nipples(fan_screw_dist){
	intersection(){
		if (fan_size==40){
			inner_duct(housing_p0i_40mm, housing_p1i_40mm);
		} else if (fan_size==60){
			inner_duct(housing_p0i_60mm, housing_p1i_60mm);
		} else if (fan_size==80){
			inner_duct(housing_p0i_80mm, housing_p1i_80mm);
		}
		union(){
			translate(fan_center){
				translate([-fan_screw_dist/2,fan_screw_dist/2,-fan_screw_nipple_length/2])
					cylinder(r=fan_screw_nipple_diameter/2, h=fan_screw_nipple_length, center=true, $fn=20);
				translate([fan_screw_dist/2,fan_screw_dist/2,-fan_screw_nipple_length/2])
					cylinder(r=fan_screw_nipple_diameter/2, h=fan_screw_nipple_length, center=true, $fn=20);
				translate([-fan_screw_dist/2,-fan_screw_dist/2,-fan_screw_nipple_length/2])
					cylinder(r=fan_screw_nipple_diameter/2, h=fan_screw_nipple_length, center=true, $fn=20);
				translate([fan_screw_dist/2,-fan_screw_dist/2,-fan_screw_nipple_length/2])
					cylinder(r=fan_screw_nipple_diameter/2, h=fan_screw_nipple_length, center=true, $fn=20);
			}
		}
	}
}

module booster(){
	union(){
		duct();
		tube();
		snappy();
	}
}

rotate([0,180,0])
	booster();