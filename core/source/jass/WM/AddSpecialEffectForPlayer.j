#ifndef AddSpecialEffectForPlayerIncluded
#define AddSpecialEffectForPlayerIncluded
library AddSpecialEffectForPlayer
function AddSpecialEffectForPlayer takes player p,string s,real x,real y returns nothing
    local string st=""
    if GetLocalPlayer()==p then
        set st=s
    endif
    call DestroyEffect(AddSpecialEffect(st,x,y))
endfunction
endlibrary
#endif
