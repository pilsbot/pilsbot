ws = 2;

length = 24 + ws;
width = 18 + ws;
height = 6 + ws;

side_space = 6;
slot = 5;
screw_d = 3;


usbc = [9, 4];

case_dim = [2*ws + width, 2*ws + length, 2*ws + height];

otherside = case_dim.x + side_space;

slit_d = .8;
slit_h = case_dim.y - 2*ws;
h_to_slit_start = .5;

module rpi()
{
	cube([width, length, height]);
	translate([(width - usbc.x) / 2, -2*ws, (height - usbc.y) / 2])
		cube([usbc.x, 4*ws, usbc.y]);
}

module case()
{
	difference()
	{
		cube([otherside, case_dim.y, height + ws]);
		translate([(case_dim.x - width) / 2, (case_dim.y - length) / 2, (case_dim.z - height) / 2])
			rpi();
		// extra space
		translate([(otherside - width) - ws, (case_dim.y - length) / 2, (case_dim.z - height) / 2])
			cube([width, length, height]);

		// slot
		translate([otherside - ws - 1, (case_dim.y - slot) / 2, ws])
			cube([ws + 2, slot, height]);

		// screw hole
		translate([case_dim.x, side_space, -.1])
			cylinder(d = screw_d, h = 2 * ws, $fn = 50);

		// cap slit
		for(x = [ws, otherside - ws])
		{
			translate([x, ws, (height + ws) - (h_to_slit_start + slit_d/2) ])
				rotate([-90, 0, 0])
					cylinder(h = slit_h, d = slit_d, $fn = 8);
		}
	}
}

module upside_deggel()
{
	cube([otherside, case_dim.y, ws]);
	
	// wiggle-room
	wg = .5;
	tab_width = 1;
	
	needed_h = h_to_slit_start + slit_d;
	translate([0,0,ws])
	difference()
	{
		union()
		{
			translate([ws + wg/2, ws, 0])
				cube([otherside - 2 * (ws + wg/2), case_dim.y - 2 * ws, needed_h ]);
			
			// cap slit
			for(x = [ws + wg/2, otherside - (ws + wg/2)])
			{
				translate([x, ws, h_to_slit_start + slit_d / 2])
					rotate([-90, 0, 0])
						cylinder(h = slit_h, d = slit_d, $fn = 8);
			}
		}
		

		translate([ws + tab_width, ws, 0])
				cube([otherside - 2 * ws - 2 * tab_width, case_dim.y - 2 * ws, needed_h + 1 ]);
	}
}

module deggel()
{
	mirror([0,0,1]) upside_deggel();
}

!case();

translate([0,0,case_dim.z + 10])
	deggel();

