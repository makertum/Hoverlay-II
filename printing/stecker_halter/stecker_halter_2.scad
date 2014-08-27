// Hoverlay II power connector mount
// created by Moritz Walter, 2014
// licensed under GPL V3
// all infos at iamnotachoice.com/hoverlay-2

$fn=32;

plug_bottom_radius=5.0/2; // must: 4.7/2 is 4.2/2
plug_bottom_height=5;
plug_total_height=12;
plug_top_height=plug_total_height-plug_bottom_height;
plug_top_radius=5.2/2; // must: 4.2/2  is: 3.9/2
plug_dive_length=17.2/2;

slate_height=3;
slate_side=10;

connector_distance=30;

cable_shoe_height=0.8;
cable_shoe_radius=7.2/2;

holder_mount_radius=17.5/2; // max. 17.5
holder_body_radius=9.5/2; // max. 17.5
holder_mount_height=2;
holder_body_height=plug_dive_length-slate_height;
holder_screw_radius=4/2;

holder_screw_radius=1.5/2;
holder_screw_offset=1.7;

contact_screw1_offset=5;
contact_screw2_offset=7;
contact_screw_radius=3/2;
contact_plate_height=10;
contact_plate_depth=holder_mount_radius;
contact_plate_width=8.84;
contact_plate_offset=0;
contact_plate_radius=7.5;
contact_plate_fn=6;

drill_hole_radius=2/2;
drill_hole_offset=6.5;

holder_total_height=holder_body_height+contact_plate_height;

module plug(){
	// plug bottom
	translate([0,0,-plug_dive_length+plug_bottom_height/2])
		cylinder(r=plug_bottom_radius,h=plug_bottom_height,center=true);
	// plug top
	translate([0,0,-plug_dive_length+(plug_bottom_height+plug_top_height)/2])
		cylinder(r=plug_top_radius,h=plug_top_height,center=true);
}

module holder(){
	difference(){
		union(){
			// holder mount
			translate([0,0,-slate_height-holder_mount_height/2])
				cylinder(r=holder_mount_radius,h=holder_mount_height,center=true);
			
			// holder body
			translate([0,0,-slate_height-holder_body_height/2])
				cylinder(r=holder_body_radius,h=holder_body_height,center=true);
			
			// contact plate
			intersection(){
				union(){
				translate([0,-(holder_mount_radius+plug_bottom_radius-contact_plate_offset)/2,-slate_height-holder_total_height/2+contact_plate_width/4])
					cube([contact_plate_width,holder_mount_radius-plug_bottom_radius+contact_plate_offset,holder_total_height-contact_plate_width/2],center=true);
				translate([0,-(holder_mount_radius+plug_bottom_radius-contact_plate_offset)/2,-slate_height-holder_total_height+contact_plate_width/2])
					rotate([90,0,0])
						cylinder(r=contact_plate_width/2,h=holder_mount_radius-plug_bottom_radius+contact_plate_offset,center=true);
				}
				translate([0,0,-holder_total_height/2-slate_height])
					cylinder(r=contact_plate_radius,h=holder_total_height,center=true,$fn=contact_plate_fn);
			}

		}
		/*
		// holder screw
		translate([0,0,-plug_dive_length+holder_screw_offset])
			rotate([90,0,0])
				cylinder(r=holder_screw_radius,h=30,center=true);
		*/

		// drill_hole 1
		translate([-drill_hole_offset,0,-slate_height-holder_mount_height/2])
				cylinder(r=drill_hole_radius,h=30,center=true);
		// drill_hole 2
		translate([drill_hole_offset,0,-slate_height-holder_mount_height/2])
				cylinder(r=drill_hole_radius,h=30,center=true);

		// contact screw  1
		translate([0,0,-plug_dive_length-contact_screw1_offset])
			rotate([90,0,0])
				cylinder(r=contact_screw_radius,h=30,center=true);

		// contact screw  2
		translate([0,0,-plug_dive_length-contact_screw2_offset])
			rotate([90,0,0])
				cylinder(r=contact_screw_radius,h=30,center=true);

		// contact screw gap
		translate([0,0,-plug_dive_length-contact_screw2_offset+(contact_screw2_offset-contact_screw1_offset)/2])
			cube([contact_screw_radius*2,30,contact_screw2_offset-contact_screw1_offset],center=true);

		plug();
	}

}

module slate(){
	difference(){
		translate([0,0,-slate_height/2])
			cube([slate_side,slate_side,slate_height],center=true);
		plug();
	}
}

//slate();
module holder_printable(){
rotate([0,180,0])
	translate([0,0,slate_height])
		holder();
}

//plug();
//holder();
holder_printable();
