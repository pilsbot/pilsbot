tube_d = 30;
breite = 15;
ws = 5;

sdriver_clearance = 13;
absatz_h = tube_d/3;
screw_d = 4;
screw_konus = 3;


holder_d = 2*tube_d+ws;
$fn = $preview ? 80 : 200;

module holder() {
	rotate([90, 0, 0]) linear_extrude(breite) difference(){
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
		translate([-(holder_d+1)/2, -(holder_d+1)])
			square([holder_d+1, holder_d+1,]);
	}
}



difference(){
	holder();
	
	//the screw hole
	translate([-(holder_d-breite)/2, -breite/2,0]){
		translate([0,0, absatz_h])
			cylinder(d1=sdriver_clearance-1, d2=sdriver_clearance+3, h=holder_d/2-absatz_h);
		translate([0,0, absatz_h-screw_konus])
			cylinder(d1=screw_d, d2=screw_d+screw_konus, h=screw_konus);
		cylinder(d=screw_d, h=100);
	}
}
