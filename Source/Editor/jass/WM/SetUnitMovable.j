#ifndef SetUnitMovableIncluded
#define SetUnitMovableIncluded
library SetUnitMovable
function SetUnitMovable takes unit u,boolean b returns nothing
if b==false then
call SetUnitPropWindow(u,0)
else
call SetUnitPropWindow(u,GetUnitDefaultPropWindow(u))
endif
endfunction
endlibrary
#endif
