base_w = 85;
base_lip_h = 1.85;
body_lower_w = 81.5;
body_upper_w = 85;
top_w = 92;
top_h = max(6, 12); // screws are poking out
					// FIXME: This makes angle a bit wrong.
total_h = 80+1;
hole_at_h = 60;
hole_h = 14+15;
hole_w = 20+20;
batt_l = 370;

ws = 2.75;
plate_clearance = 30;	// TODO: Check if still enough room for wheels
holder_l = 100;
fins_l = 20;
fins_h = 4;

wood_screw_l = 16;
wood_screw_d = 3;
wood_screw_head = 2;

pin_d = 3;
pin_h = 5;

module screw(sunk = true) {
	$fn = $preview ? 10 : 40;
	translate([0, 0, sunk ? -(wood_screw_head-.1) : 0]) {
		translate([0,0,-wood_screw_l])
			cylinder(h = wood_screw_l, d = wood_screw_d);
		cylinder(h = wood_screw_head, d1 = wood_screw_d, d2 = wood_screw_d + 2*wood_screw_head);
	}
}

module back_cap_half_2d(expand = true) {
	// lower lip
	square([base_w/2, base_lip_h]);
	// body
	translate([0, base_lip_h])
		polygon([
			[0,0],
			[body_lower_w/2, 0],
			[body_upper_w/2, total_h - top_h],
			[0, total_h - top_h]
		]);
	translate([0, total_h - top_h]) {
		square([top_w/2, top_h]);
	}
}

module back_cap_half(expand = true) {
	expansion = .4;
	linear_extrude(batt_l) {
		back_cap_half_2d();
	}
}

module battery_upright() {
	back_cap_half();
	mirror([1, 0, 0])
		back_cap_half();
}

module back_holder_half_2d(with_battery = true, with_fins = true) {
	difference() {
		union() {
			// battery
			//square([top_w/2+ws, ws + total_h]);
			polygon([
				[0, 0],
				[base_w/2 + ws, 0],
				[top_w/2+ws, ws + total_h],
				[0, ws + total_h]
			]);
			// base
			translate([0, ws+total_h])
				square([top_w/2+ws, ws]);
			if(with_fins) {
				// holders
				translate([top_w/2, ws+total_h])
					square([ws, plate_clearance]);
				// fins
				translate([top_w/2, ws+total_h+plate_clearance])
					square([ws+fins_l, fins_h]);
			}
		}
		if(with_battery){
			translate([0, ws])
				minkowski() {
					back_cap_half_2d();
					circle(d = .5, $fn = 20);
				}
		}
	}
}

//!back_holder_half_2d();

module holder_half(close = false) {
	difference() {
		union() {
			if(close){
				linear_extrude(ws)
					difference() {
						back_holder_half_2d(with_battery = false);
						// battery cable hole
						translate([0, hole_at_h])
							hull(){
								$fn = 80;
								// big hole to fummel the cable out there
								circle(d = hole_h);
								translate([(hole_w-hole_h)/2, 0]) circle(d = hole_h);
								translate([0, -hole_h/2])
								circle(d = hole_h/2);
							}
					}
			}
			translate([0, 0, ws])
				linear_extrude(holder_l/3)
					back_holder_half_2d(with_battery = true);
			translate([0, 0, ws+holder_l/3])
				linear_extrude(holder_l/3)
					back_holder_half_2d(with_battery = true, with_fins = false);
			translate([0, 0, ws + 2 * holder_l/3])
				linear_extrude(holder_l/3)
					back_holder_half_2d(with_battery = true);
		}
		parts = holder_l / 6;
		for(z = [parts/2 : parts : holder_l-1]) {
			translate([top_w/2+ws+fins_l/2, ws+total_h+plate_clearance, z+ws])
				rotate([90, 0, 0])
					screw();
		}
	}
}

module holder(close = false) {
	holder_half(close);
	mirror([1, 0, 0]) holder_half(close);
}

module back_holder(){
	holder(close = true);
}

module front_holder(){
	
	holder(close = false);
	for(m = [0, 1]) {
		mirror([m, 0, 0])
			translate([body_lower_w/2+(body_upper_w-body_lower_w)/4+ws, total_h/2, holder_l/4])
				rotate([0, 80, 0])
					cylinder(d = pin_d, h = pin_h + ws, $fn = 60);
	}
}

//back_holder();
front_holder();
