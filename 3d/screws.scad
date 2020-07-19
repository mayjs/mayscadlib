use <../positioning.scad>

default_play=0.2;

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
module counter_sunk_screw(screw_dia, head_dia, head_h, screw_length, align_top=true, head_clearance=0, play=default_play) {
    if(align_top) {
        lift(-screw_length)
        counter_sunk_screw(screw_dia, head_dia, head_h, screw_length, align_top=false, head_clearance=head_clearance, play=play);
    } else {
        screw_only_h = screw_length - head_h;
        // Thread part
        cylinder(r=screw_dia/2+play, h=screw_only_h);

        // Head
        lift(screw_only_h)
        rotate_extrude()
        polygon([
            [0,0],
            [screw_dia/2+play, 0],
            [head_dia/2+play, head_h],
            [head_dia/2+play, head_h+head_clearance],
            [0, head_h+head_clearance],
            [0, head_h],
        ]);
    } 
}

module spax_3x12_z1(clearance=0, play=default_play, align_top=true) {
    counter_sunk_screw(3, 6, 3, 12.5, head_clearance=clearance, play=play, align_top=align_top);
}

module fischer_duopower_6x30S(clearance=0, play=default_play, align_top=true) {
    counter_sunk_screw(4.5, 9, 4.5, 40.5, head_clearance=clearance, play=play, align_top=align_top);
}

function screw_type(desc) = desc[0];
function screw_dia(desc) = desc[1];
function screw_length(desc) = desc[2];
function screw_head_dia(desc) = desc[3];
function screw_head_h(desc) = desc[4];

SCREW_TYPE_COUNTERSUNK = "counter_sunk_screw";

/// Build a screw from a description
module make_screw(screw_desc, head_clearance=0, play=default_play, align_top=true) {
    if(screw_type(screw_desc) == "counter_sunk_screw") {
        counter_sunk_screw(screw_dia(screw_desc), screw_head_dia(screw_desc),
                           screw_head_h(screw_desc), screw_length(screw_desc),
                           align_top=align_top, head_clearance=head_clearance, play=play);
    }
}

function fan_screw() = [SCREW_TYPE_COUNTERSUNK, 4.8, 7.8, 6.7, 1.5];

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
    fischer_duopower_6x30S();
    translate([10,0,0])
    fischer_duopower_6x30S(clearance=10);
    translate([20,0,0]) {
        fischer_duopower_6x30S(align_top=false);
        translate([10,0,0])
        fischer_duopower_6x30S(clearance=10, align_top=false);
    }
}
