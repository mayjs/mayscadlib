//! A 2D turtle implementation.
//! Uses OpenSCADs new function literals, which are only available in dev snapshots!
use <ds/map.scad>;
use <ds/list.scad>;

XIDX = 0; // X pos idx
YIDX = 1; // y pos idx
RIDX = 2; // rotation idx
PIDX = 3; // pen state idx

PEN_UP = false;
PEN_DOWN = true;

/// Construct a new turtle at 0/0
function turtle_new(x=0, y=0, rot=0, pen_down=true) = [x, y, rot, pen_down ? PEN_DOWN : PEN_UP];
/// Set the turtle position to an absolute position
function turtle_set_pos(x, y) = function (ts) [list_set_idx(list_set_idx(ts, XIDX, x), YIDX, y)];
/// Move turtle towards positive y
function turtle_north(d) = function (ts) [list_set_idx(ts, YIDX, turtle_get_y(ts) + d)];
/// Move turtle towards negative y
function turtle_south(d) = function (ts) [list_set_idx(ts, YIDX, turtle_get_y(ts) - d)];
/// Move turtle towards positive x
function turtle_east(d) = function (ts) [list_set_idx(ts, XIDX, turtle_get_x(ts) + d)];
/// Move turtle towards negative x
function turtle_west(d) = function (ts) [list_set_idx(ts, XIDX, turtle_get_x(ts) - d)];
/// Move turtle in absolute orientation, ignoring rotation
function turtle_move_abs(dx, dy) = function (ts) [list_set_idx(list_set_idx(ts, XIDX, turtle_get_x(ts) + dx), YIDX, turtle_get_y(ts) + dy)];
/// Turtle pen up
function turtle_pen_up() = function (ts) [list_set_idx(ts, PIDX, PEN_UP)];
/// Turtle pen down
function turtle_pen_down() = function (ts) [list_set_idx(ts, PIDX, PEN_DOWN)];

function _turtle_run(is, trans, tidx) = tidx < len(trans) ?
                                        concat(trans[tidx](is), _turtle_run(list_last(trans[tidx](is)), trans, tidx+1)):
                                        [];
function turtle_run(initial_state, transitions) = concat([initial_state], _turtle_run(initial_state, transitions, 0));
function turtle_get_x(ts) = ts[XIDX];
function turtle_get_y(ts) = ts[YIDX];

echo(turtle_run(turtle_new(), [
           turtle_set_pos(1,1),
           turtle_north(2),
           turtle_west(2),
           turtle_pen_up(),
       ]));
