tube_d = 30;
breite = 15;
ws = 5;

sdriver_clearance = 13;
absatz_h = tube_d/3;
screw_d = 4;
screw_konus = 3;

holder_d = 2*tube_d+ws;
extra_base = sdriver_clearance * 1.5;


holder_width = holder_d + extra_base * 2;
$fn = $preview ? 80 : 200;

module holder() {
	rotate([90, 0, 0]) linear_extrude(breite, convexity = 2) difference(){
		
		resize([holder_width, holder_d])
			circle(d = holder_d);
		
		extra_w = 1;
		// round slot for tube
		translate([0,tube_d/2-extra_w/2]) {
			hull(){
				circle(d = tube_d+extra_w);
				translate([tube_d*2, 0])
					circle(d = tube_d+extra_w);
			}
		}
		
		// cut lower half
		weg = holder_width + 1;
		translate([-weg /2, -weg ])
			square([weg , weg]);
	}
}


module screw_hole()
{
	translate([0,0, absatz_h])
		cylinder(d1=sdriver_clearance-1, d2=sdriver_clearance+2, h=holder_d/2-absatz_h);
	translate([0,0, absatz_h-screw_konus])
		cylinder(d1=screw_d, d2=screw_d+screw_konus, h=screw_konus);
	cylinder(d=screw_d, h=holder_d/2);
}


difference(){
	holder();
	
	//the screw hole
	translate([0, -breite/2, 0])
	{
		translate([-(holder_d-breite)/2, 0,0])
			screw_hole();
		translate([-(holder_width-breite)/2, 0,0])
			screw_hole();
	}

}
