d = 20;
h = 28 - d/4;
w = 110 - d/4;

screw_d = 2.3;
ws = 1.5;

module plate()
{
	difference()
	{
		linear_extrude(ws)
		{
			difference()
			{
				hull()
				{
					circle(d = h);
					translate([w - h, 0])
						circle(d = h);
				}
				// "thread"
				circle(d = screw_d, $fn = $preview ? 50 : 100);
				// hole
				translate([w - h, 0])
					circle(d = screw_d + 1, $fn = $preview ? 50 : 100);
			}
		}
		translate([(w - h)/2, 0,3*ws/4])
		linear_extrude(ws)
			text("NEIN", halign="center", valign="center");
	}
}

module rohrteil()
{
	$fn = $preview ? 50 : 150;
	intersection()
	{
		difference()
		{
			circle(d = d);
			circle(d = d - 2*ws);
		}
		
		translate([-d, 0])
			square([d, d]);
	}
}

module kranz()
{
	rotate([0,0,180])
		intersection()
		{
			rotate_extrude($fn = $preview ? 50 : 150)
			{
				translate([(d/2) + h/2 - ws, 0])
				{
					rohrteil();
				}
			}
			
			translate([0, -h, 0])
				cube([h, 2 * h, d]);
		}
}

module rohrseite()
{
	translate([0, -h/2 + ws, 0])
		translate([0, -d/2, 0])
			rotate([0, 90, 0])
				linear_extrude(w - h)
					rotate([0, 0, 0])
						rohrteil();
}

plate();

rohrseite();
mirror([0,1,0])rohrseite();

kranz();

translate([w - d - 2*ws, 0, 0])
	rotate([0,0,180])
		kranz();
