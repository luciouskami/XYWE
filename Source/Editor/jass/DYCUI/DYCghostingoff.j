#ifndef DYCghostingoffIncluded
#define DYCghostingoffIncluded

#include "DYCUI/DYCbase.j"

library DYCghostingoff requires DYCbase

function DYCghostingoff takes unit u returns nothing
    local integer hd=GetHandleId(u)
    call SaveInteger(UDGht,hd,StringHash("ghostingj"),0)
    set u=null
endfunction

endlibrary



#endif /// DYCghostingoff
