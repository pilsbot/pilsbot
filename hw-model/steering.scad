servo_h = 80;
servo_d = 60;
servo_axle_d = 10;
servo_material_thickness = 10;

lservo_d = 40;
lservo_l = 420;
lservo_body_l = lservo_l - 50;


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

module ring(in_d, out_d, h)
{
	difference()
	{
		cylinder(d=out_d, h = h, center = true);
		cylinder(d=in_d, h = h+2, center = true);
	}
}

module linearServoHackerman(excenter_range)
{
	mount_h = lservo_d-5;
	motor_l = 140;
	color("#809080")
	{
	translate ([0, 0, mount_h/2]) union()
	{
		difference()
		{
			rotate([0, 90, 0])
			{
				cylinder(d = lservo_d, h = lservo_body_l);
				cylinder(d = lservo_d/3, h = lservo_l);
				translate([0, lservo_d, 0]) 
					cylinder(d = lservo_d, h = motor_l);
			}
			hull() scale([1,1,2]) ring(in_d = 10, out_d = lservo_d-5, h = mount_h);
			hull() translate([lservo_l, 0, 0]) ring(in_d = 10, out_d = mount_h, h = lservo_d-5);
		}
		ring(in_d = 10, out_d = lservo_d-5, h = mount_h);
		translate([lservo_l, 0, 0])
			ring(in_d = 10, out_d = lservo_d-5, h = mount_h);
		}
		translate([motor_l-50, 0, -(lservo_d - mount_h)/2])
			cube([50, lservo_d, lservo_d]);
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
			if(steering_type == "hackermann_rotationsservo")
			{
				translate([achse_d/2, 0, 0])
				union()
				{
					hackermannRing(steering_travel/2);
					//20 is 2*staerke ring
					translate([20 + steering_travel/3, 0, servo_h+2.75*servo_material_thickness])
					{
						rotate([0, 180, 0])
							!servoHackermann(steering_travel/3);
						//servoHalterung
						color("#404040")
						cylinder(d1 = servo_d, d2 = servo_d * 1.5, h = entfernung_achse_kiste - (servo_h+2.75*servo_material_thickness));
					}
				}
			}else if(steering_type == "hackermann_linearservo"){

				translate([0, lservo_l/2, entfernung_achse_kiste/2])
				{
				//upper holder
				translate([0, 0, -5])
					cylinder(d = servo_material_thickness, h = entfernung_achse_kiste/2 + 5);
				//servo
				rotate([0, 0, -90])
					linearServoHackerman();
				}
				//lower holder
				translate([0, -lservo_l/2, 0])
					cylinder(d = servo_material_thickness, h = entfernung_achse_kiste/2 + lservo_d);
			}else{
				echo("Invalid steering type");
				assert(false);
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

module lenkung()
{
	if(steering_type == "sackermann")
		lenkungSackermann();
	else
		lenkungHackermann();
}

