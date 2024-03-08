wide = 15;
height = 6;
curvature_r = 70;
rohr_d = 25;
ws = 1.2;
end_l1 = 65/2;
end_l2 = 65 + end_l1;
kabelbinder_w = 2.5+1;
kabelbinder_h = 1.1+1;

end_slot_dist = 8;
slot_innenversatz = 0; // -ws

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

module segment(length, also_start_hole = false)
{
	difference()
	{
		linear_extrude(length, convexity = 4)
			schnitt();
		z = [length - end_slot_dist, end_slot_dist];
		translate([-1 - ((wide + 2*ws) / 2), slot_innenversatz, z[0]])
			kb_slot();
		if (also_start_hole)
			translate([-1 - ((wide + 2*ws) / 2), slot_innenversatz, z[1]])
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
						translate([-1 - ((wide + 2*ws) / 2), slot_innenversatz, -kabelbinder_w/2])
							kb_slot();
	}
}

translate([0, curvature_r, 0])
	mirror([0,0,1])
		rotate([0, -90, 0])
			segment(end_l1);

rounding();

translate([curvature_r, 0, 0])
	rotate([90, 90, 0])
		segment(end_l2, also_start_hole = true);