outer_hole_d = 2*40;
cable_d = 4;
slit_w = .5;
h = 2;

linear_extrude(h) {
	difference() {
		circle(d = outer_hole_d, $fn = $preview ? 30 : 130);
		// inner slit
		hull() {
			$fn = $preview ? 20 : 80;
			for(x = [-cable_d/2, cable_d/2])
				translate([x, 0])
					circle(d = cable_d);
			// just to prevent cable quetschen
			translate([0, cable_d/2])
				circle(d = cable_d);
		}
		// main slit
		translate([-slit_w/2,0])
			square([slit_w, outer_hole_d/2 + 1]);
	}
}