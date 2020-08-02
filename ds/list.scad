//! This module provides some helper methods to act on lists

/// Construct an empty list
function empty_list() = [];
/// Append a value to this list
function list_append(list, val) = concat(list, [val]);
/// Delete an index in this list
function list_del_idx(list, idx) = [ for (i = [0:len(list)-1]) if(i != idx) list[i]];
/// Set the value at an index
function list_set_idx(list, idx, val) = [ for (i = [0:len(list)-1]) if(i != idx) list[i] else val];
/// Get the last value in a list
function list_last(list) = list[len(list) - 1];

l = empty_list();
l1 = list_append(l, 1);
l2 = list_append(l1, 2);
l3 = list_append(l2, 3);
echo(l3); // [1, 2, 3]
l4 = list_del_idx(l3, 1);
echo(l4); // [1, 3]
