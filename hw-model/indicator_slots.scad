wide = 15;
height = 6;
curvature_r = 70;
rohr_d = 25;
ws = 1;
end_l = 65;
kabelbinder_w = 2.5;
kabelbinder_h = 1.1;

module schnitt()
{
	translate([- (ws + wide/2), 0])
	{
		difference()
		{
			square([wide + 2 *ws, height+ws]);
			translate([ws, 0])
				square([wide, height]);
		}
		
		// round thing
		difference()
		{
			translate([0, -rohr_d/2])
				square([wide + 2 *ws, rohr_d/2]);
			translate([ws + wide/2, -(rohr_d/2 + ws)])
				circle(d = rohr_d, $fn = $preview ? 40 : 200);
		}
	}
}

module kb_slot()
{
	cube([wide + ws * 2 + 2, kabelbinder_h, kabelbinder_w]);
}

module segment()
{
	difference()
	{
		linear_extrude(end_l, convexity = 4)
			schnitt();
		for (z = [1 * end_l / 4, 3 * end_l / 4])
			translate([-1 - ((wide + 2*ws) / 2), -ws, z])
				kb_slot();
	}
}

module rounding()
{
	difference()
	{
		rotate_extrude(angle = 90, $fn = $preview ? 30 : 300)
		{
		translate([curvature_r, 0])
			rotate(-90)
				schnitt();
		}
		for (angle = [1 * 90 / 4, 2 * 90/4, 3 * 90 / 4])
			rotate([0, 0, (180 + 90) + angle])
				translate([0, curvature_r])
					rotate([0, -90, 0])
						translate([-1 - ((wide + 2*ws) / 2), -ws, -kabelbinder_w/2])
							kb_slot();
	}
}

translate([0, curvature_r, 0])
	mirror([0,0,1])
		rotate([0, -90, 0])
			segment();

rounding();

translate([curvature_r, 0, 0])
	rotate([90, 90, 0])
		segment();