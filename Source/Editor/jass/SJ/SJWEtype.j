#ifndef SJWEtypeIncluded
#define SJWEtypeIncluded

library_once SJWEtype

function ReturnType takes integer i returns integer
    return i
endfunction

function ReturnType_0 takes integer i returns integer
    return i
endfunction

function ReturnUnitID takes unit whichunit returns integer
    return GetHandleId(whichunit)
endfunction

endlibrary

#endif