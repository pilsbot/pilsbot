pilsbot_w = 1000;
pilsbot_l = 2500;
pilsbot_h =  500;

motor_d = 150;
motor_l = 300;

getriebe_w = 100;
getriebe_h = 150;
getriebe_l = 200;

rad_d = 275;
rad_w = 50;
rad_freiheit = 20;
entfernung_achse_kiste = rad_d/2 + rad_freiheit;

achse_d = 30;
achse_l = pilsbot_w - 2*rad_w - 10;

achse_vorne		= 5*pilsbot_l/6;
achse_hinten	=   pilsbot_l/6;

//sackermann
//hackermann_rotationsservo
//hackermann_linearservo
steering_type = "hackermann_linearservo";
include <steering.scad>

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
	translate([wandstaerke, wandstaerke, wandstaerke])
		battery();
}


hauptbox();

translate([achse_hinten, pilsbot_w/2, -rad_d/2 - rad_freiheit])
	antrieb();

translate([achse_vorne, pilsbot_w/2, -rad_d/2 - rad_freiheit])
	lenkung();
