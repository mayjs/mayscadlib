/* Bezier function taken from https://openhome.cc/eGossip/OpenSCAD/BezierCurve.html */

function bezier_coordinate(t, n0, n1, n2, n3) = 
    n0 * pow((1 - t), 3) + 3 * n1 * t * pow((1 - t), 2) + 
        3 * n2 * pow(t, 2) * (1 - t) + n3 * pow(t, 3);

function bezier_point(t, p0, p1, p2, p3) = 
    [
        bezier_coordinate(t, p0[0], p1[0], p2[0], p3[0]),
        bezier_coordinate(t, p0[1], p1[1], p2[1], p3[1]),
        /*bezier_coordinate(t, p0[2], p1[2], p2[2], p3[2])*/
    ];


function bezier_curve(t_step, p0, p1, p2, p3) = 
    [for(t = [0: t_step: 1 + t_step]) bezier_point(t, p0, p1, p2, p3)];
