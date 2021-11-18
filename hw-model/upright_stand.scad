chassis_tube_d = 26;
holder_w = 140;
grip_w = holder_w/4;
ws=2;
cable_extra_space=[9,3];
difference_to_upper_tube=135;	//intentionally a bit taller to have center of mass centered

$fn=$preview ? 50 : 200;

module clip(w_total, w_clip, h) {
	difference(){
		upper=[0, (chassis_tube_d+2*ws)/2, h+chassis_tube_d/2];
		union() {
			cube([w_total, chassis_tube_d+2*ws, h+chassis_tube_d/2]);
			//clip
			translate(upper+[(w_total-w_clip)/2,0,0]) scale([1, 1, (chassis_tube_d-ws)/(chassis_tube_d+2*ws)]) rotate([0, 90, 0])
				cylinder(d=chassis_tube_d+2*ws,h=w_clip);
				
		}
		//tube
		translate(upper-[.5,0,0]) rotate([0, 90, 0])
			cylinder(d=chassis_tube_d,h=w_total+1);
		
		//cut high clip
		translate(upper+[(w_total-w_clip)/2-1, -(chassis_tube_d+2*ws)/2, chassis_tube_d/4])
			cube([w_clip+2, (chassis_tube_d+2*ws), (chassis_tube_d+2*ws)]);
	}
}

difference(){
	clip(holder_w, grip_w, 2*cable_extra_space.y);
	//cable canal
	translate([-1, (chassis_tube_d+2*ws)/2-cable_extra_space.x/2, cable_extra_space.y])
		cube([holder_w+2, cable_extra_space.x, cable_extra_space.y*2]);
		
	//text
	translate([holder_w/2, (chassis_tube_d+2*ws)/2, -1]) linear_extrude(1.25) rotate([0,180])
		text("AUTATIME", halign="center", valign="center",size=20);
}

translate([(holder_w-grip_w)/4, 2*chassis_tube_d])
	clip(grip_w, grip_w, 2*cable_extra_space.y+difference_to_upper_tube);

translate([3*(holder_w-grip_w)/4, 2*chassis_tube_d])
	clip(grip_w, grip_w, 2*cable_extra_space.y+difference_to_upper_tube);