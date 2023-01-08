box = [60, 24];
roundness = 2;
thickness = 2;
feet = 7;
screw_d = 2.5;

/*
difference(){
	offset(r=roundness, $fn = 100) {
		square(box+[(thickness-roundness)*2, thickness-roundness]);
	}
	translate([thickness,0])
		offset(r=roundness, $fn = 100)
		{
			square(box-[roundness*2,roundness]);
		}
	translate([-box.x/2, -10])
		square([box.x*2, 10]);
}
*/
difference(){
	linear_extrude(feet){
		offset(r=-roundness, $fn = 100) offset(r=roundness, $fn = 100)
			difference(){
				union(){
					square(box+[thickness*2, thickness]);
					translate([-feet, 0])
						square([box.x + thickness*2 + feet*2, thickness]);
				}
				translate([thickness,0])
					square(box);
			}
	}
	#translate([-feet/2, -1, feet/2]) rotate([-90,0,0])
		cylinder(d=screw_d, h = feet,$fn = 100);
	#translate([box.x+feet, -1, feet/2]) rotate([-90,0,0])
		cylinder(d=screw_d, h = feet,$fn = 100);
}