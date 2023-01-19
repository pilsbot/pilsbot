oak_d_dim = [91, 17.5, 28];
oak_d_screws = [75, 18.5]; // x is distance between screws
oak_d_screw_d = 4;

adapter_height = 90;

wall_clearance = 35;
stab_dim = [25+.5, 14];

wood_screw_d = 3;
wood_screw_l = 10;
wood_screw_head = wood_screw_d/2;


ws = 2;
feet_l = wood_screw_d*3;


inner_distance = max(oak_d_screws.x + ws, oak_d_dim.x);
width_of_all = inner_distance + 2*feet_l + 2*ws;
height_of_holder = oak_d_dim.z;

module screw() {
	$fn = $preview ? 10 : 40;
	translate([0,0,-wood_screw_l])
		cylinder(h = wood_screw_l, d = wood_screw_d);
	cylinder(h = wood_screw_head, d1 = wood_screw_d, d2 = wood_screw_d + 2*wood_screw_head);
}

module oak_d(cut_screws = false) {
	$fn = $preview ? 10 : 50;
	difference() {
		cube(oak_d_dim);
		translate([(oak_d_dim.x-oak_d_screws.x)/2, -.5 , oak_d_screws.y]) {
			rotate([-90, 0, 0]) cylinder(d = oak_d_screw_d, h = oak_d_dim.y/2);
			translate([oak_d_screws.x, 0, 0])
				rotate([-90, 0, 0]) cylinder(d = oak_d_screw_d, h = oak_d_dim.y/2);
		}
	}
	
	if(cut_screws) {
		translate([(oak_d_dim.x-oak_d_screws.x)/2, .5 , oak_d_screws.y]) {
			rotate([90, 0, 0]) cylinder(d = oak_d_screw_d, h = 100);
			translate([oak_d_screws.x, 0, 0])
				rotate([90, 0, 0]) cylinder(d = oak_d_screw_d, h = 100);
		}
	}
	
}

module oak_d_trans(cut_screws = false) {
	translate([feet_l+ws, ws + wall_clearance, 0])
		oak_d(cut_screws);
}

module base(h = height_of_holder) {
	difference() {
		// base
		linear_extrude(h, convexity = 2) {
			difference() {
				union() {
					square([width_of_all, ws]);
					translate([feet_l, 0]) {
						// arms
						square([inner_distance+2*ws, ws + wall_clearance]);
					}
				}
				translate([feet_l+ws, 0]) {
					square([inner_distance, wall_clearance]);
				}	
			}
		}
		oak_d_trans(cut_screws = true);
		
		for(x = [feet_l/2, width_of_all - feet_l/2]) {
			for(z = [feet_l/2, h-feet_l/2]) {
				translate([x, ws-wood_screw_head/2, z]) rotate([-90, 0, 0]) screw();
			}
		}
	}
}

translate([0,0,height_of_holder-1]) {
	top = adapter_height-height_of_holder;
	width_to_narrowing = (width_of_all-stab_dim.x)/2;
	
	bit_h = 1;
	difference() {
		union() {
			hull(){
				translate([width_to_narrowing-ws, 0, top])
					cube([stab_dim.x+2*ws, stab_dim.y+ws, bit_h]);
				translate([feet_l, 0,0]) {
					// arms
					cube([inner_distance+2*ws, ws + wall_clearance,bit_h]);
				}
			}
			// Fins
			hull() {
				translate([(width_to_narrowing-ws) - feet_l, 0, adapter_height-height_of_holder])
					cube([stab_dim.x+2*ws+2*feet_l, ws, bit_h]);
				// basically just copied from base... would be better if re-using this
				cube([inner_distance+2*ws+2*feet_l, ws, bit_h]);
			}
		}
		
		hull(){
			translate([width_to_narrowing, 0, adapter_height-height_of_holder])
				cube([stab_dim.x, stab_dim.y, bit_h]);
			translate([feet_l+ws, -.5, 0]) {
				cube([inner_distance, wall_clearance+.5, bit_h]);
			}
		}
		
		// screws
		num_steps = 3;
		step_width = top/num_steps;
		width = width_to_narrowing-feet_l-ws;
		
		for(z = [top - feet_l/2 : -step_width : 0])
		translate([0,ws-wood_screw_head/2,z]) {
			// left
			translate([width/top * z + feet_l/2, 0, 0])
				rotate([-90, 0, 0]) screw();
			// right
			translate([width_of_all - (width/top * z + feet_l/2), 0, 0])
				rotate([-90, 0, 0]) screw();
		}
	}
}

base();
%oak_d_trans();