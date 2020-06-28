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

// Grid demo
grid_2d(100,100, 10, 10, 3);

// Spread Demo
translate([210,0])
spread_fill_xy(100, 100, 10, 10, padx=10, center=true, stamp=true) circle(r=4);
