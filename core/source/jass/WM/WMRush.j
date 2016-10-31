#ifndef WMRushIncluded
#define WMRushIncluded
#include "WM/WMBase.j"
library WMRush requires WMBase
private function round takes nothing returns nothing
    local timer t=GetExpiredTimer()
    local integer id=GetHandleId(t)-0x100000
    local unit u=WMLoadUnitHandle(id,0)
    local real radian=WMLoadReal(id,1)
    local real l=WMLoadReal(id,2)
    local real v=WMLoadReal(id,3)
    local real lbs=v*0.03
    local integer max=R2I(l/lbs)
    local integer i=WMLoadInteger(id,6)
    local real x=GetUnitX(u)+Cos(radian)*lbs
    local real y=GetUnitY(u)+Sin(radian)*lbs
    local trigger tri=WMLoadTriggerHandle(id,5)
    if x<WMMaxX and x>WMMinX and y<WMMaxY and y>WMMinY then
        call SetUnitX(u,x)
        call SetUnitY(u,y)
    endif
    if i-(i/2)*2==0then
        call DestroyEffect(AddSpecialEffect(WMLoadStr(id,8),x,y))
    endif
    call WMSaveInteger(id,6,i+1)
    if i>max then
        call DestroyTimer(t)
        call WMFlushChildHashtable(id)
        call DestroyTrigger(tri)
        set id=GetHandleId(tri)-0x100000
        call WMFlushChildHashtable(id)
    endif
    set tri=null
    set u=null
    set t=null
endfunction
private function damage_main takes nothing returns nothing
    local trigger t=GetTriggeringTrigger()
    local integer id=GetHandleId(t)-0x100000
    local unit u=WMLoadUnitHandle(id,0)
    if IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(u))then
        call UnitDamageTarget(u,GetTriggerUnit(),WMLoadReal(id,1),WMLoadBoolean(id,2),WMLoadBoolean(id,3),ConvertAttackType(WMLoadInteger(id,4)),ConvertDamageType(WMLoadInteger(id,5)),WEAPON_TYPE_WHOKNOWS)
    endif
    set t=null
    set u=null
endfunction
function WMRush takes unit u,real degree,real l,real v,real range,real damage,boolean b1,boolean b2,integer a,integer d,unit killer,string s returns nothing
    local timer t
    local integer id
    local trigger tri
    if v==0 then
	    return
	endif
	set t=CreateTimer()
	set id=GetHandleId(t)-0x100000
	set tri=CreateTrigger()
    call TimerStart(t,0.03,true,function round)
    call WMSaveUnitHandle(id,0,u)
    call WMSaveReal(id,1,degree*bj_PI/180)
    call WMSaveReal(id,2,l)
    call WMSaveReal(id,3,v)
    call WMSaveTriggerHandle(id,5,tri)
    call TriggerRegisterUnitInRange(tri,u,range,null)
    call TriggerAddCondition(tri,Condition(function damage_main))
    call WMSaveStr(id,8,s)
    set id=GetHandleId(tri)-0x100000
    if killer==null then
        call WMSaveUnitHandle(id,0,u)
    else
        call WMSaveUnitHandle(id,0,killer)
    endif
    call WMSaveReal(id,1,damage)
    call WMSaveBoolean(id,2,b1)
    call WMSaveBoolean(id,3,b2)
    call WMSaveInteger(id,4,a)
    call WMSaveInteger(id,5,d)
    set tri=null
    set t=null
endfunction
endlibrary
#endif
