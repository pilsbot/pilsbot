pilsbot_w = 1000;
pilsbot_l = 2500;
pilsbot_h =  500;


motor_d = 150;
motor_l = 300;

getriebe_w = 100;
getriebe_h = 150;
getriebe_l = 200;

rad_d = 300;
rad_w = 50;
rad_freiheit = 20;
entfernung_achse_kiste = rad_d/2 + rad_freiheit;

achse_d = 30;
achse_l = pilsbot_w - 2*rad_w - 10;

achse_vorne		= 5*pilsbot_l/6;
achse_hinten	=   pilsbot_l/6;


servo_h = 80;
servo_d = 60;
servo_axle_d = 10;
servo_material_thickness = 10;

module motor()
{
	minus_angle	= 40;
	plus_angle	= 20;
	
	rotate([0, 90, 0])
		cylinder(d = motor_d, h = motor_l, $fn = $preview ? 20 : 100);
	color("red")
		rotate([plus_angle, 0, 0]) translate([motor_l - 10, 0, motor_d/2])
			cylinder(d = 10, h = 15);
	color("black")
		rotate([minus_angle, 0, 0]) translate([motor_l - 10, 0, motor_d/2])
			cylinder(d = 10, h = 15);
}

module getriebe()
{
	achse_abstand = 10;
	color("grey")
		cube([getriebe_l, getriebe_w, getriebe_h]);
	color("brown") 
		translate([getriebe_w/2, -achse_abstand, getriebe_h/2]) rotate([-90, 0, 0])
		cylinder(d = achse_d+2, h = getriebe_w + 2*achse_abstand);
}


module rad()
{
	color("#503010")
	rotate([90, 0, 0])
		cylinder(d = rad_d, h = rad_w, $fn = $preview ? 20 : 100);
}

module achse(l = achse_l)
{
	color("grey")
	rotate([90, 0, 0])
		cylinder(h = l, d = achse_d, center=true);
}

module achsenhalter()
{
	width = achse_d+10;
	thickness = 9;
	translate([-width/2, -thickness, 0])
		cube([width, thickness, entfernung_achse_kiste]);
	rotate([90, 0, 0])
		cylinder(h=thickness, d = width);
	color("red")
	rotate([90, 0, 0])
		cylinder(h=thickness+1, d = width-4);
	
}

module antrieb()
{
	//Bezugssystem: Achse
	
	translate([-getriebe_w/2, -getriebe_w/2, -getriebe_h/2])
	union()
	{
		getriebe();
		translate([getriebe_l, getriebe_w/2, getriebe_h/2])
			motor();
		//halterung
		color("#a0a0a0")
		translate([5, 5, getriebe_h])
			cube([getriebe_l-10, getriebe_w-10, entfernung_achse_kiste - getriebe_h/2]);
	}
	
	achse();
	translate([0, -achse_l/2, 0])
		rad();
	rotate([180, 0, 0]) translate([0, -achse_l/2, 0])
		rad();
	//links
	translate([0, achse_l/2 - 50, 0])
		achsenhalter();
	//rechts
	translate([0, -(achse_l/2 - 50), 0])
		achsenhalter();
}

module hackermannRing(laufbahn = 50)
{
	innen_d	= servo_axle_d;
	staerke	= 10;
	color("#505050")
	translate([0, -(staerke+innen_d/2), -staerke/2])
		difference()
		{
			union()
			{
				cube([laufbahn+staerke, 2*staerke+innen_d, staerke]);
				translate([laufbahn+staerke, staerke+innen_d/2, 0])
					cylinder(d = 2*staerke+innen_d, h = staerke);
			}
			translate([staerke, staerke, -1])
				cube([laufbahn, innen_d, staerke+2]);
		}
}

module servoHackermann(excenter_range)
{
	holding_plate_w = 3 * servo_material_thickness;
	
	//servo body
	color("#40B0B0")
	cylinder(d = servo_d, h = servo_h);
	
	translate([0, 0, servo_h])
		union()
		{
			//axle
			cylinder(d = servo_axle_d, h = 2*servo_material_thickness+1);
			//excenter
			translate([0, 0, 10])
				union()
				{
					//holding plate
					color("#405030")
						union()
						{
							translate([0, -holding_plate_w/2, 0])
								cube([excenter_range, holding_plate_w, servo_material_thickness]);
							cylinder(d = holding_plate_w, h = servo_material_thickness);
							translate([excenter_range, 0, 0])
								cylinder(d = holding_plate_w, h = servo_material_thickness);
							
						}
					translate([excenter_range, 0, servo_material_thickness])
						//Pin
						color("#405060") cylinder(d = 10, h = servo_material_thickness*1.5);
				}
		}
	
}

