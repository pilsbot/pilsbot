chassis_tube_d = 26;	//TODO: Check
diff = 30;				//TODO: Check
breite = 23;
sdriver_clearance = 10;

$fn = $preview ? 80 : 120;

difference(){
	union(){
		translate([0,0,diff])
			rotate([-90, 0,0]) difference(){
				cylinder(r=breite, h=breite);
				translate([-breite, 0,-.5])
					cube([breite*2, breite, breite+1]);
				
				//the tube
				translate([-chassis_tube_d/2,0,-.5])
					cylinder(d=chassis_tube_d, h=breite+1);
			}
		cube([breite, breite, diff]);
	}
	//the screw hole
	translate([breite/2, breite/2,0]){
		translate([0,0, 15])
			cylinder(d1=sdriver_clearance-1, d2=sdriver_clearance+3, h=diff+10);
		cylinder(d=4.5, h=100);
	}
}