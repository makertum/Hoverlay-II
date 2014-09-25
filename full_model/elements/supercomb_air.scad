top_width=39;
bottom_width=39;
col_offset=0;
length=160;
height=40;
rows=12; // 16
cols=30; // 40
walls_bottom=0.3;
walls_top=0.3;
deflux=0.01;
//col_length=(length-walls)/cols;
col_length=4*(length)/(3*cols+0.5);
top_row_width=2*(top_width)/(rows+1);
bottom_row_width=2*(bottom_width)/(rows+1);

straws();
translate([length-0.125*col_length,0,0])
	straws();

module frame(){
	//real_length=col_length+(cols/2-1)*(col_length+0.5*col_length);
	real_length=length;
	box(points=[
		[
			0,
			col_offset,
			0
		],
		[
			real_length,
			col_offset,
			0
		],
		[
			real_length,
			bottom_width+col_offset,
			0
		],
		[
			0,
			bottom_width+col_offset,
			0
		],
		[
			0,
			0,
			height
		],
		[
			real_length,
			0,
			height
		],
		[
			real_length,
			top_width,
			height
		],
		[
			0,
			top_width,
			height
		]
	]);
}

module frame_cutout(){
	box(points=[
		[
			walls,
			col_offset+walls,
			0
		],
		[
			length-walls,
			col_offset+walls,
			0
		],
		[
			length-walls,
			bottom_width+col_offset-walls,
			0
		],
		[
			walls,
			bottom_width+col_offset-walls,
			0
		],
		[
			walls,
			walls,
			height
		],
		[
			length-walls,
			walls,
			height
		],
		[
			length-walls,
			top_width-walls,
			height
		],
		[
			walls,
			top_width-walls,
			height
		]
	]);
}

module straws(){
	union(){
		for(y=[0:2:rows-1]){
			for(x=[0:1:cols-1]){
				hexastraw(			
					x_bot=0.5*col_length+x*(3/4*col_length),
					y_bot=(x%2+y+1)*bottom_row_width/2+col_offset,
					z_bot=0,
					x_top=0.5*col_length+x*(3/4*col_length),
					y_top=(x%2+y+1)*top_row_width/2,
					z_top=height,
					w_bot=col_length+deflux,
					h_bot=bottom_row_width+deflux,
					w_top=col_length+deflux,
					h_top=top_row_width+deflux,
					walls_bot=walls_bottom,
					walls_top=walls_top
				);
			}
		}
	}
}

module box_ref(_length,_top_width,_bottom_width,_height,_offset){
	scaling_factor=_top_width/(_bottom_width+_offset);
	difference(){
		linear_extrude(height = _height, scale = [1,scaling_factor]){
			square ([_length,_bottom_width+_offset]);
		}
		translate([-_length,-_offset,-_height])
			linear_extrude(height = 3*_height, scale = [1,0])
				square ([3*_length,3*_offset]);
	}
}

module box(points=[[0,0,0],[100,0,0],[100,100,0],[0,100,0],[0,0,100],[100,0,100],[100,100,100],[0,100,100]]){
	polyhedron(
		points=[points[0],points[1],points[2],points[3],points[4],points[5],points[6],points[7]],
		triangles=[
			[0,5,1], // front
			[0,4,5], // front
			[3,6,7], // back
			[3,2,6], // back
			[7,5,4], // top
			[7,6,5], // top
			[1,3,0], // bottom
			[1,2,3], // bottom
			[7,0,3], // left
			[7,4,0], // left
			[5,2,1], // right
			[5,6,2]  // right
		]
	);
}

module hexagon(x_bot, y_bot, z_bot, x_top, y_top, z_top, w_bot, h_bot, w_top, h_top){
	//off_x_bot=sqrt(abs(pow(w_bot,2)-pow(h_bot,2)))/2;
	//off_x_top=sqrt(abs(pow(w_top,2)-pow(h_top,2)))/2;
	off_y_bot=h_bot/2;
	off_y_top=h_top/2;
	r_bot=w_bot/2;
	r_top=w_top/2;
	off_x_bot=0.5*r_bot;
	off_x_top=0.5*r_top;
	polyhedron(
		points=[
			// bottom
			[x_bot-r_bot,y_bot,z_bot],						// 0
			[x_bot-off_x_bot,y_bot+off_y_bot,z_bot],	// 1
			[x_bot+off_x_bot,y_bot+off_y_bot,z_bot],	// 2
			[x_bot+r_bot,y_bot,z_bot],						// 3
			[x_bot+off_x_bot,y_bot-off_y_bot,z_bot],	// 4
			[x_bot-off_x_bot,y_bot-off_y_bot,z_bot],	// 5
			// top
			[x_top-r_top,y_top,z_top],						// 6
			[x_top-off_x_top,y_top+off_y_top,z_top],	// 7
			[x_top+off_x_top,y_top+off_y_top,z_top],	// 8
			[x_top+r_top,y_top,z_top],						// 9
			[x_top+off_x_top,y_top-off_y_top,z_top],	// 10
			[x_top-off_x_top,y_top-off_y_top,z_top]		// 11
		],
		faces=[
			[0,7,6],
			[0,1,7],
			[1,8,7],
			[1,2,8],
			[2,9,8],
			[2,3,9],
			[10,9,3],
			[10,3,4],
			[11,4,5],
			[11,10,4],
			[6,5,0],
			[6,11,5],
			[11,6,7],
			[11,7,8],
			[11,8,10],
			[10,8,9],
			[5,1,0],
			[5,2,1],
			[5,4,2],
			[4,3,2]
		]
	);
}

module hexastraw(x_bot, y_bot, z_bot, x_top, y_top, z_top, w_bot, h_bot, w_top, h_top,walls_bot,walls_top){
	angle_bot=atan(h_bot/w_bot);
	angle_top=atan(h_top/w_top);
	walls_corr_bot=(h_bot-walls_bot)/h_bot;
	walls_corr_top=(h_top-walls_top)/h_top;

	difference(){
		hexagon(
			x_bot=x_bot,
			y_bot=y_bot,
			z_bot=z_bot,
			x_top=x_top,
			y_top=y_top,
			z_top=z_top,
			w_bot=w_bot,
			h_bot=h_bot,
			w_top=w_top,
			h_top=h_top
		);
		hexagon(
			x_bot=x_bot,
			y_bot=y_bot,
			z_bot=z_bot,
			x_top=x_top,
			y_top=y_top,
			z_top=z_top,
			w_bot=w_bot*walls_corr_bot,
			h_bot=h_bot-walls_bot,
			w_top=w_top*walls_corr_top,
			h_top=h_top-walls_top
		);
	}
}