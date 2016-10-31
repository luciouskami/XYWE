#ifndef WMCreateEffectsIncluded
#define WMCreateEffectsIncluded
library WMCreateEffects
function WMCreateEffects takes real x,real y,real r,integer n,string s returns nothing
    local integer i=1
    loop
        exitwhen i>n
        call DestroyEffect(AddSpecialEffect(s,x+Cos(GetRandomReal(0,6.28))*GetRandomReal(0,r),y+Sin(GetRandomReal(0,6.28))*GetRandomReal(0,r)))
        set i=i+1
    endloop
endfunction
endlibrary
#endif
