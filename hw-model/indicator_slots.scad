inner_w = 15;
height = 6;
curvature_r = 70;
rohr_d = 25;
ws = 1.5;
front_ws = 1.2 * ws;
end_l1 = 65/2;
end_l2 = 70 + end_l1;
kabelbinder_w = 2.5+1;
kabelbinder_h = 1.1+1;
nasenbreite = 3;
nase_every = 4;

wide = rohr_d -  4;
end_slot_dist = 8;
slot_innenversatz = 0; // -ws

show = "both"; // front , base, both

module nase2d(extra_l = 2)
{
	w = 1;
	offset(r=-w) offset(delta=+w) union()
	{
		translate([0, -2*w])
			square([w, extra_l + 2*w]);
		translate([0, -w])
			square([2*w, w]);
	}
}

module front(mit_nase = true)
{
	translate([-wide/2, 0])
	{
		translate([0, height])
			square([wide, front_ws]);
		
		if (mit_nase)
		{
			nase2d(height);
			translate([wide, 0])
				mirror([1, 0, 0])
					nase2d(height);
		}
	}
}

//!front();

module base_schnitt(mit_nase = true)
{
	difference()
	{
		translate([-wide/2, 0])
		{
			difference()
			{
				union()
				{
					difference()
					{
						square([wide, height]);
						translate([(wide - inner_w) / 2, 0])
							square([inner_w, height]);
					}
					
					// round thing
					difference()
					{
						translate([0, -rohr_d/2])
							square([wide, rohr_d/2]);
						translate([wide/2, -(rohr_d/2 + max(ws, kabelbinder_h))])
							circle(d = rohr_d, $fn = $preview ? 40 : 200);
					}
				}
				
				
			}
		}
	front(mit_nase);
	}
}


module kb_slot()
{
	translate([rohr_d/2+kabelbinder_h, -(rohr_d + kabelbinder_h -.2), 0])
	rotate_extrude()
		translate([rohr_d, 0])
			square([kabelbinder_h, kabelbinder_w]);
	
	//cube([wide + ws * 2 + 2, kabelbinder_h, kabelbinder_w]);
}

module segment(length, which = "both", also_start_hole = false)
{
	base = which == "both" || which == "base";
	front = which == "both" || which == "front";
	difference()
	{
		for (subsegment = [0 : nasenbreite : length + (nasenbreite / 2)])
		{
			nase = (subsegment / nasenbreite) % nase_every == 0;
			subsegment_h = nasenbreite + subsegment > length ? length - subsegment : nasenbreite;
			//echo (subsegment, nase, subsegment_h);
			translate([0, 0, subsegment])
			{
				if (base)
					linear_extrude(subsegment_h, convexity = 4)
						base_schnitt(mit_nase = nase);
				if (front)
					color("#AABB55")
						linear_extrude(subsegment_h, convexity = 4)
							front(mit_nase = nase);
			}
		}
		z = [length - end_slot_dist, end_slot_dist];
		translate([-1 - ((wide + 2*ws) / 2), slot_innenversatz, z[0]])
			kb_slot();
		if (also_start_hole)
			translate([-1 - ((wide + 2*ws) / 2), slot_innenversatz, z[1]])
				kb_slot();
	}
}

module rounding(which = "both", nasen_offset = 0)
{
	base = which == "both" || which == "base";
	front = which == "both" || which == "front";
	einmal_rum = 90;
	
	difference()
	{
		guess_instead_of_algebra = nasenbreite * .9;
		for(subsegment = [0 : guess_instead_of_algebra : einmal_rum])
		{
			nase = (nasen_offset + (subsegment / guess_instead_of_algebra)) % nase_every < 1;
			segment_r = guess_instead_of_algebra + subsegment > einmal_rum ? einmal_rum - subsegment : guess_instead_of_algebra;
			// echo (subsegment, segment_r, nase);
			rotate([0, 0, subsegment])
			{
				if (base)
					rotate_extrude(angle = segment_r , $fn = $preview ? 30 : 300)
						translate([curvature_r, 0])
							rotate(-90)
								base_schnitt(mit_nase = nase);
				if (front)
					color("#AABB55")
						rotate_extrude(angle = segment_r , $fn = $preview ? 30 : 300)
							translate([curvature_r, 0])
								rotate(-90)
									front(mit_nase = nase);
			}
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
			segment(end_l1, which = show);

rounding(nasen_offset = 1, which = show);

translate([curvature_r, 0, 0])
	rotate([90, 90, 0])
		segment(end_l2, also_start_hole = true, which = show);