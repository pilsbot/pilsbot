receiver_d = 54;
receiver_tip_h = 3.5;
receiver_tip_offs = 6.5;
receiver_lower_d = 39;
receiver_h = 18.5;
receiver_top_d = 25.5;
receiver_top_slit = 13;

profil_w = 21;
profil_h = 13;
profil_screw_dist = 10;

screw_gripping_d = 1.3;

ws = 1;

module receiver() {
	hull(){
		cylinder(d = receiver_lower_d, h = 1, $fn = 100);
		translate([0,0,receiver_tip_offs])
			cylinder(d = receiver_d, h = receiver_tip_h, $fn = 12);
		translate([0,0,receiver_h-1])
			cylinder(d = receiver_top_d, h = 1, $fn = 100);
	}
}

difference() {
	minkowski() {
		receiver();
		sphere(d = ws*2);
	}
	
	receiver();
	
	// side einschub
	translate([2,-receiver_d/2-ws,ws]) {
		cube([receiver_d+2*ws, receiver_d+2*ws, receiver_h+ws]);
	}
	
	//slot top
	translate([receiver_top_slit/2-receiver_top_d/2-ws, 0,ws]) {
		translate([0, -receiver_top_slit/2, 0])
			cube([receiver_top_d, receiver_top_slit, receiver_h]);
		cylinder(d = receiver_top_slit, h = receiver_h);
	}
	
	/*
	#hull() {
		receiver();
		translate([-receiver_d, 0, 0])
			receiver();
	}
	*/
}

shelf = 2*ws;
// lower holder
translate([0, 0, -ws]) {
	difference() {
		hull() {
			cylinder(d = receiver_lower_d+ws, h = ws/2, $fn = 100);
			translate([receiver_lower_d/2-ws-shelf+ws/2, -profil_w/2, -profil_h-ws])
				cube([ws, profil_w, ws]);
		}
		//resting "shelf"
		translate([receiver_lower_d/2-shelf, -receiver_lower_d, -receiver_lower_d+ws])
			cube([receiver_lower_d/2, 2*receiver_lower_d, receiver_lower_d]);
		
		// screw holes
		for(y = [-profil_screw_dist/2, profil_screw_dist/2])
			translate([receiver_d/2, y, -2*profil_h/3])
				rotate([0, -90, 0])
					cylinder(d = screw_gripping_d, h = receiver_d, $fn = 20);
	}
}