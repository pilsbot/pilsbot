$fa = $preview ? 8 : 4;
$fs = $preview ? 3 : 0.25;

d_aussen = 25 +1;
l = 30;
thickness = 5;

difference()
{
	cylinder(d = d_aussen+2*thickness, h = l);
	cylinder(d = d_aussen, h = l+1);
}