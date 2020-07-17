$fa = $preview ? 8 : 4;
$fs = $preview ? 3 : 0.25;

screw_d = 4;
box = [84,135,39];
box_middle = [box.x,70,57];


thickness = 4;
roundung = 2;
length = 20;

difference()
{
	translate([(box.x-length)/2, -(thickness-roundung), 0])
	{
		difference()
		{
			minkowski(){
				union()
				{
					hull()
					{
						cube([length, box.y+2*(thickness-roundung), box.z+(thickness-roundung)]);
						translate([0, box.y/2-box_middle.y/2])
							cube([length, box_middle.y+2*(thickness-roundung), box_middle.z+(thickness-roundung)]);
					}
					translate([0, -3*thickness-roundung/2, 0])
						cube([length, box.y+8*thickness-roundung, (thickness-roundung)]);
				}
				sphere(r=roundung);
			};
			x1 = length/4;
			x2 = 3*length/4;
			y1 = -2*thickness;
			y2 = box.y+3*thickness;
			#translate([x1, y1, -25]) cylinder(d=screw_d, h = 50);
			#translate([x1, y2, -25]) cylinder(d=screw_d, h = 50);
			#translate([x2, y1, -25]) cylinder(d=screw_d, h = 50);
			#translate([x2, y2, -25]) cylinder(d=screw_d, h = 50);
			translate([-50, -thickness*5, -49.5])cube([100, 200, 50]);
		}
	}
	#hull()
	{
		cube(box);
		translate([0, box.y/2-box_middle.y/2]) cube(box_middle);
	}
}