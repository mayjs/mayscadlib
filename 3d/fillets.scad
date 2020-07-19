use <mayscadlib/positioning.scad>

module _profile_2d(radius, inner=false) {
    if(inner) {
        //translate([radius,0,0])
        mirror([1,0,0])
        _profile_2d(radius, inner=false);
    } else {
        translate([radius,radius])
        rotate([0,0,180])
        difference() {
            square([radius,radius]);
            circle(r=radius);
        }
    }
}

module fillet_ring(ring_rad, fillet_rad, angle=360, inner=false, slope=0, slope_slices_per_deg=5) {
    if(slope > 0) {
        rotate([0,0,slope])
        fillet_ring(ring_rad, fillet_rad, angle=angle-2*slope, inner=inner, slope=0);

        slope_slices = slope_slices_per_deg*slope;
        and_rotate_mirror([0,0,180], [0,1,0])
        for(i=[1:slope_slices]) {
            rotate([0,0,(i-1)*(slope/slope_slices)])
            fillet_ring(ring_rad, i*fillet_rad/(slope_slices+1), angle=slope/slope_slices, inner=inner, slope=0);
        }
    } else {
        rotate_extrude(angle=angle) translate([ring_rad,0]) _profile_2d(fillet_rad, inner=inner);
    }
}

module fillet_line(line_length, fillet_rad, slope=0, slope_slices_per_mm=10, center=false, negative=false) {
    if(!center) {
        translate([0,line_length/2,0])
        fillet_line(line_length, fillet_rad, slope=slope, slope_slices_per_mm=slope_slices_per_mm, center=true, negative=negative);
    } else {
        if(negative) {
            difference() {
                translate([0, -line_length/2, 0])
                cube([fillet_rad, line_length, fillet_rad]);
                fillet_line(line_length, fillet_rad, slope=slope, slope_slices_per_mm=slope_slices_per_mm, center=true, negative=false);
            }
        } else {
            if(slope != 0) {
                fillet_line(line_length-2*slope, fillet_rad, slope=0, center=true);
                
                slope_slices = slope_slices_per_mm*slope;
                and_mirror([0,1,0])
                for(i=[1:slope_slices]) {
                    translate([0, line_length/2 - slope + (slope_slices-i)*(slope/slope_slices), 0])
                    fillet_line(slope/slope_slices, i*fillet_rad/(slope_slices+1), slope=0, center=false);
                }
            } else {
                translate([0,line_length/2,0])
                rotate([90,0,0])
                linear_extrude(height=line_length)
                _profile_2d(fillet_rad);
            }
        }
    }
}

$fn = 100;
fillet_ring(10,2, angle=180, slope=5);

translate([15,0,0])
fillet_line(50, 5);
