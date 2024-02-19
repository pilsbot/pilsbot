id = 22 + .3;
ws = 1;
diff = 1/2;
h = 50;
baseplate_d =  2 * id;
baseplate_ws = 2;

num_bobbls = 7;

base_d = (id-ws);
bobbl_d = (id/5);

$fn = $preview ? 50 : 100;

module main()
{
cylinder(d1 = base_d, d2 = base_d - 2*diff, h = h);

for(r = [0 : 360 / num_bobbls : 350])
    rotate([0, 0, r])
        translate([(base_d-bobbl_d)/2+ws, 0, 0])
            rotate([0, atan2(h, diff)-90, 0])
                cylinder(d = bobbl_d, h = h);
}


module ding()
{
    translate([0,0,.1])
        main();

    cylinder(d = baseplate_d, h = baseplate_ws, $fn = 222);
}


difference()
{
    ding();

    linear_extrude(.3)
        rotate([180, 0, 0])
            text("PB", size = 20, halign="center", valign = "center");
}