module lenkungHackermann()
{
	entfernung = 200;
	wheelbase = achse_vorne-achse_hinten;
	achse_lenkung_l = ((wheelbase-entfernung) / wheelbase) * achse_l;
	quer_lenkung_hinterrad = sqrt((achse_l/2)*(achse_l/2) + wheelbase * wheelbase);
	quer_lenkung_l = (entfernung / wheelbase) * quer_lenkung_hinterrad;
	
	//somehow calculate this
	steering_travel = 140;
	
	achse();
	//rechter Reifen
	translate([0, -achse_l/2, 0])
		rad();
	//linker Reifen
	rotate([180, 0, 0]) translate([0, -achse_l/2, 0])
		rad();
	
	//steuerungsstange
	translate([-entfernung, 0, 0])
		union()
		{
			achse(achse_lenkung_l);
			translate([achse_d/2, 0, 0])
			union()
			{
				hackermannRing(steering_travel/2);
				//20 is 2*staerke ring
				translate([20 + steering_travel/3, 0, servo_h+2.75*servo_material_thickness])
				{
					rotate([0, 180, 0])
						servoHackermann(steering_travel/3);
					//servoHalterung
					color("#404040")
					cylinder(d1 = servo_d, d2 = servo_d * 1.5, h = entfernung_achse_kiste - (servo_h+2.75*servo_material_thickness));
				}
			}
		}
	
	
	//links
	translate([0, achse_l/2, 0])
		rotate([0, 0, 90 + atan((achse_l/2) / wheelbase)])
			translate([0, quer_lenkung_l/2, 0])
				achse(quer_lenkung_l);
	//rechts
	mirror([0, 1, 0]) translate([0, achse_l/2, 0])
		rotate([0, 0, 90 + atan((achse_l/2) / wheelbase)])
			translate([0, quer_lenkung_l/2, 0])
				achse(quer_lenkung_l);
				
	//halter links
	translate([0, achse_l/2 - 50, 0])
		achsenhalter();
	//halter rechts
	translate([0, -(achse_l/2 - 50), 0])
		achsenhalter();
}

module sackermannAufhaengung()
{
	achslaenge	= 20;
	gelenk		= 50;
	rad();
	translate([0, achslaenge/2, 0])
		achse(achslaenge);
	//unten
	color("green")
	translate([-gelenk/2, achslaenge, -gelenk/2])
		cube(gelenk);
	color("#30C090")
	translate([0, achslaenge+gelenk/2, gelenk/2])
		cylinder(d1=gelenk, d2=gelenk*1.4, h = entfernung_achse_kiste - gelenk/2);
}

module lenkungSackermann()
{
	
	
	translate([0, -achse_l/2, 0])
		sackermannAufhaengung();

	mirror([0, 1, 0]) translate([0, -achse_l/2, 0])
		sackermannAufhaengung();

}

module battery()
{
	battery_w = 200;
	battery_h = 200;
	battery_l = 400;
	
	color("#A0A0A0")
		cube([battery_w, battery_l, battery_h]);
	//plus
	color("red")
	translate([battery_w/5, 40, battery_h])
		cylinder(d1 = 20, d2=18, h= 20);
	//minus
	color("black")
	translate([4*battery_w/5, 40, battery_h])
		cylinder(d1 = 20, d2=18, h= 20);
}

module hauptbox()
{
//	pilsbot_w = 1000;
//	pilsbot_l = 2500;
//	pilsbot_h =  500;
	wandstaerke = 10;
	color("#A0A000")
	difference()
	{
		cube([pilsbot_l, pilsbot_w, pilsbot_h]);
		translate([wandstaerke, wandstaerke, wandstaerke])
			cube([pilsbot_l-wandstaerke*2, pilsbot_w-wandstaerke*2, pilsbot_h]);
	}
	translate([0, wandstaerke, wandstaerke])
		battery();
}


hauptbox();

translate([achse_hinten, pilsbot_w/2, -rad_d/2 - rad_freiheit])
	antrieb();

translate([achse_vorne, pilsbot_w/2, -rad_d/2 - rad_freiheit])
	lenkungHackermann();
