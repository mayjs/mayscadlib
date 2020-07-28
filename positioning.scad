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

module and_mirror(v) {
    children();
    mirror(v) children();
}

module and_rotate(a, v) {
    children();
    rotate(a, v) children();
}

module and_rotate_mirror(ra, mv) {
    children();
    mirror(mv) rotate(ra) children();
}

/// Places all children at all positions given in the positions vector.
/// This is meant to be used in conjunction with points functions like rect_corners.
///
/// # Examples
/// ```
/// place(rect_corners([10,10]) cylinder(r=10, h=5);
/// ```
module place(positions) {
    for(p=positions) {
        translate(p) children();
    }
}

/// Internal helper to center a set of coordinates using a bounding box
function center_bb(vals, bb) = [for(v=vals)  v - bb/2];

/// Translates a list of points using the given vector
function translate_points(trans, points) = [for (p=points) p+trans];

/// Returns the corner points of a rectangle with the given `size`.
/// If `center` is set to true, the rectangle will be centered on (0,0)
function rect_corners(size, center=false) = center ?
                                            center_bb(rect_corners(size, center=false), size) :
                                            [for (i=[0:1], j=[0:1]) [size[0]*i, size[1]*j, 0]];

/// Returns the coordinates for an equilateral triangle.
/// This may be usefull instead of a generalized n-gon function because the
/// width is not the radius we would use there.
function equilateral_triangle(width, center=false) = isosceles_triangle(width, sqrt(3)/2*width, center=center);

function isosceles_triangle(width, height, center=false) = center ?
                                                           center_bb(isosceles_triangle(width, height, center=false), [width,height]):
                                                            [[0,0], [width,0], [width/2, height]];
                                                           
