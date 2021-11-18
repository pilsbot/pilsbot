chassis_tube_d = 26;
axle_tube_d = 23;
holder_w = 140;
grip_w = holder_w/4;
difference_offset=[0,7,13];
ws=2;
cable_extra_space=[9,3];
difference_to_upper_tube=135;	//intentionally a bit taller to have center of mass centered

$fn=$preview ? 50 : 200;

module clip(w_total, w_clip, h, tube_d, cube_offset=0, lolcut=false) {
	difference(){
		upper=[0, (chassis_tube_d)/2, h+tube_d/2];
		union() {
			translate([0, cube_offset, 0])
				cube([w_total, chassis_tube_d+ws, h+tube_d/2]);
			//clip
			translate(upper+[(w_total-w_clip)/2,-cube_offset/8,cube_offset/6]) rotate([0, 90, 0])
				cylinder(d=tube_d+2*ws,h=w_clip);
				
		}
		//side cut
		translate([-.5, -.5+cube_offset-ws, h])
			cube([w_total+1, tube_d/2+1+abs(cube_offset)+ws, lolcut ? tube_d : tube_d-ws]);
		//tube
		translate(upper-[.5,0,0]) rotate([0, 90, 0])
			cylinder(d=tube_d,h=w_total+1);
	}
}

difference(){
	union(){
		clip(grip_w, grip_w, difference_offset.z/2, chassis_tube_d);
		translate([0, difference_offset.y, 0]) mirror([0, 0, 1])
			clip(grip_w, grip_w, difference_offset.z/2, axle_tube_d, -difference_offset.y, true);
	}
	//make this lighter
	translate([-.5, -.5, -(difference_offset.z/2+.5)])
		cube([grip_w+1, (chassis_tube_d)/1.5+1, difference_offset.z+ws+1]);
}