use <../positioning.scad>

function grid_2d_hole_dims(w, h, nx, ny, spacing) = [
    (w - (spacing * (nx+1))) / nx,
    (h - (spacing * (ny+1))) / ny
];

/// Generate a grid with rectangular holes
/// Hole size will be determined based on width, height and spacing
/// Use function grid_2d_hole_dims to check hole dims
///
/// # Arguments
/// w, h -- Dimensions of the outer rectangle
/// nx, ny -- Number of holes on x and y axis
/// spacing -- Spacing between the holes
/// center -- Center the grid on 0,0
module grid_2d(w, h, nx, ny, spacing, center=false) {
    assert(spacing * (nx+1) < w, "Holes don't fit in x");
    assert(spacing * (ny+1) < h, "Holes don't fit in y");

    spread_fill_xy(w, h, nx, ny, padx=spacing, center=center, stamp=true)
    square(grid_2d_hole_dims(w, h, nx, ny, spacing));
}

/// A square with rounded corner.
/// Each corner may have a different radius.
///
/// * Use the `corner_rad` argument to set a corner radius for all corners
/// * The `corner_override` argument may be used to set custom radii for the corners
///   The order in the array is: bottom left, bottom right, top right, top left
///   There are two special values: -1 to use the `corner_rad` value, 0 to use a square corner
module rounded_square(size=[10,10], corner_rad=1, corner_override=[-1,-1,-1,-1], center=false) {
    if(center) {
        translate(-size/2)
        rounded_square(size=size, corner_rad=corner_rad, corner_override=corner_override, center=false);
    } else {
        corner_lookup = [[0,0], [1,0], [1,1], [0,1]];
        hull()
        for(i=[0:3]) {
            if(corner_override[i] != 0) {
                f = corner_lookup[i];
                rad = corner_override[i]==-1 ? corner_rad : corner_override[i];
                translate([f[0] * (size[0]-2*rad), f[1] * (size[1]-2*rad)])
                translate([rad,rad])
                circle(r=rad);
            } else {
                f = corner_lookup[i];
                translate([f[0] * (size[0]-1), f[1] * (size[1]-1)])
                square([1,1]);
            }
        }
    }
}

/// A hollow rectangle with the given edge thickness.
/// * The inner parameter controls wether size includes the edge or the edge is to be outside of the size.
///   True = total size will be size+2*thickness
module hollow_rect(size=[10,10], thickness=1, inner=true, center=false) {
    if(inner) {
        hollow_rect(size=size + 2*[thickness, thickness], thickness=thickness, inner=false, center=center);
    } else {
        if(center) {
            translate(-size/2)
            hollow_rect(size=size, thickness=thickness, inner=false, center=false);
        } else {
            difference() {
                square(size=size);
                translate([thickness, thickness])
                square(size=size-2*[thickness, thickness]);
            }
        }
    }
}

module ring(r=10, thickness=1, inner=true, center=true) {
  if(inner) {
    ring(r=r+thickness, thickness=thickness, inner=false, center=center);
  } else {
    translate(center? [0,0] : [r,r])
    difference() {
      circle(r=r);
      circle(r=r-thickness);
    }
  }
}

// Grid demo
grid_2d(100,100, 10, 10, 3);

// Spread Demo
translate([210,0])
spread_fill_xy(100, 100, 10, 10, padx=10, center=true, stamp=true) circle(r=4);
