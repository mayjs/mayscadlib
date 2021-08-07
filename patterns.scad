use <positioning.scad>;

module hex_grid(grid_size, hex_rad, pad, negative=true) {
  if(negative) {
    difference() {
      square(grid_size);
      hex_grid(grid_size, hex_rad, pad, negative=false);
    }
  } else {
    nx = ceil(grid_size[0] / (hex_rad*2 + pad)) + 1;
    ny = ceil(grid_size[1] / (hex_rad*2 + pad/2)) + 1;
    sy = sqrt(3) * (hex_rad + pad/2);
    intersection() {
      make_grid(nx, ny, hex_rad*2 + pad, sy=sy, shift=hex_rad+pad/2, shift_mod=hex_rad*2+pad) {
        rotate(360/12)
        circle(hex_rad, $fn=6);
      }
      square(grid_size);
    }
  }
}
