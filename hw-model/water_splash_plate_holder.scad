h = 90;
thickn = 3;
ws = 3;
feet_l = 10;
w = 20;

wood_screw_l = 16;
wood_screw_d = 3;
wood_screw_head = 2;

module screw(sunk = true, grip = false) {
	$fn = $preview ? 10 : 40;
	translate([0, 0, sunk ? -(wood_screw_head-.1) : 0]) {
		translate([0,0,-wood_screw_l])
			cylinder(h = wood_screw_l, d = grip ? wood_screw_d-.5 : wood_screw_d);
		cylinder(h = wood_screw_head, d1 = wood_screw_d, d2 = wood_screw_d + 2*wood_screw_head);
	}
}

module holder_2d() {
	square([ws, h-thickn]);
	square([ws + feet_l, ws]);
	translate([ws, (h-thickn)-ws])
		mirror([1, 0])
			square([ws + feet_l, ws]);
}


difference() {
	linear_extrude(w) {
		holder_2d();
	}
	
	step = w / 2;
	for(z = [step/2 : step : w-1]) {
		translate([ws + feet_l/2, ws, z]) rotate([-90, 0, 0]) screw();
	}
	translate([0, 0, w/2]) {
		step = h / 3;
		for( y = [step/2 : step : h-1] ){
			translate([ws, y, 0])
				rotate([0, 90, 0]) screw(sunk = false, grip = true);
		}
		translate([-feet_l/2, h, 0])
			rotate([-90, 0, 0]) screw(sunk = false, grip = true);
	}
}