#ifndef DYCbarsimoffIncluded
#define DYCbarsimoffIncluded

#include "DYCUI/DYCbase.j"


library DYCbarsimoff requires DYCbase

function DYCbarsimoff takes unit u returns nothing
    local integer hd=GetHandleId(u)
    call SaveInteger(UDGht,hd,StringHash("barsimj"),0)
    set u=null
endfunction

endlibrary





#endif /// DYCbarsimoff
