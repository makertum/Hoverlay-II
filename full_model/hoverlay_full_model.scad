module side_plate(){
	difference(){
		translate([0,0,-3/2])
			linear_extrude(height=3){
				polygon(
					points=[
						[-48,140],		// 00
						[48,140],			// 01
						[135.5,-46.5],	// 02
						[48.5,-100],		// 03
						[46.036,-100],	// 04
						[46.036,-97],		// 05
						[23.087,50],		// 06
						[20.122,49.542],	// 07
						[26.295,10],		// 08
						[-26.295,10],		// 09
						[-20.122,49.542],// 10
						[-23.087,50],		// 11
						[-46.036,-97],	// 12
						[-46.036,-100],	// 13
						[-48.5,-100],		// 14
						[-135.5,-46.5],	// 15
						[-135.5,-46.5],	// 16
						[48,140],			// 17
					],
					paths=[
						[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
					]
				);
			}
		translate([0,30,0])
			cylinder(r=25/2,h=3,center=true,$fn=32);
		translate([-75,-10,0]){
			cylinder(r=5/2,h=3,center=true,$fn=16);
				translate([-6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
				translate([6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
		}
		translate([-45,-10,0]){
			cylinder(r=5/2,h=3,center=true,$fn=16);
				translate([-6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
				translate([6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
		}
		translate([45,-10,0]){
			cylinder(r=5/2,h=3,center=true,$fn=16);
				translate([-6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
				translate([6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
		}
		translate([75,-10,0]){
			cylinder(r=5/2,h=3,center=true,$fn=16);
				translate([-6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
				translate([6.5,0,0])
					cylinder(r=2/2,h=3,center=true,$fn=16);
		}
	}
}

module side_plates(){
	translate([-320/2-3/2,0,0])
		rotate([0,0,90])
			rotate([90,0,0])
				side_plate();
	translate([320/2+3/2,0,0])
		rotate([0,0,90])
			rotate([90,0,0])
				side_plate();
}


module logo_plates(){
	fpx1=65.639;
	fpy1=-95.582;
	fpx2=153.139;
	fpy2=90.918;
	angle=atan((fpy2-fpy1)/(fpx2-fpx1));
	fpoffy=-90.385;
	fpoffz=46.1;
	translate([0,fpoffy,fpoffz])
		rotate([angle,0,0])
			cube([320,206,3],center=true);
	translate([0,-fpoffy,fpoffz])
		rotate([-angle,0,0])
			cube([320,206,3],center=true);
}


module vent(){
	vx1=46.036;
	vy1=-97;
	vx2=23.087;
	vy2=50;
	angle=atan((vy2-vy1)/(vx2-vx1));
	voffy=14.626;
	voffz=75.024;
	translate([0,voffy,voffz])
		rotate([angle,0,0])
			cube([320,131.099,3],center=true);
	translate([0,-voffy,voffz])
		rotate([-angle,0,0])
			cube([320,131.099,3],center=true);
}

module air_inlets(){
	aix1=-132.38;
	aiy1=46.323;
	aix2=-42.322;
	aiy2=72.076;
	angle=atan((aiy2-aiy1)/(aix2-aix1));
	aioffy=88.4;
	aioffz=-59;
	translate([0,aioffy,aioffz])
		rotate([angle,0,0])
			air_inlet();
	translate([0,-aioffy,aioffz])
		rotate([-angle,0,0])
			air_inlet();
}

module air_inlet(){
	fan_size=80;
	fan_holes_dist=71.5;
	fan_inlet_diameter=70;
	difference(){
		cube([320,93.667,3],center=true);
		for(i=[-1.5:1.5]){
			translate([i*fan_size,0,0]){
				// FAN INLET
				cylinder(r=fan_inlet_diameter/2,h=3,center=true,$fn=32);
				// MOUNTING HOLES
				translate([-fan_holes_dist/2,-fan_holes_dist/2,0])
					cylinder(r=4/2,h=3,center=true,$fn=16);
				translate([fan_holes_dist/2,-fan_holes_dist/2,0])
					cylinder(r=4/2,h=3,center=true,$fn=16);
				translate([-fan_holes_dist/2,fan_holes_dist/2,0])
					cylinder(r=4/2,h=3,center=true,$fn=16);
				translate([fan_holes_dist/2,fan_holes_dist/2,0])
					cylinder(r=4/2,h=3,center=true,$fn=16);
			}
		}
	}
}

module housing(){
	union(){
		air_inlets();
		side_plates();
		logo_plates();
		vent();
		combs_fog();
		combs();
	}
}

module vat_side_plate(){
	difference(){
		translate([0,0,-3/2])
			linear_extrude(height=3){
				polygon(
					points=[
						[43,-97],		// 00
						[26.259,10],	// 01
						[-26.259,10],	// 02
						[-43,-97],	// 03
					],
					paths=[
						[0,1,2,3]
					]
				);
			}
		translate([-15,-10,0]){
			cylinder(r=5/2,h=3,center=true,$fn=16);
			translate([-6.5,0,0])
				cylinder(r=2/2,h=3,center=true,$fn=16);
			translate([6.5,0,0])
				cylinder(r=2/2,h=3,center=true,$fn=16);
	
		}
		translate([15,-10,0]){
			cylinder(r=5/2,h=3,center=true,$fn=16);
			translate([-6.5,0,0])
				cylinder(r=2/2,h=3,center=true,$fn=16);
			translate([6.5,0,0])
				cylinder(r=2/2,h=3,center=true,$fn=16);
		}
	}
}

module vat_side_plates(){
	translate([-320/2-3/2,0,0])
		rotate([0,0,90])
			rotate([90,0,0])
				vat_side_plate();
	translate([320/2+3/2,0,0])
		rotate([0,0,90])
			rotate([90,0,0])
				vat_side_plate();
}

module vat_hull(){
	rotate([0,90,0])
		rotate([0,0,90])
			translate([0,0,-326/2])
				linear_extrude(height=326){
					polygon(
						points=[
							[46.036,-100],	// 00
							[46.036,-97],		// 01
							[23.087,50],		// 02
							[20.122,49.542],	// 03
							[43,-97],			// 04
							[-43,-97],		// 05
							[-20.122,49.542],// 06
							[-23.087,50],		// 07
							[-46.036,-97],	// 08
							[-46.036,-100],	// 09
							[-48.5,-100],		// 10
						],
						paths=[
							[0,1,2,3,4,5,6,7,8,9,10]
						]
					);
				}
}

module vat(){
	union(){
		vat_side_plates();
		vat_hull();
	}
}

module combs(){
	vx1=46.036;
	vy1=-97;
	vx2=23.087;
	vy2=50;
	angle=90-atan((vy2-vy1)/(vx2-vx1));
	translate([-320/2,-12,100])
		rotate([angle,0,0])
			translate([0,0,-40])
				comb_air();
	translate([-320/2,12,100])
		rotate([-angle,0,0])
			translate([0,-39,-40])
				comb_air();
}

module comb_air(){
	include <elements/supercomb_air.scad>;
}

module combs_fog(){
	cfcells=60;
	cflength=320;
	cfheight=6;
	cfdepth=40;
	cfwalls=0.2;
	cfcellwidth=cflength/cfcells;
	union(){
		for(i=[-cfcells/2:cfcells/2-1]){
			translate([cfcellwidth/2+i*cfcellwidth,0,140-cfdepth/2])
				difference(){
					cube([cfcellwidth,cfheight,cfdepth],center=true);
					cube([cfcellwidth-2*cfwalls,cfheight-2*cfwalls,cfdepth],center=true);
				}
		}
	}
}
housing();
vat();