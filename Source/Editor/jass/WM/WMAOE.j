#ifndef WMAOEIncluded
#define WMAOEIncluded
#include "WM/UnitAlive.j"
library WMAOE
function WMAOE takes unit u,real x,real y,real r,real d,boolean b1,boolean b2,attacktype t1,damagetype t2 returns nothing
    local group g=CreateGroup()
    local unit t
    call GroupEnumUnitsInRange(g,x,y,r,null)
    loop
        set t=FirstOfGroup(g)
        exitwhen t==null
        if IsUnitEnemy(t,GetOwningPlayer(u))and UnitAlive(t)then
            call UnitDamageTarget(u,t,d,b1,b2,t1,t2,WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,t)
    endloop
    call DestroyGroup(g)
    set g=null
    set t=null
endfunction
endlibrary
#endif
