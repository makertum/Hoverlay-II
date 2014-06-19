hole_dist=30;
hole_dia=3;

outer_dia=14;
walls=1.2;
inner_dia=outer_dia-2*walls;
inner_height=12.6;
cutout_height=4;
cutout_width=15;


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
contact_plate_thickness=holder_body_radius;
contact_plate_depth=holder_body_radius;
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
		cylinder(r=plug_bottom_radius,h=plug_bottom_height,center=true, $fn=16);
	// plug top
	translate([0,0,-plug_dive_length+(plug_bottom_height+plug_top_height)/2])
		cylinder(r=plug_top_radius,h=plug_top_height,center=true, $fn=16);
}

module holder(){
	difference(){
		// holder body
		translate([0,0,-slate_height-holder_body_height/2])
			cylinder(r=holder_body_radius,h=holder_body_height,center=true);
			
		plug();
	}
}

module holder_printable(){
rotate([0,180,0])
	translate([0,0,slate_height])
		holder();
}

module outer_case(){
	translate([0,0,(inner_height+walls)/2])
		cube([5*hole_dist,outer_dia,inner_height+walls],center=true);
	translate([-2.5*hole_dist,0,(inner_height+walls)/2])
		cylinder(r=outer_dia/2, h=inner_height+walls, center=true,$fn=36);
	translate([2.5*hole_dist,0,(inner_height+walls)/2])
		cylinder(r=outer_dia/2, h=inner_height+walls, center=true,$fn=36);
}

module inner_case(){
		translate([0,0,(inner_height+walls)/2+8]){
			cube([5*hole_dist-walls,inner_dia,inner_height],center=true);
			translate([-2.5*hole_dist,0,0])
				cylinder(r=inner_dia/2, h=inner_height, center=true,$fn=36);
			translate([2.5*hole_dist,0,0])
				cylinder(r=inner_dia/2, h=inner_height, center=true,$fn=36);
	}
}

module cutout(){
	translate([0,-(outer_dia-walls)/2,-cutout_height/2+inner_height+walls]){
		cube([cutout_width,walls,cutout_height],center=true);
	}
}

module top(){
	union(){
		translate([0,0,walls/2]){
			cube([5*hole_dist-walls,outer_dia,walls],center=true);
			translate([-2.5*hole_dist,0,0])
				cylinder(r=outer_dia/2, h=walls, center=true,$fn=36);
			translate([2.5*hole_dist,0,0])
				cylinder(r=outer_dia/2, h=walls, center=true,$fn=36);
		}
		translate([0,0,walls+walls/2]){
			cube([5*hole_dist-walls,inner_dia,walls],center=true);
			translate([-2.5*hole_dist,0,0])
				cylinder(r=inner_dia/2, h=walls, center=true,$fn=36);
			translate([2.5*hole_dist,0,0])
				cylinder(r=inner_dia/2, h=walls, center=true,$fn=36);
		}
		translate([0,-(outer_dia-walls)/2,walls/2+walls/2]){
			cube([cutout_width,walls,walls+walls],center=true);
		}
	}
}

module case(){
	difference(){
		outer_case();
		inner_case();
		cutout();
		for(i=[-2.5:1:2.5])
		translate([i*hole_dist,0,0])
			rotate([0,180,0])
					plug();
	}
}

//top();
case();