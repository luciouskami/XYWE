#ifndef DYCdmgdodgeIncluded
#define DYCdmgdodgeIncluded

#include "DYCUI/DYCbase.j"

library DYCdmgdodge requires DYCbase
//DYCdmgdodge




///////////////////////////////////////////////DMGDODGE_System/////////////////////////////////////////////////////////////



function SysdmgdodgeTimer1 takes nothing returns nothing

local integer hd = GetHandleId(GetExpiredTimer())
local unit u = LoadUnitHandle(UDGht,hd,1)
local real d = LoadReal(UDGht,hd,2)

call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE)+d )

set u = null
call DestroyTimer(GetExpiredTimer())
endfunction


function SysdmgdodgeTimer2 takes nothing returns nothing

local integer hd = GetHandleId(GetExpiredTimer())
local unit u = LoadUnitHandle(UDGht,hd,1)

call UnitRemoveAbility( u, 'Avul' )

set u = null
call DestroyTimer(GetExpiredTimer())
endfunction


function SysdmgdodgeTimer3 takes nothing returns nothing

local integer hd = GetHandleId(GetExpiredTimer())
local unit u = LoadUnitHandle(UDGht,hd,1)
local real ho = LoadReal(UDGht,hd,2)

if (GetUnitState(u, UNIT_STATE_LIFE)>=ho) then
    call SetUnitState( u, UNIT_STATE_LIFE, ho )
endif

set u = null
call DestroyTimer(GetExpiredTimer())
endfunction



function DYCdmgdodge takes real i returns nothing

local timer timer1 = CreateTimer()
local timer timer2 = CreateTimer()
local timer timer3 = CreateTimer()
local integer hd01 = GetHandleId(timer1)
local integer hd02 = GetHandleId(timer2)
local integer hd03 = GetHandleId(timer3)
local unit u = GetTriggerUnit()
local integer hd2 = GetHandleId(u)
local real dmg = GetEventDamage()
local real dmg0 = GetEventDamage()
local real ho = GetUnitState(u, UNIT_STATE_LIFE)
local real d
local real hpl

set dmg=i*dmg
call SaveReal(UDGht,hd2,StringHash("systemdmgdodged"),dmg+LoadReal(UDGht,hd2,StringHash("systemdmgdodged")))
set hpl=GetUnitState(u, UNIT_STATE_MAX_LIFE) - GetUnitState(u, UNIT_STATE_LIFE)
set d=dmg-hpl
if (GetUnitState(u, UNIT_STATE_MAX_LIFE)>dmg) then
    call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE)+dmg )
    if (d<=0) then
    else
        call SaveUnitHandle(UDGht,hd01,1,u)
        call SaveReal(UDGht,hd01,2,d)
        call TimerStart(timer1, 0.00, false, function SysdmgdodgeTimer1)
    endif
else
    call UnitAddAbility( u, 'Avul' )
    if ((GetUnitState(u, UNIT_STATE_LIFE)-dmg0*(1-i))>1) then
        call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE)-dmg0*(1-i) )
    else
        call SetUnitState( u, UNIT_STATE_LIFE, 1 )
    endif
    call SaveUnitHandle(UDGht,hd02,1,u)
    call TimerStart(timer2, 0.00, false, function SysdmgdodgeTimer2)
endif
call SaveUnitHandle(UDGht,hd03,1,u)
call SaveReal(UDGht,hd03,2,ho)
call TimerStart(timer3, 0.00, false, function SysdmgdodgeTimer3)

set u = null
set timer1 = null
set timer2 = null
set timer3 = null
endfunction
endlibrary


#endif /// DYCdmgdodge
