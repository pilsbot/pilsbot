inner_w = 14;
height = 6;
curvature_r = 70;
rohr_d = 25;
ws = 1.5;
front_ws = 1.2 * ws;
end_l1 = 65/2;
end_l2 = 70 + end_l1;
kabelbinder_w = 2.5+1.5;
kabelbinder_h = 1.1+1;
nasenbreite = 3.5;
nasen_h = 1;
nasenspiel = .5;
nase_every = 10;

wide = rohr_d -  4;
end_slot_dist = 8;
slot_innenversatz = 0; // -ws

show = "both"; // front , base, both

module nase2d(extra_l = 2)
{
	offset(r=-nasen_h) offset(delta=+nasen_h) union()
	{
		translate([0, -2*nasen_h])
			square([nasen_h, extra_l + 2*nasen_h]);
		translate([0, -nasen_h])
			square([2*nasen_h, nasen_h]);
	}
}

module front(mit_nase = true, als_positiv = true)
{
	translate([-wide/2, 0])
	{
		translate([0, height])
			square([wide, front_ws]);
		
		if (mit_nase)
		{
			offset(als_positiv ? 0 : nasenspiel)
			{
				nase2d(height);
				translate([wide, 0])
					mirror([1, 0, 0])
						nase2d(height);
			}
		}
	}
}

//!front(als_positiv=true);

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
	front(mit_nase, als_positiv = false);
	}
}

//!base_schnitt(mit_nase = true);


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
	nasen_counter_offset = nase_every / 2;
	difference()
	{
		for (subsegment = [0 : nasenbreite  : length + (nasenbreite / 2)])
		{
			nase = (subsegment / nasenbreite) % nase_every == nasen_counter_offset;// && subsegment > 2 * nasenspiel;
			//echo ((subsegment / nasenbreite), nase_every, (subsegment / nasenbreite) % nase_every, nase);
			subsegment_h = nasenbreite + subsegment > length ? length - subsegment : nasenbreite;
			//echo (subsegment, nase, subsegment_h);
			translate([0, 0, subsegment])
			{
				if (base)
				{
					linear_extrude(subsegment_h, convexity = 4)
						base_schnitt(mit_nase = nase);
				}
				color("#AABB55")
				if (front)
				{
					local_spiel = subsegment_h > 2 * nasenspiel ? nasenspiel : 0;
					subsubsegments = [local_spiel, subsegment_h - (2*local_spiel), local_spiel];
					translate([0,0,0])
						linear_extrude(subsubsegments[0])
							front(mit_nase = false);
					translate([0,0,subsubsegments[0]])
						linear_extrude(subsubsegments[1], convexity = 4)
								front(mit_nase = nase);
					translate([0,0,subsubsegments[0] + subsubsegments[1]])
						linear_extrude(subsubsegments[2])
							front(mit_nase = false);
				}
			}
		}
		z = [length - end_slot_dist, end_slot_dist];
		translate([-1 - ((rohr_d + 2*ws) / 2), slot_innenversatz, z[0]])
			kb_slot();
		if (also_start_hole)
			translate([-1 - ((rohr_d + 2*ws) / 2), slot_innenversatz, z[1]])
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
		guess_instead_of_algebra = .75;
		nasenbreite_winkel = nasenbreite * guess_instead_of_algebra;
		nasenfaktor = 1.2;	// lol
		nasen_counter_offset = 7;
		
		for(subsegment = [0 : nasenbreite_winkel : einmal_rum])
		{
			nase = (nasen_offset + (subsegment / nasenbreite_winkel)) % (nase_every * nasenfaktor) == (nasen_counter_offset + 1);
			segment_r = guess_instead_of_algebra + subsegment > einmal_rum ? einmal_rum - subsegment : nasenbreite_winkel;
			// echo (subsegment, segment_r, nase);
			rotate([0, 0, subsegment])
			{
				if (base)
					rotate_extrude(angle = segment_r, $fn = $preview ? 30 : 300)
						translate([curvature_r, 0])
							rotate(-90)
								base_schnitt(mit_nase = nase);
				color("#AABB55")
				if (front)
				{
					local_spiel = segment_r > 2 * nasenspiel * guess_instead_of_algebra ? nasenspiel * guess_instead_of_algebra: 0;
					subsubsegments = [local_spiel, segment_r - (2*local_spiel), local_spiel];
					rotate([0, 0, 0])
						rotate_extrude(angle = subsubsegments[0], $fn = $preview ? 30 : 300)
							translate([curvature_r, 0])
								rotate(-90)
									front(mit_nase = false);
					rotate([0, 0, subsubsegments[0]])
						rotate_extrude(angle = subsubsegments[1] , $fn = $preview ? 30 : 300)
							translate([curvature_r, 0])
								rotate(-90)
									front(mit_nase = nase);
					rotate([0, 0, subsubsegments[0] + subsubsegments[1]])
						rotate_extrude(angle = subsubsegments[2], $fn = $preview ? 30 : 300)
							translate([curvature_r, 0])
								rotate(-90)
									front(mit_nase = false);
				}
			}
		}
		for (angle = [/*1 * 90 / 4, */ 2 * 90/4 /*, 3 * 90 / 4 */])
			rotate([0, 0, (180 + 90) + angle])
				translate([0, curvature_r])
					rotate([0, -90, 0])
						translate([-1 - ((rohr_d + 2*ws) / 2), slot_innenversatz, -kabelbinder_w/2])
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