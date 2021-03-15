function normalize_idx(v, i) = min([i < 0 ? len(v)+1+i : i, len(v)]);

function sum(v, start=0, end=-1) = start < normalize_idx(v,end) ? v[start] + sum(v, start=start+1, end=end) : 0;
