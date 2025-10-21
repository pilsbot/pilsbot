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
		#translate([case_dim.x, side_space, -.1])
			cylinder(d = screw_d, h = 2 * ws, $fn = 50);
	}
}

module deggel()
{
	cube([otherside, case_dim.y, ws]);
}

!case();

translate([0,0,case_dim.z])
	deggel();

