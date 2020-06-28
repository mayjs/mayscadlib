/// Dimension agnostic positioning functions

/// Positions all children at offset and -offset.
module plus_minus(offset) {
    translate(offset) children();
    translate(-offset) children();
}

/// Spread objects across a rectangle in the xy plane
///
/// # Arguments
/// w, h -- Dimensions of the plane
/// nx, ny -- Number of objects in x and y direction
/// padx, pady -- padding in x and y direction, you can also only set padx, pady will default to it
///               Padding is relative to the childrens 0,0!
/// center -- if true, the w,h plane will be centered on 0,0
/// stamp -- Inverse the operation, i.e. use the children as a stamp to cut holes in the w,h rectangle
///
/// # Children
/// All children will be spread, you'll want to center them in most cases if you want to use padding
module spread_fill_xy(w, h, nx, ny, padx=0, pady=undef, center=false, stamp=false) {
    if(center) {
        translate([-w/2, -h/2, 0])
        spread_fill_xy(w, h, nx, ny, padx=padx, pady=pady, center=false, stamp=stamp) children();
    } else {
        if(stamp) {
            difference() {
                square([w,h]);
                spread_fill_xy(w=w, h=h, nx=nx, ny=ny, padx=padx, pady=pady, center=center, stamp=false) children();
            }
        } else {
            pady = is_undef(pady) ? padx : pady;

            stepx = (w-padx)/nx;
            stepy = (h-pady)/ny;

            translate([padx, pady, 0])
            for(ix = [0:nx-1], iy=[0:ny-1]) {
                translate([ix*stepx, iy*stepy, 0])
                children();
            }
        }
    }
}

/// A simple helper module, translates on the z axis
module lift(h) {
    translate([0,0,h]) children();
}
