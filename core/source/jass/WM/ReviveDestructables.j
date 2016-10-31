#ifndef ReviveDestructablesIncluded
#define ReviveDestructablesIncluded
#include "WM/WMBase.j"
library ReviveDestructables initializer init
globals
    private trigger tri=CreateTrigger()
    private integer Destructid
endglobals
private function Revive takes nothing returns nothing
    local timer t=GetExpiredTimer()
    local integer id=GetHandleId(t)
    call DestroyTimer(t)
    call DestructableRestoreLife(WMLoadDestructableHandle(id,0),GetDestructableMaxLife(WMLoadDestructableHandle(id,0)),true)
    call WMFlushChildHashtable(id)
    set t=null
endfunction
private function Timer takes nothing returns nothing
    local timer t=CreateTimer()
    call WMSaveDestructableHandle(GetHandleId(t),0,GetTriggerDestructable())
    call TimerStart(t,WMLoadInteger(0,GetDestructableTypeId(GetTriggerDestructable())),false,function Revive)
    set t=null
endfunction
private function WMRegisterDestDeath takes nothing returns nothing
    if GetDestructableTypeId(GetEnumDestructable())==Destructid then
        call TriggerRegisterDeathEvent(tri,GetEnumDestructable())
    endif
endfunction
private function init takes nothing returns nothing
    call TriggerAddAction(tri,function Timer)
endfunction
function ReviveDestructables takes rect r,integer id,real t returns nothing
    set Destructid=id
    call WMSaveReal(0,id,t)
    call EnumDestructablesInRect(r,null,function WMRegisterDestDeath)
endfunction
endlibrary
#endif
