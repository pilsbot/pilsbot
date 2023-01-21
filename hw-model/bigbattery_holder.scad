base_w = 85;
base_lip_h = 1.25;
body_lower_w = 81.5;
body_upper_w = 85;
top_w = 92;
top_h = 6;
total_h = 80;
hole_at_h = 50;
hole_h = 14;

ws = 2.5;

module back_cap_half_2d() {
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

module back_cap_half() {
	linear_extrude(1) {
		back_cap_half_2d();
	}
}

back_cap_half();
mirror([1, 0, 0])
	back_cap_half();