#ifndef DoubleClickIncluded
#define DoubleClickIncluded
#include "WM\WMBase.j"
library DoubleClick
globals
    private boolean array have
    private boolean array select
    private group heroes=CreateGroup()
    private real x
    private real y
endglobals
private function Set takes nothing returns nothing
	local timer t=GetExpiredTimer()
	local integer id=WMLoadInteger(GetHandleId(t),0)
	set select[id]=false
	call DestroyTimer(t)
	call WMFlushChildHashtable(GetHandleId(t))
	set t=null
endfunction
private function main takes nothing returns nothing
	local integer id=GetPlayerId(GetTriggerPlayer())
	local timer t
	if not have[id] and IsUnitInGroup(GetTriggerUnit(),heroes) then
    if select[id]==true then
        call SetUnitX(GetTriggerUnit(),x)
        call SetUnitY(GetTriggerUnit(),y)
        call SetUnitOwner(GetTriggerUnit(),GetTriggerPlayer(),true)
        call GroupRemoveUnit(heroes,GetTriggerUnit())
        set have[id]=true
        if GetTriggerPlayer()==GetLocalPlayer() then
            call PanCameraToTimed(x,y,0)
        endif
    else
        set select[id]=true
        set t=CreateTimer()
        call WMSaveInteger(GetHandleId(t),0,id)
        call TimerStart(t,0.2,true,function Set)
        set t=null
    endif
	endif
endfunction
private function filter takes nothing returns boolean
	return IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO)and GetOwningPlayer(GetFilterUnit())==Player(15)
endfunction
function DoubleClick takes rect rct,real x0,real y0 returns nothing
    local integer i=0
    local trigger t=CreateTrigger()
    set x=x0
    set y=y0
    call GroupEnumUnitsInRect(heroes,rct,function filter)
    loop
        exitwhen i>11
        set have[i]=false
        set select[i]=false
        call TriggerRegisterPlayerUnitEvent(t,Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
        set i=i+1
    endloop
    call TriggerAddCondition(t,Condition(function main))
    set t=null
endfunction
endlibrary
#endif
