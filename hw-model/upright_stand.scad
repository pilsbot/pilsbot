chassis_tube_d = 26.5;
holder_w = 140;
grip_w = holder_w/4;
ws=2;
cable_extra_space=[9,3];

$fn=$preview ? 50 : 200;

difference(){
	upper=[-.5, (chassis_tube_d+2*ws)/2, 2*cable_extra_space.y+chassis_tube_d/2];
	union() {
		cube([holder_w, chassis_tube_d+2*ws, 2*cable_extra_space.y+chassis_tube_d/2]);
		//clip
		translate(upper+[(holder_w-grip_w)/2,0,0]) scale([1, 1, (chassis_tube_d-ws)/(chassis_tube_d+2*ws)]) rotate([0, 90, 0])
			cylinder(d=chassis_tube_d+2*ws,h=grip_w);
			
	}
	//tube
	translate(upper) rotate([0, 90, 0])
		cylinder(d=chassis_tube_d,h=holder_w+1);
	
	//cable canal
	translate(upper-[1, cable_extra_space.x/2, chassis_tube_d/2+cable_extra_space.y])
		cube([holder_w+2, cable_extra_space.x, cable_extra_space.y*2]);
	
	//cut high clip
	
	
	//text
	translate([holder_w/2, (chassis_tube_d+2*ws)/2, -1]) linear_extrude(1.25) rotate([0,180])
		text("AUTATIME", halign="center", valign="center",size=20);
}

