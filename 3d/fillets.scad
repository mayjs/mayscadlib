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

$fn = 100;
fillet_ring(10,2, angle=180, slope=5);


