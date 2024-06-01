$fa = $preview ? 8 : 4;
$fs = $preview ? 3 : 0.25;

screw_d = 1.5;
root_box = [100,40,10];
logging_box = [100,35.5,13];

box = logging_box;

thickness = 2;
roundung = 1;
length = 10;

difference()
{
	translate([(box.x-length)/2, -(thickness-roundung), 0])
	{
		difference()
		{
			minkowski(){
				union()
				{
					cube([length, box.y+2*(thickness-roundung), box.z+(thickness-roundung)]);
					translate([0, -3*thickness-roundung/2, 0])
						cube([length, box.y+8*thickness-roundung, (thickness-roundung)]);
				}
				sphere(r=roundung);
			};
			#translate([length/2, -2*thickness, -25]) cylinder(d=screw_d, h = 50);
			#translate([length/2, box.y+3*thickness, -25]) cylinder(d=screw_d, h = 50);
			translate([-50, -thickness*5, -49.5])cube([100, 200, 50]);
		}
	}
	#cube(box);
}