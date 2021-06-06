module line_segment(p1, p2, width=1) {
  hull() {
    translate(p1)
    circle(r=width/2);
    translate(p2)
    circle(r=width/2);
  }
}

module polyline(points, width) {
  for(i=[1:len(points)-1]) {
    line_segment(points[i-1], points[i], width);
  }
}
