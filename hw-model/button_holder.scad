$fa = $preview ? 8 : 3;
$fs = $preview ? 3 : 0.25;


hole_d = 4.9;
hole_distance = 20;
hole_to_wall = 6;
thickness = 3;

switch_dim = [6.3, 12.8, 5.8];
switch_hole_d = 1.5;
switch_holes = [1,2];
switch_holes_extra = 2*.7;

right = 2*hole_to_wall;
top = 2*hole_distance;

screw_d = 3;

module plate(extra_distance = 0)
{
	color("grey") linear_extrude(thickness) difference()
	{
		square([right+extra_distance, top]);
		translate([hole_to_wall, hole_distance/2])
		{
			circle(d=hole_d);
			translate([0, hole_distance])
				circle(d=hole_d);
		}
	}
}

module switch()
{
	color("#303030") difference()
	{
		union()
		{
			cube(switch_dim);
			translate([switch_holes.x, switch_holes.y])
				cylinder(d=switch_hole_d+switch_holes_extra, h = switch_dim.z);
			translate([switch_holes.x, switch_dim.y-switch_holes.y])
				cylinder(d=switch_hole_d+switch_holes_extra, h = switch_dim.z);
		}
		translate([switch_holes.x, switch_holes.y, -.5])
			cylinder(d=switch_hole_d, h = switch_dim.z+1);
		
		translate([switch_holes.x, switch_dim.y-switch_holes.y, -.5])
			cylinder(d=switch_hole_d, h = switch_dim.z+1);
	}
}


module holder(extra_distance = 0)
{
	difference()
	{
		mums_dim = [hole_to_wall+extra_distance+hole_d/2,hole_distance+hole_d, thickness+switch_dim.z+2];
		translate([hole_to_wall/2,hole_distance-mums_dim.y/2,0])
		{
			cube(mums_dim);
		}
		
		translate([hole_to_wall, hole_distance/2, -.5])
			cylinder(d = screw_d, h = mums_dim.z+1);
		
		translate([hole_to_wall, hole_distance*1.5, -.5])
			cylinder(d = screw_d, h = mums_dim.z+1);

		translate([right - switch_dim.x+extra_distance,hole_distance - switch_dim.y/2, thickness])
		{
			hull() switch();
			pins_dim = [switch_dim.x+extra_distance, switch_dim.y-2*0.5, switch_dim.z/2+1];
			translate([-pins_dim.x, switch_dim.y/pins_dim.y/2])
				cube(pins_dim);
		}
		#plate(extra_distance);
	}
}

holder(1);
mirror([1,0,0]) holder(3);