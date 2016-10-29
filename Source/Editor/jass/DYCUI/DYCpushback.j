#ifndef DYCpushbackIncluded
#define DYCpushbackIncluded

#include "DYCUI/DYCbase.j"

library DYCpushback requires DYCbase
//DYCpushback







///////////////////////////////////////////////Pushback_System/////////////////////////////////////////////////////////////

function SysPushbackKT takes nothing returns nothing
if ((GetDestructableTypeId(GetEnumDestructable()) == 'LTlt')or(GetDestructableTypeId(GetEnumDestructable()) == 'ATtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'ATtr')or(GetDestructableTypeId(GetEnumDestructable()) == 'OTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'ITtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'ITtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTwt')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTst')or(GetDestructableTypeId(GetEnumDestructable()) == 'JTct')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTft')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTct')or(GetDestructableTypeId(GetEnumDestructable()) == 'VTlt')or(GetDestructableTypeId(GetEnumDestructable()) == 'JTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'GTsh')or(GetDestructableTypeId(GetEnumDestructable()) == 'DTsh')or(GetDestructableTypeId(GetEnumDestructable()) == 'WTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'CTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'CTtr')or(GetDestructableTypeId(GetEnumDestructable()) == 'KTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'BTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'WTst')or(GetDestructableTypeId(GetEnumDestructable()) == 'NTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'NTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'BTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'FTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'ZTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'ZTtw')) then
    call KillDestructable( GetEnumDestructable() )
endif
endfunction


function SysPushbackTimer takes nothing returns nothing

local integer hd = GetHandleId(GetExpiredTimer())
local unit u = LoadUnitHandle(UDGht,hd,1)
local integer hd2 = GetHandleId(u)
local real a = LoadReal(UDGht,hd,2)
local real t = LoadReal(UDGht,hd,3)
local real d = LoadReal(UDGht,hd,4)
local real angle = LoadReal(UDGht,hd,5)
local location p = LoadLocationHandle(UDGht, hd, 6)
local boolean beff = LoadBoolean(UDGht, hd, 7)
local real v = LoadReal(UDGht,hd,8)
local real n = LoadReal(UDGht,hd,9)
local real n2 = LoadReal(UDGht,hd,10)

local real x = GetUnitX(u)+v*0.03*CosBJ(angle)
local real y = GetUnitY(u)+v*0.03*SinBJ(angle)

local integer upausec = LoadInteger(UDGht,hd2,StringHash("systemupausec"))
local integer upauseac = LoadInteger(UDGht,hd2,StringHash("systemupauseac"))
set v = a*(t-n)

if (upausec==0)or(upauseac==0) then
    set n = n + 0.03
    set n2 = n2 + 0.03
    call MoveLocation(p,x,y)

    if (RectContainsCoords(bj_mapInitialPlayableArea, x, y)==true)and(IsTerrainPathable(x,y,PATHING_TYPE_WALKABILITY)==false) then
        call SetUnitX(u,x)
        call SetUnitY(u,y)
    endif
    if (beff==true) then
        call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", GetUnitX(u), GetUnitY(u)) )
    endif
    if (n2>=0.3) then
        set n2=0
        call EnumDesInCircleDYC( 140, x,y, function SysPushbackKT )
    endif
    if (n>=t) then
    call RemoveLocation(p)
    call DestroyTimer(GetExpiredTimer())
    endif
endif

call SaveUnitHandle(UDGht,hd,1,u)
call SaveReal(UDGht,hd,2,a)
call SaveReal(UDGht,hd,3,t)
call SaveReal(UDGht,hd,4,d)
call SaveReal(UDGht,hd,5,angle)
call SaveLocationHandle( UDGht, hd, 6, p )
call SaveBoolean( UDGht, hd, 7, beff )
call SaveReal(UDGht,hd,8,v)
call SaveReal(UDGht,hd,9,n)
call SaveReal(UDGht,hd,10,n2)

set u = null
endfunction



function DYCpushback takes unit u, real angle, real d, real t, boolean beff returns nothing

local timer timer0 = CreateTimer()
local integer hd = GetHandleId(timer0)
local real v = 2*d/t
local location p = GetUnitLoc(u)
local real a = v/t
local real n = 0
local real n2 = 0

call SaveUnitHandle(UDGht,hd,1,u)
call SaveReal(UDGht,hd,2,a)
call SaveReal(UDGht,hd,3,t)
call SaveReal(UDGht,hd,4,d)
call SaveReal(UDGht,hd,5,angle)
call SaveLocationHandle( UDGht, hd, 6, p )
call SaveBoolean( UDGht, hd, 7, beff )
call SaveReal(UDGht,hd,8,v)
call SaveReal(UDGht,hd,9,n)
call SaveReal(UDGht,hd,10,n2)
call TimerStart(timer0, 0.03, true, function SysPushbackTimer)
set u = null
set timer0 = null
endfunction
endlibrary

#endif /// DYCpushbackIncluded
