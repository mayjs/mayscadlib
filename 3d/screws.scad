use <../positioning.scad>

default_play=0.2;

// TODO: Could be detect if children() is 3D-geometry?
// We could rotate-extrude 2d shapes and keep 3d shapes as is

/// A screw without threads, meant to create screwholes in parts.
/// This is an internal utility function that requires a 2d shape that will
/// be rotate-extruded to create the screw head.
///
/// # Parameters
/// * screw_dia: Diameter of the screw threads
/// * head_dia: Max diameter of the screw head
/// * head_h: The height of the screw head
/// * screw_length: The length of the screw including the head
/// * align_top: If true, the top of the screw will be aligned with 0,0
/// * play: The additional play to add to the screw (as radius)
module screw_with_head_shape(screw_dia, head_dia, head_h, screw_length, align_top=true, play=default_play, hole_length=0) {
    screw_only_h = screw_length - head_h;
    module shape() {
        square(size=[screw_dia/2+play, screw_only_h]);
        translate([0,screw_only_h])
        children();
    }
    if(align_top) {
        lift(-screw_length)
        screw_with_head_shape(screw_dia, head_dia, head_h, screw_length, align_top=false, play=play, hole_length=hole_length) children();
    } else {
        if(hole_length == 0) {
            rotate_extrude() shape() children();
        } else {
            straight_length = hole_length-head_dia;
            translate([0, straight_length/2,0])
            rotate_extrude(angle=180) shape();
            translate([0, -straight_length/2,0])
            rotate([0,0,180])
            rotate_extrude(angle=180) shape();

            rotate([90,0,0])
            linear_extrude(height=straight_length, center=true)
            and_mirror([1,0,0]) 
            shape() children();
        }
    } 
}

/// A countersunk screw without threads, meant to create screwholes in parts.
///
/// # Parameters
/// * screw_dia: Diameter of the screw threads
/// * head_dia: Max diameter of the screw head
/// * head_h: The height of the screw head
/// * screw_length: The length of the screw including the head
/// * align_top: If true, the top of the screw will be aligned with 0,0
/// * head_clearance: Can be used to add addditional clearance to the screws head,
///     useful if the screw will not be placed flush with the parts border
/// * play: The additional play to add to the screw (as radius)
module counter_sunk_screw(screw_dia, head_dia, head_h, screw_length, align_top=true, head_clearance=0, play=default_play, hole_length=0) {
    screw_with_head_shape(screw_dia, head_dia, head_h, screw_length, align_top=align_top, play=play, hole_length=hole_length)
    polygon([
                [0,0],
                [screw_dia/2+play,0],
                [head_dia/2+play, head_h],
                [head_dia/2+play, head_h+head_clearance],
                [0, head_h+head_clearance],
                [0, head_h],
    ]);
}

/// A pan head screw without threads, meant to create screwholes in parts.
///
/// # Parameters
/// * screw_dia: Diameter of the screw threads
/// * head_dia: Max diameter of the screw head
/// * head_h: The height of the screw head
/// * screw_length: The length of the screw including the head
/// * align_top: If true, the top of the screw will be aligned with 0,0
/// * head_clearance: Can be used to add addditional clearance to the screws head,
///     useful if the screw will not be placed flush with the parts border
/// * play: The additional play to add to the screw (as radius)
module pan_head_screw(screw_dia, head_dia, head_h, screw_length, align_top=true, head_clearance=0, play=default_play, hole_length=0) {
    screw_with_head_shape(screw_dia, head_dia, head_h, screw_length, align_top=align_top, play=play, hole_length=hole_length)
    square([head_dia/2 + play, head_h + head_clearance]);
}

// These modules are legacy code, but some of my models rely on them so I want to keep them working.
// The "modern" approach I use is to describe screws using a bunch of parameters and passing these
// to a module called `make_screw`.
// Such a call might be `make_screw(m5_pan_head(10))` to generate a 10mm long pan head m5 screw.
//
// Luckily we can have modules and functions with overlapping names since OpenSCAD distuinguishes
// module and function calls by syntax.
module spax_3x12_z1(clearance=0, play=default_play, align_top=true) {
    make_screw(spax_3x12_z1(), head_clearance=clearance, play=play, align_top=align_top);
}
module fischer_duopower_6x30S(clearance=0, play=default_play, align_top=true) {
    make_screw(fischer_duopower_6x30S(), head_clearance=clearance, play=play, align_top=align_top);
}


function screw_type(desc) = desc[0];
function screw_dia(desc) = desc[1];
function screw_length(desc) = desc[2];
function screw_head_dia(desc) = desc[3];
function screw_head_h(desc) = desc[4];

SCREW_TYPE_COUNTERSUNK = "counter_sunk_screw";
SCREW_TYPE_PANHEAD = "pan_head_screw";

/// Build a screw from a description
module make_screw(screw_desc, head_clearance=0, play=default_play, align_top=true, hole_length=0) {
    if(screw_type(screw_desc) == SCREW_TYPE_COUNTERSUNK) {
        counter_sunk_screw(screw_dia(screw_desc), screw_head_dia(screw_desc),
                           screw_head_h(screw_desc), screw_length(screw_desc),
                           align_top=align_top, head_clearance=head_clearance, play=play, hole_length=hole_length);
    } else if(screw_type(screw_desc) == SCREW_TYPE_PANHEAD) {
        pan_head_screw(screw_dia(screw_desc), screw_head_dia(screw_desc),
                           screw_head_h(screw_desc), screw_length(screw_desc),
                           align_top=align_top, head_clearance=head_clearance, play=play, hole_length=hole_length);
    }
}

// type, diameter, length, head_dia, head_height
function fan_screw() = [SCREW_TYPE_COUNTERSUNK, 4.8, 7.8, 6.7, 1.5];
function m5_pan_head(length) = [SCREW_TYPE_PANHEAD, 4.8, length+4, 10, 4];
function spax_3x12_z1() = [SCREW_TYPE_COUNTERSUNK, 3, 12.5, 6, 3];
function spax_2_5x10_z1() = [SCREW_TYPE_COUNTERSUNK, 2.5, 10, 5, 2.5];
function fischer_duopower_6x30S() = [SCREW_TYPE_COUNTERSUNK, 4.5, 40.5, 9, 4.5];
function m4_counter_sunk(length) = [SCREW_TYPE_COUNTERSUNK, 3.8, length+4, 6.2, 2.8];

// Examples

$fn=100;

spax_3x12_z1();
translate([10,0,0])
spax_3x12_z1(clearance=10);
translate([20,0,0]) {
    spax_3x12_z1(align_top=false);
    translate([10,0,0])
    spax_3x12_z1(clearance=10, align_top=false);
}

translate([0, 10, 0]) {
    make_screw(fischer_duopower_6x30S());
    translate([10,0,0])
    fischer_duopower_6x30S(clearance=10);
    translate([20,0,0]) {
        fischer_duopower_6x30S(align_top=false);
        translate([10,0,0])
        fischer_duopower_6x30S(clearance=10, align_top=false);
    }
}

translate([0, 30, 0]) {
    make_screw(m5_pan_head(8));
}

translate([0,40,0]) {
    make_screw(spax_2_5x10_z1());
}
