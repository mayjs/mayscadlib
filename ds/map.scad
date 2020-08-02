use <list.scad>
//! This file provides a simple implementation of a map.
//! For simplicities sake, this does not use hashing but
//! is solely based on linear search in a list of tuples.

function _map_search(map, key, idx=0) = idx < len(map) ?
                                        (map[idx][0] == key ? idx : _map_search(map, key, idx=idx+1)) :
                                        undef;
/// Construct an empty list
function empty_map() = empty_list();
/// Check if the given key is present in the map
function map_contains_key(map, key) = map_index(map, key) != undef;
/// Get the index of the key in the map
function map_index(map, key) = _map_search(map, key);
/// Delete a key in this map; returns the unchanged map if the key is not contained
function map_delete(map, key) = map_contains_key(map, key) ?
                                list_del_idx(map, map_index(map, key)):
                                map;
/// Insert a value for the given key, overwriting existing values
function map_insert(map, key, value) = list_append(map_delete(map, key), [key, value]);
/// Lookup a key in this map
function map_lookup(map, key) = map[map_index(map, key)][1];

em = empty_map();
m1 = map_insert(
        map_insert(
                map_insert(em, "1", 1),
                "2", 2),
            "3", 3);
echo(m1); // [["1", 1], ["2", 2], ["3", 3]] 
echo(map_lookup(m1, "2")); // 2
m2 = map_delete(m1, "2");
echo(m2); // [["1", 1], ["3", 3]] 
echo(map_lookup(m2, "2")); // undef
