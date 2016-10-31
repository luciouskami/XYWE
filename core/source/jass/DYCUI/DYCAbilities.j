#ifndef DYCAbilitiesIncluded
#define DYCAbilitiesIncluded

#include "DYCUI/DYCbase.j"
#include "DYCUI/DYCTriggerEvent.j"









library DYCUPause requires DYCbase
//////////////////////////////upause//////////////////////

function SysUPauseTimer takes nothing returns nothing

    local integer hd01 = GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local integer m=LoadInteger(UDGht,hd01,3)
    local integer hd=GetHandleId(u)

    if (m==1)or(m==3) then
        call SaveInteger(UDGht,hd,StringHash("systemupausec"),LoadInteger(UDGht,hd,StringHash("systemupausec"))-1)
        if (LoadInteger(UDGht,hd,StringHash("systemupausec"))<=0) then
            call PauseUnit( u, false )
        endif
    endif

    if (m==2)or(m==3) then
        call SaveInteger(UDGht,hd,StringHash("systemupauseac"),LoadInteger(UDGht,hd,StringHash("systemupauseac"))-1)
        if (LoadInteger(UDGht,hd,StringHash("systemupauseac"))<=0) then
            call SetUnitTimeScale( u, 1 )
        endif
    endif

    set u = null
    call DestroyTimer(GetExpiredTimer())

endfunction


function DYCUPause takes unit u, real t, integer m returns nothing

    local timer timer1 = CreateTimer()
    local integer hd01 = GetHandleId(timer1)
    local integer hd = GetHandleId(u)

    if (m==1)or(m==3) then
        call SaveInteger(UDGht,hd,StringHash("systemupausec"),LoadInteger(UDGht,hd,StringHash("systemupausec"))+1)
        call PauseUnit( u, true )
    endif
    if (m==2)or(m==3) then
        call SaveInteger(UDGht,hd,StringHash("systemupauseac"),LoadInteger(UDGht,hd,StringHash("systemupauseac"))+1)
        call SetUnitTimeScale( u, 0 )
    endif

    call SaveUnitHandle(UDGht,hd01,1,u)
    call SaveInteger(UDGht,hd01,3,m)
    call TimerStart(timer1, t, false, function SysUPauseTimer)

    set u = null
    set timer1 = null

endfunction

//////////////////////////////upause//////////////////////
endlibrary

library DYCleap requires DYCbase
//////////////////////////////leap//////////////////////


function SysLeapKT takes nothing returns nothing
if ((GetDestructableTypeId(GetEnumDestructable()) == 'LTlt')or(GetDestructableTypeId(GetEnumDestructable()) == 'ATtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'ATtr')or(GetDestructableTypeId(GetEnumDestructable()) == 'OTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'ITtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'ITtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTwt')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTst')or(GetDestructableTypeId(GetEnumDestructable()) == 'JTct')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTft')or(GetDestructableTypeId(GetEnumDestructable()) == 'YTct')or(GetDestructableTypeId(GetEnumDestructable()) == 'VTlt')or(GetDestructableTypeId(GetEnumDestructable()) == 'JTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'GTsh')or(GetDestructableTypeId(GetEnumDestructable()) == 'DTsh')or(GetDestructableTypeId(GetEnumDestructable()) == 'WTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'CTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'CTtr')or(GetDestructableTypeId(GetEnumDestructable()) == 'KTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'BTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'WTst')or(GetDestructableTypeId(GetEnumDestructable()) == 'NTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'NTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'BTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'FTtw')or(GetDestructableTypeId(GetEnumDestructable()) == 'ZTtc')or(GetDestructableTypeId(GetEnumDestructable()) == 'ZTtw')) then
    call KillDestructable( GetEnumDestructable() )
endif
endfunction


function SysLeapTimer takes nothing returns nothing
local integer hd = GetHandleId(GetExpiredTimer())
local unit u = LoadUnitHandle(UDGht,hd,1)
local integer hd2 = GetHandleId(u)
local real h = LoadReal(UDGht,hd,2)
local real t = LoadReal(UDGht,hd,3)
local real d = LoadReal(UDGht,hd,4)
local real angle = LoadReal(UDGht,hd,5)
local integer ab = LoadInteger(UDGht,hd,6)
local integer kt = LoadInteger(UDGht,hd,7)
local real n = LoadReal(UDGht,hd,8)
local real v = LoadReal(UDGht,hd,9)
local real v2 = LoadReal(UDGht,hd,10)
local real mode = LoadReal(UDGht,hd,11)
local real a = LoadReal(UDGht,hd,12)
local real h2 = LoadReal(UDGht,hd,13)
local real x
local real y
local real dd = 0
local real dh = GetUnitDefaultFlyHeight(u)
local integer leappausec = LoadInteger(UDGht,hd2,StringHash("systemleappause"))
local integer upausec = LoadInteger(UDGht,hd2,StringHash("systemupausec"))
local integer upauseac = LoadInteger(UDGht,hd2,StringHash("systemupauseac"))
local integer leapend = LoadInteger(UDGht,hd2,StringHash("systemleapend"+I2S(hd)))

if (leappausec==0)and((upausec==0)or(upauseac==0))and(leapend!=1) then
    set n = n + 0.02
    call SaveReal(UDGht,hd,8,n)
    set a = ((-8)*h/(t*t))
    call SaveReal(UDGht,hd,12,a)
    set v = v+a*0.02
    call SaveReal(UDGht,hd,9,v)
    set h2 = GetUnitFlyHeight(u)+v*0.02
    call SaveReal(UDGht,hd,13,h2)
    call SetUnitFlyHeight( u, h2, 9999.00 )

    if (d!=0) then
        set dd=v2*n
        //call BJDebugMsg(R2S(dd))
        set x = GetUnitX(u)+v2*0.02*CosBJ(angle)
        set y = GetUnitY(u)+v2*0.02*SinBJ(angle)
        if (x>=GetRectMinX(bj_mapInitialPlayableArea))and(y>=GetRectMinY(bj_mapInitialPlayableArea))and(x<=GetRectMaxX(bj_mapInitialPlayableArea))and(y<=GetRectMaxY(bj_mapInitialPlayableArea)) then
            if (mode==1) then
                call SetUnitX(u,x)
                call SetUnitY(u,y)
            else
                if (IsTerrainPathable(x,y,PATHING_TYPE_WALKABILITY)==false) then
                    call SetUnitX(u,x)
                    call SetUnitY(u,y)
                endif
            endif
        else
            call SaveInteger(UDGht,hd,StringHash("SystemLeapOut"),1)
        endif
    endif
endif
//call BJDebugMsg(R2S(n))

if ( ( (h2<=dh) and (dd>=d)and(d!=0) )or(((h2<=dh))and(d==0)) or (leapend==1) ) then

    call SaveInteger(UDGht,hd2,StringHash("SysULeaping"),LoadInteger(UDGht,hd2,StringHash("SysULeaping"))-1)
    if LoadInteger(UDGht,hd2,StringHash("SysULeaping"))<=0 then
        call SetUnitFlyHeight( u, dh, 9999.00 )
    endif
    //call BJDebugMsg(I2S(LoadInteger(UDGht,hd2,StringHash("SysULeaping"))))
    if (kt!=0) then
        call EnumDesInCircleDYC( 175, GetUnitX(u),GetUnitY(u), function SysLeapKT )
    endif
    call SaveInteger(UDGht,hd,StringHash("SystemTimerOver"),1)
    call DestroyTimer(GetExpiredTimer())
endif

set u = null
endfunction



function DYCleap takes unit u, real h, real d, real t, real angle, boolean bab, boolean bkt returns integer
//u:unit   h:leap height   t:leap time    d:leap distanse(can be 0)   angle:leap angle(useless when d=0)    ab:anti block    kt:kill trees
local timer timer0 = CreateTimer()
local integer hd = GetHandleId(timer0)
local real x
local real y
local real mode = 1
local real dh = GetUnitDefaultFlyHeight(u)
local real v
local real v2=0
local integer ab
local integer kt

call SaveInteger(UDGht,GetHandleId(u),StringHash("SysULeaping"),LoadInteger(UDGht,GetHandleId(u),StringHash("SysULeaping"))+1)
if (bab == true) then
set ab = 1
else
set ab = 0
endif
if (bkt == true) then
set kt = 1
else
set kt = 0
endif
if (h<=1) then
set h = 1
endif
if (t<=0) then
set t = 0.6
endif
if (d<0) then
set d = 0
endif
call UnitAddAbility( u, 'Arav' )
call UnitRemoveAbility( u, 'Arav' )
if (d!=0) then
set x = GetUnitX(u)+d*CosBJ(angle)
set y = GetUnitY(u)+d*SinBJ(angle)
set v2 = (d/t)
if (IsTerrainPathable(x,y,PATHING_TYPE_WALKABILITY)==false) then
set mode = 1
else
set mode = 2
endif
endif
if (ab==0) then
set mode = 1
endif
set v = ((4*h)/t)

call SaveUnitHandle(UDGht,hd,1,u)
call SaveReal(UDGht,hd,2,h)
call SaveReal(UDGht,hd,3,t)
call SaveReal(UDGht,hd,4,d)
call SaveReal(UDGht,hd,5,angle)
call SaveInteger(UDGht,hd,6,ab)
call SaveInteger(UDGht,hd,7,kt)
call SaveReal(UDGht,hd,8,0)
call SaveReal(UDGht,hd,9,v)
call SaveReal(UDGht,hd,10,v2)
call SaveReal(UDGht,hd,11,mode)
call TimerStart(timer0, 0.02, true, function SysLeapTimer)

set u = null
set timer0 = null

call SaveInteger(UDGht,hd,StringHash("SystemTimerOver"),0)
call SaveInteger(UDGht,hd,StringHash("SystemLeapOut"),0)

return hd
endfunction




function DYCleapend takes unit u, integer hdt returns nothing


    local integer hd=GetHandleId(u)

    call SaveInteger(UDGht,hd,StringHash("systemleapend"+I2S(hdt)),1)


    set u=null


endfunction
//////////////////////////////leap//////////////////////
endlibrary








library DYCcharge requires DYCbase, DYCleap, DYCTriggerEvent
///////////////////////////////charge normal///////////////////////

globals
    private unit TempU
    private group TempG
    private string TempS
    private boolean TempB
    private integer TempI
    private real TempR



endglobals




function SyschargeGroup2 takes nothing returns nothing
    local real d=SquareRoot(Pow((GetUnitX(TempU)-GetUnitX(GetEnumUnit())),2)+Pow((GetUnitY(TempU)-GetUnitY(GetEnumUnit())),2))
    if (d<=TempR)and(IsUnitInGroup(GetEnumUnit(), TempG) == false) then

        set bj_DYCUnit1=TempU
        set bj_DYCUnit2=GetEnumUnit()
        set bj_DYCTJudge=1
        call SaveStr(UDGht,GetHandleId(TempU),StringHash("SystemUChargen"),TempS)
        call DYCAnyUnitTrigger()

        call GroupAddUnit(TempG,GetEnumUnit())
    endif
endfunction

function SyschargeGroup takes nothing returns nothing


    if (LoadInteger(UDGht,GetHandleId(TempU),StringHash("DC"+TempS))==1)and(IsUnitType(GetEnumUnit(), UNIT_TYPE_DEAD) == false)  and (IsUnitInGroup(GetEnumUnit(), TempG) == false) then



        set bj_DYCUnit1=TempU
        set bj_DYCUnit2=GetEnumUnit()
        set bj_DYCTJudge=1
        call SaveStr(UDGht,GetHandleId(TempU),StringHash("SystemUChargen"),TempS)
        call DYCAnyUnitTrigger()
        call GroupAddUnit(TempG,GetEnumUnit())


    endif


endfunction


function SyschargeTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local real h=LoadReal(UDGht,hd01,2)
    local real r=LoadReal(UDGht,hd01,3)
    local integer hd2=LoadInteger(UDGht,hd01,4)
    local boolean blf=LoadBoolean(UDGht,hd01,6)
    local string cn=LoadStr(UDGht,hd01,7)
    local real angle=LoadReal(UDGht,hd01,8)
    local real n=LoadReal(UDGht,hd01,9)
    local boolean boo=LoadBoolean(UDGht,hd01,10)
    local integer hd=GetHandleId(u)
    local group gs
    local group g

    set n=n+0.02

    if (blf) then
        call SetUnitFacing(u,angle)
    endif

    if (r>0) then
        set g=LoadGroupHandle(UDGht,hd01,5)
        set gs=CreateGroup()
        call GroupEnumUnitsInRange(gs,GetUnitX(u),GetUnitY(u),r,null)
        if (boo) then
            set TempS=cn
            set TempG=g
            set TempU=u
            set TempR=r
            call ForGroup(bj_DYCDummyGroup, function SyschargeGroup2)
        endif
        set TempG=g
        set TempU=u
        set TempS=cn
        set TempB=boo
        set TempI=0
        call ForGroup(gs, function SyschargeGroup)
        call DestroyGroup(gs)
    endif

    if (n>0.02)and((IsUnitType(u, UNIT_TYPE_DEAD) == true)or(LoadInteger(UDGht,hd,StringHash("DC"+cn))==0)) then

        set bj_DYCUnit1=u
        set bj_DYCUnit2=null
        set bj_DYCTJudge=3
        call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
        call DYCAnyUnitTrigger()

        call DYCleapend(u,hd2)
        call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
        call UnitRemoveType(u, UNIT_TYPE_PEON )
        call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
        call DestroyTimer(GetExpiredTimer())
    else
        if (LoadInteger(UDGht,hd2,StringHash("SystemTimerOver"))==1)or(LoadInteger(UDGht,hd2,StringHash("SystemLeapOut"))==1) then
            //call BJDebugMsg(R2S(n))

            set bj_DYCUnit1=u
            set bj_DYCUnit2=null
            set bj_DYCTJudge=2
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()

            set bj_DYCUnit1=u
            set bj_DYCUnit2=null
            set bj_DYCTJudge=3
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()

            call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
            call UnitRemoveType(u, UNIT_TYPE_PEON )
            call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
            call DestroyTimer(GetExpiredTimer())
        endif
    endif

    call SaveReal(UDGht,hd01,9,n)

    set g=null
    set gs=null
    set u=null

endfunction


function DYCcharge takes unit u, real h, real d, real t, real angle, real r, boolean boo, boolean bab, boolean bkt, boolean blf, string cn returns nothing


    local timer timer1=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer hd2=DYCleap(u,h,d,t,angle,bab,bkt)
    local integer hd=GetHandleId(u)

    call UnitAddType(u, UNIT_TYPE_PEON )
    call SaveUnitHandle(UDGht,hd01,1,u)
    call SaveReal(UDGht,hd01,2,h)
    call SaveReal(UDGht,hd01,3,r)
    call SaveInteger(UDGht,hd01,4,hd2)
    if (r>0) then
        call SaveGroupHandle(UDGht,hd01,5,CreateGroup())
    endif
    call SaveBoolean(UDGht,hd01,6,blf)
    call SaveStr(UDGht,hd01,7,cn)
    call SaveReal(UDGht,hd01,8,angle)
    call SaveReal(UDGht,hd01,9,0)
    call SaveBoolean(UDGht,hd01,10,boo)
    call SaveInteger(UDGht,hd,StringHash("DC"+cn),1)
    call TimerStart(timer1,0.02,true,function SyschargeTimer1)

    set u=null
    set timer1=null

endfunction




//dyc charge to target unit

function SyschargetargetTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local unit u2=LoadUnitHandle(UDGht,hd01,2)
    local real spd=LoadReal(UDGht,hd01,3)
    local real r=LoadReal(UDGht,hd01,4)
    local boolean boo=LoadBoolean(UDGht,hd01,6)
    local integer ani=LoadInteger(UDGht,hd01,7)
    local real aspd=LoadReal(UDGht,hd01,8)
    local string cn=LoadStr(UDGht,hd01,9)
    local real n=LoadReal(UDGht,hd01,10)
    local real de=LoadReal(UDGht,hd01,11)
    local real vy=LoadReal(UDGht,hd01,12)
    local integer j=LoadInteger(UDGht,hd01,13)
    local real x0=LoadReal(UDGht,hd01,14)
    local real y0=LoadReal(UDGht,hd01,15)
    local real h0=LoadReal(UDGht,hd01,16)
    local real vy0=LoadReal(UDGht,hd01,17)
    local integer hd=GetHandleId(u)
    local group gs
    local group g
    local real angle
    local real x
    local real y
    local real d
    local real d1
    local real dm
    local real tm
    local real tl
    local real a
    local real h=GetUnitFlyHeight(u)
    local real dh=GetUnitDefaultFlyHeight(u)
    local integer upausec = LoadInteger(UDGht,hd,StringHash("systemupausec"))
    local integer upauseac = LoadInteger(UDGht,hd,StringHash("systemupauseac"))

    set d=SquareRoot(Pow((GetUnitX(u)-GetUnitX(u2)),2)+Pow((GetUnitY(u)-GetUnitY(u2)),2))


    if ((upausec==0)or(upauseac==0)) then
        set n=n+0.03
        call SetUnitTimeScale( u, aspd )
        if (n==0.03) then
            call IssueImmediateOrderById( u, 851993 )

        endif
        if (n==0.06)and(GetUnitAbilityLevel(u, 'Aloc') == 0) then
            call SetUnitAnimationByIndex( u, ani )
        endif

        if (n>0.04)and(j==1)and(dh>=h) then
            set j=0
            call SetUnitFlyHeight(u,dh,99999)
        endif
        set d1=SquareRoot(Pow((GetUnitX(u)-x0),2)+Pow((GetUnitY(u)-y0),2))
        if (j==1)and(d>de)and((h>GetUnitFlyHeight(u2))or(d-de>d1)) then

            if (d-de>d1) then
                if (h<h0) then
                    set dm=(d1+(d-de))/2-d1
                    set tm=dm/spd
                    set a=-vy*vy/2/(h0-h)
                    set vy=vy+a*0.03
                    call SetUnitFlyHeight(u,h+vy*0.03,9999999)
                endif
            else
                set h0=(h-GetUnitDefaultFlyHeight(u))*Pow((d1+d-de)/2,2)/(Pow((d1+d-de)/2,2)-Pow((d1-d+de)/2,2))+GetUnitDefaultFlyHeight(u)
                set tm=(d1+d-de)/2/spd
                set vy0=2*h0/tm
                set tl=(d-de)/spd
                set a=(-vy0-vy)/tl
                set vy=vy+a*0.03
                call SetUnitFlyHeight(u,h+vy*0.03,9999999)

            endif
        else
            if (j==1)and(h<GetUnitFlyHeight(u2)) then

                set tl=(d-de)/spd
                set vy=(GetUnitFlyHeight(u2)-h)/tl
                call SetUnitFlyHeight(u,h+vy*0.03,9999999)
            endif
        endif


        set angle=Atan2(GetUnitY(u2)-GetUnitY(u),GetUnitX(u2)-GetUnitX(u))
        if (GetUnitX(u2)==GetUnitX(u)) then
            if (GetUnitY(u2)>GetUnitY(u)) then
                set angle=90/bj_RADTODEG
            else
                set angle=270/bj_RADTODEG
            endif
        endif
        call SetUnitFacing(u,angle*bj_RADTODEG)
        set x=GetUnitX(u)+spd*0.03*Cos(angle)
        set y=GetUnitY(u)+spd*0.03*Sin(angle)
        call SetUnitX(u,x)
        call SetUnitY(u,y)


        if (r>0) then
            set g=LoadGroupHandle(UDGht,hd01,5)
            set gs=CreateGroup()
            call GroupEnumUnitsInRange(gs,GetUnitX(u),GetUnitY(u),r,null)
            if (boo) then
                set TempS=cn
                set TempG=g
                set TempU=u
                set TempR=r
                call ForGroup(bj_DYCDummyGroup, function SyschargeGroup2)
            endif
            set TempG=g
            set TempU=u
            set TempS=cn
            set TempB=boo
            set TempI=0
            call ForGroup(gs, function SyschargeGroup)
            call DestroyGroup(gs)

        endif

    endif


    if (n>0.03)and((IsUnitType(u,UNIT_TYPE_DEAD)==true)or(IsUnitType(u2,UNIT_TYPE_DEAD)==true)or(LoadInteger(UDGht,hd,StringHash("DC"+cn))==0)) then

        if LoadInteger(UDGht,hd,StringHash("SysULeaping"))<=0 then
            call SetUnitFlyHeight( u, dh, 9999999.00 )
        endif

        set bj_DYCUnit1=u
        set bj_DYCUnit2=u2
        set bj_DYCTJudge=3
        call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
        call DYCAnyUnitTrigger()


        call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
        //call SetUnitAcquireRange( u, GetUnitDefaultAcquireRange(u) )
        call UnitRemoveType(u, UNIT_TYPE_PEON )
        call SetUnitTimeScale( u, 1 )
        call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
        call DestroyTimer(GetExpiredTimer())
    else

        if (d<=de) then

            if LoadInteger(UDGht,hd,StringHash("SysULeaping"))<=0 then
                call SetUnitFlyHeight( u, dh, 9999999.00 )
            endif

            set bj_DYCUnit1=u
            set bj_DYCUnit2=u2
            set bj_DYCTJudge=2
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()

            set bj_DYCUnit1=u
            set bj_DYCUnit2=u2
            set bj_DYCTJudge=3
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()


            call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
            //call SetUnitAcquireRange( u, GetUnitDefaultAcquireRange(u) )
            call UnitRemoveType(u, UNIT_TYPE_PEON )
            call SetUnitTimeScale( u, 1 )
            call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
            call DestroyTimer(GetExpiredTimer())
        endif
    endif

    call SaveReal(UDGht,hd01,10,n)
    call SaveReal(UDGht,hd01,12,vy)

    set g=null
    set gs=null
    set u=null
    set u2=null

endfunction


function DYCchargetarget takes unit u, unit u2, real h0, real spd, real de, real r, boolean boo, integer ani, real aspd, string cn returns nothing

    local timer timer1=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer hd=GetHandleId(u)
    local real vy=0
    local real d=SquareRoot(Pow((GetUnitX(u)-GetUnitX(u2)),2)+Pow((GetUnitY(u)-GetUnitY(u2)),2))
    local real t=0
    local real a
    local integer j

    if (spd<=0) then
        set spd=700
    endif
    if (de<=0) then
        set de=90
    endif
    if (ani<0) then
        set ani=0
    endif
    if (h0<0) then
        set h0=0
    endif
    if (h0>0) then
        set t=d/spd
        set a=(8)*h0/(t*t)
        set vy=a*t/2
        set h0=h0+GetUnitDefaultFlyHeight(u)
    endif
    if (vy==0) then
       set j=0
    else
       set j=1
       call UnitAddAbility( u, 'Arav' )
       call UnitRemoveAbility( u, 'Arav' )
    endif

    //call SetUnitAcquireRange( u, 0 )
    call UnitAddType(u, UNIT_TYPE_PEON )
    call SaveUnitHandle(UDGht,hd01,1,u)
    call SaveUnitHandle(UDGht,hd01,2,u2)
    call SaveReal(UDGht,hd01,3,spd)
    call SaveReal(UDGht,hd01,4,r)
    if (r>0) then
        call SaveGroupHandle(UDGht,hd01,5,CreateGroup())
    endif
    call SaveBoolean(UDGht,hd01,6,boo)
    call SaveInteger(UDGht,hd01,7,ani)
    call SaveReal(UDGht,hd01,8,aspd)
    call SaveStr(UDGht,hd01,9,cn)
    call SaveReal(UDGht,hd01,10,0)
    call SaveReal(UDGht,hd01,11,de)
    call SaveReal(UDGht,hd01,12,vy)
    call SaveInteger(UDGht,hd01,13,j)
    call SaveReal(UDGht,hd01,14,GetUnitX(u))
    call SaveReal(UDGht,hd01,15,GetUnitY(u))
    call SaveReal(UDGht,hd01,16,h0)
    call SaveReal(UDGht,hd01,17,vy)
    call SaveInteger(UDGht,hd,StringHash("DC"+cn),1)
    call TimerStart(timer1,0.03,true,function SyschargetargetTimer1)

    set u=null
    set u2=null
    set timer1= null

endfunction


//end a certain charge

function DYCchargeend takes unit u, string cn returns nothing

    local integer hd=GetHandleId(u)
    call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)

    set u=null
endfunction


endlibrary



/////////////////////////////////////////
/////////////////////////////////////////


library DYCImpaleLinear requires DYCbase, DYCleap, DYCUPause


//////////////////////////////impale linear//////////////////////

globals
    private unit TempU
    private unit TempMJ
    private group TempG
    private real TempDMG
    private string TempOrder

endglobals



function SysImpaleTimer4 takes nothing returns nothing

    local integer hd = GetHandleId(GetExpiredTimer())
    local unit u = LoadUnitHandle( UDGht, hd, 1)
    local unit mj = LoadUnitHandle( UDGht, hd, 2)
    local unit su = LoadUnitHandle( UDGht, hd, 3)
    local real dmg = LoadReal(UDGht,hd,4)
    local string order = LoadStr(UDGht,hd,5)

    call IssueTargetOrder(mj,order,su)
    call SaveInteger(UDGht,GetHandleId(su),StringHash("SystemUImpaledj"),1)
    call UnitDamageTarget(u,su,dmg,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
    call SaveInteger(UDGht,GetHandleId(su),StringHash("SystemUImpaledj"),0)

    set u = null
    set mj = null
    set su = null
    call DestroyTimer(GetExpiredTimer())
endfunction

function SysImpaleGroup takes nothing returns nothing
    local timer timer4
    local integer hd

    if ((IsUnitType(GetEnumUnit(), UNIT_TYPE_STRUCTURE) == false) and (IsUnitType(GetEnumUnit(), UNIT_TYPE_MAGIC_IMMUNE) == false) and (IsUnitType(GetEnumUnit(), UNIT_TYPE_MECHANICAL) == false) and (IsUnitType(GetEnumUnit(), UNIT_TYPE_DEAD) == false) and (GetUnitAbilityLevel(GetEnumUnit(), 'Aloc') == 0) and (GetUnitAbilityLevel(GetEnumUnit(), 'Avul') == 0) and (IsUnitEnemy(GetEnumUnit(), GetOwningPlayer(TempU)) == true) and (GetUnitDefaultMoveSpeed(GetEnumUnit()) > 0.00) and (IsUnitInGroup(GetEnumUnit(), TempG) == false)) then
        call GroupAddUnit(TempG,GetEnumUnit())
        call DYCleap(GetEnumUnit(),450,0,0.6,0,false,false)
        call DYCUPause(GetEnumUnit(),0.6,1)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\Impale\\ImpaleHitTarget.mdl", GetUnitX(GetEnumUnit())-20, GetUnitY(GetEnumUnit())-20))
        //call IssueTargetOrder(TempMJ,TempOrder,GetEnumUnit())
        //call UnitDamageTarget(TempU,GetEnumUnit(),TempDMG,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)

        set timer4=CreateTimer()
        set hd=GetHandleId(timer4)
        call SaveUnitHandle( UDGht, hd, 1, TempU )
        call SaveUnitHandle( UDGht, hd, 2, TempMJ )
        call SaveUnitHandle( UDGht, hd, 3, GetEnumUnit() )
        call SaveReal( UDGht, hd, 4, TempDMG )
        call SaveStr( UDGht, hd, 5, TempOrder)
        call TimerStart(timer4, 0.6, false, function SysImpaleTimer4)
    endif

    set timer4=null
endfunction

function SysImpaleTimer1 takes nothing returns nothing
    local integer hd = GetHandleId(GetExpiredTimer())
    local unit mj = LoadUnitHandle(UDGht,hd,1)
    call RemoveUnit(mj)
    set mj = null
    call DestroyTimer(GetExpiredTimer())
endfunction

function SysImpaleTimer3 takes nothing returns nothing
    local integer hd = GetHandleId(GetExpiredTimer())
    local effect eff = LoadEffectHandle( UDGht, hd, 1)
    call DestroyEffect(eff)
    set eff = null
    call DestroyTimer(GetExpiredTimer())
endfunction

function SysImpaleTimer2 takes nothing returns nothing
    local integer hd02 = GetHandleId(GetExpiredTimer())
    local real dmg=LoadReal(UDGht,hd02,1)
    local real d=LoadReal(UDGht,hd02,2)
    local real r=LoadReal(UDGht,hd02,3)
    local real x0=LoadReal(UDGht,hd02,4)
    local real y0=LoadReal(UDGht,hd02,5)
    local real speed=LoadReal(UDGht,hd02,6)
    local real n=LoadReal(UDGht,hd02,7)
    local real d2=LoadReal(UDGht,hd02,8)
    local real a=LoadReal(UDGht,hd02,9)
    local unit u=LoadUnitHandle(UDGht,hd02,10)
    local unit mj=LoadUnitHandle(UDGht,hd02,11)
    local group g=LoadGroupHandle(UDGht,hd02,12)
    local string order=LoadStr(UDGht,hd02,13)
    local integer mjt=LoadInteger(UDGht,hd02,14)
    local group gs
    local real dd
    local real x
    local real y
    local effect eff
    local timer efftimer
    local integer hd

    set n=n+0.02
    set d2=d2+speed*0.02
    set dd=n*speed
    set x=x0+dd*CosBJ(a)
    set y=y0+dd*SinBJ(a)
    if (d2>=200) then
        set d2=0
        set efftimer=CreateTimer()
        set hd=GetHandleId(efftimer)
        set eff=AddSpecialEffect("Abilities\\Spells\\Undead\\Impale\\ImpaleMissTarget.mdl", x-20, y-20)
        call SaveEffectHandle( UDGht, hd, 1, eff )
        call TimerStart(efftimer, 1, false, function SysImpaleTimer3)
    endif
    set gs=CreateGroup()
    call GroupEnumUnitsInRange(gs,x,y,r,null)
    set TempG=g
    set TempU=u
    set TempDMG=dmg
    set TempMJ=mj
    set TempOrder=order
    call ForGroup(gs, function SysImpaleGroup)
    call DestroyGroup(gs)
    if (dd>=d) then
        call DestroyGroup(g)
        call DestroyTimer(GetExpiredTimer())
    endif

    call SaveReal(UDGht,hd02,1,dmg)
    call SaveReal(UDGht,hd02,2,d)
    call SaveReal(UDGht,hd02,3,r)
    call SaveReal(UDGht,hd02,4,x0)
    call SaveReal(UDGht,hd02,5,y0)
    call SaveReal(UDGht,hd02,6,speed)
    call SaveReal(UDGht,hd02,7,n)
    call SaveReal(UDGht,hd02,8,d2)
    call SaveReal(UDGht,hd02,9,a)
    call SaveUnitHandle(UDGht,hd02,10,u)
    if (mjt>0) then
        call SaveUnitHandle(UDGht,hd02,11,mj)
    endif
    call SaveGroupHandle(UDGht,hd02,12,g)
    call SaveStr(UDGht,hd02,13,order)
    call SaveInteger(UDGht,hd02,14,mjt)

    set mj = null
    set u = null
    set g = null
    set gs = null
    set eff = null
    set efftimer = null
endfunction

function DYCImpaleLinear takes unit u, real dmg, real d, real r, real x0, real y0, real speed, real a, player pl, integer skl, integer sk, integer mjt, string order returns nothing
    local timer timer1=CreateTimer()
    local timer timer2=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer hd02=GetHandleId(timer2)
    local unit mj
    local group g=CreateGroup()
    local real n=0
    local real d2=0

    if (mjt>0) then
        set mj=CreateUnit( pl, mjt, x0, y0, 0 )
        call ShowUnit( mj, false )
        call UnitAddAbility( mj, sk )
        call SetUnitAbilityLevel(mj,sk,skl)
        call SaveUnitHandle(UDGht,hd01,1,mj)
        call TimerStart(timer1, d/speed+1.2, false, function SysImpaleTimer1)
    endif

    call SaveReal(UDGht,hd02,1,dmg)
    call SaveReal(UDGht,hd02,2,d)
    call SaveReal(UDGht,hd02,3,r)
    call SaveReal(UDGht,hd02,4,x0)
    call SaveReal(UDGht,hd02,5,y0)
    call SaveReal(UDGht,hd02,6,speed)
    call SaveReal(UDGht,hd02,7,n)
    call SaveReal(UDGht,hd02,8,d2)
    call SaveReal(UDGht,hd02,9,a)
    call SaveUnitHandle(UDGht,hd02,10,u)
    if (mjt>0) then
        call SaveUnitHandle(UDGht,hd02,11,mj)
    endif
    call SaveGroupHandle(UDGht,hd02,12,g)
    call SaveStr(UDGht,hd02,13,order)
    call SaveInteger(UDGht,hd02,14,mjt)
    call TimerStart(timer2, 0.02, true, function SysImpaleTimer2)

    set u = null
    set g = null
    set mj = null
    set pl=null
    set timer1 = null
    set timer2 = null

endfunction

function DYCImpaleLinearSimple takes unit u, real dmg, real d, real r, real x0, real y0, real speed, real a returns nothing
	// Extend by XYWE 2016-10-4 00:40:54

	// Ignore
		// player pl    -> 马甲所属玩家
		// integer skl  -> 马甲技能等级
		// integer sk   -> 马甲技能类型
		// integer mjt  -> 马甲类型
		// string order -> 马甲对被穿刺单位发布的命令
	call DYCImpaleLinear(u, dmg, d, r, x0, y0, speed, a, Player(0), 1, 'Aply', 0, "")
endfunction
endlibrary






library DYCImpaleSector requires DYCbase, DYCleap, DYCUPause



/////////////////////////////DYC Impale Sector///////////////////////////////////////////

globals
    private unit TempU
    private unit TempMJ
    private group TempG
    private real TempDMG
    private string TempOrder
    private real TempA2
    private real TempAr
    private real TempR
    private real TempRr
    private real TempDd
    private real TempX1
    private real TempY1
    private real TempX2
    private real TempY2
    private real TempA
    private real TempD
    private real TempD1
    private real TempD2
    private integer loopa
    private integer loopam
endglobals



function SysImpaleSecTimer4 takes nothing returns nothing

    local integer hd = GetHandleId(GetExpiredTimer())
    local unit u = LoadUnitHandle( UDGht, hd, 1)
    local unit mj = LoadUnitHandle( UDGht, hd, 2)
    local unit su = LoadUnitHandle( UDGht, hd, 3)
    local real dmg = LoadReal(UDGht,hd,4)
    local string order = LoadStr(UDGht,hd,5)

    call IssueTargetOrder(mj,order,su)
    call SaveInteger(UDGht,GetHandleId(su),StringHash("SystemUImpaledj"),1)
    call UnitDamageTarget(u,su,dmg,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
    call SaveInteger(UDGht,GetHandleId(su),StringHash("SystemUImpaledj"),0)

    set u = null
    set mj = null
    set su = null
    call DestroyTimer(GetExpiredTimer())
endfunction

function SysImpaleSecGroup takes nothing returns nothing
    local timer timer4
    local integer hd

    set TempA=Atan2BJ(GetUnitY(GetEnumUnit())-GetUnitY(TempMJ),GetUnitX(GetEnumUnit())-GetUnitX(TempMJ))
    set TempD=SquareRoot(Pow((GetUnitX(GetEnumUnit())-GetUnitX(TempMJ)),2)+Pow((GetUnitY(GetEnumUnit())-GetUnitY(TempMJ)),2))
    set TempD1=SquareRoot(Pow((GetUnitX(GetEnumUnit())-TempX1),2)+Pow((GetUnitY(GetEnumUnit())-TempY1),2))
    set TempD2=SquareRoot(Pow((GetUnitX(GetEnumUnit())-TempX2),2)+Pow((GetUnitY(GetEnumUnit())-TempY2),2))
    if ((IsUnitType(GetEnumUnit(),UNIT_TYPE_STRUCTURE)==false)and(IsUnitType(GetEnumUnit(),UNIT_TYPE_MAGIC_IMMUNE)==false)and(IsUnitType(GetEnumUnit(),UNIT_TYPE_MECHANICAL)==false)and(IsUnitType(GetEnumUnit(),UNIT_TYPE_DEAD)==false)and(GetUnitAbilityLevel(GetEnumUnit(),'Aloc')==0)and(GetUnitAbilityLevel(GetEnumUnit(),'Avul')==0)and(IsUnitEnemy(GetEnumUnit(),GetOwningPlayer(TempU))==true)and(GetUnitDefaultMoveSpeed(GetEnumUnit())>0.00)and(IsUnitInGroup(GetEnumUnit(),TempG)==false))and(TempD>=TempDd-(TempR+TempRr))and((CosBJ(TempAr-TempA)>=CosBJ(TempA2/2))or(TempD1<=TempR)or(TempD2<=TempR)) then
        call GroupAddUnit(TempG,GetEnumUnit())
        call DYCleap(GetEnumUnit(),450,0,0.6,0,false,false)
        call DYCUPause(GetEnumUnit(),0.6,1)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\Impale\\ImpaleHitTarget.mdl", GetUnitX(GetEnumUnit())-20, GetUnitY(GetEnumUnit())-20))

        set timer4=CreateTimer()
        set hd=GetHandleId(timer4)
        call SaveUnitHandle( UDGht, hd, 1, TempU )
        call SaveUnitHandle( UDGht, hd, 2, TempMJ )
        call SaveUnitHandle( UDGht, hd, 3, GetEnumUnit() )
        call SaveReal( UDGht, hd, 4, TempDMG )
        call SaveStr( UDGht, hd, 5, TempOrder)
        call TimerStart(timer4, 0.6, false, function SysImpaleSecTimer4)
    endif

    set timer4=null
endfunction

function SysImpaleSecTimer1 takes nothing returns nothing
    local integer hd = GetHandleId(GetExpiredTimer())
    local unit mj = LoadUnitHandle(UDGht,hd,1)
    call RemoveUnit(mj)
    set mj = null
    call DestroyTimer(GetExpiredTimer())
endfunction

function SysImpaleSecTimer3 takes nothing returns nothing
    local integer hd = GetHandleId(GetExpiredTimer())
    local effect eff = LoadEffectHandle( UDGht, hd, 1)
    call DestroyEffect(eff)
    set eff = null
    call DestroyTimer(GetExpiredTimer())
endfunction

function SysImpaleSecTimer2 takes nothing returns nothing
    local integer hd02 = GetHandleId(GetExpiredTimer())
    local real dmg=LoadReal(UDGht,hd02,1)
    local real d=LoadReal(UDGht,hd02,2)
    local real r=LoadReal(UDGht,hd02,3)
    local real x0=LoadReal(UDGht,hd02,4)
    local real y0=LoadReal(UDGht,hd02,5)
    local real speed=LoadReal(UDGht,hd02,6)
    local real n=LoadReal(UDGht,hd02,7)
    local real d2=LoadReal(UDGht,hd02,8)
    local real a=LoadReal(UDGht,hd02,9)
    local unit u=LoadUnitHandle(UDGht,hd02,10)
    local unit mj=LoadUnitHandle(UDGht,hd02,11)
    local group g=LoadGroupHandle(UDGht,hd02,12)
    local string order=LoadStr(UDGht,hd02,13)
    local integer mjt=LoadInteger(UDGht,hd02,14)
    local real a2=LoadReal(UDGht,hd02,15)
    local real rr=LoadReal(UDGht,hd02,16)
    local group gs
    local real dd
    local real x
    local real y
    local real x1
    local real y1
    local real x2
    local real y2
    local effect eff
    local timer efftimer
    local integer hd
    local real loopr
    local real atemp

    set n=n+0.03
    set d2=d2+speed*0.03
    set dd=n*speed
    set x1=x0+dd*CosBJ(a+a2/2)
    set y1=y0+dd*SinBJ(a+a2/2)
    set x2=x0+dd*CosBJ(a-a2/2)
    set y2=y0+dd*SinBJ(a-a2/2)
    if (d2>=200) then
        set d2=0
        set loopr=a2/10
        if (I2R(R2I(loopr))==loopr) then
            set loopr=loopr+1
        endif
        set loopa=1
        set loopam=R2I(loopr)
        loop
            exitwhen loopa>loopam
                set atemp=a-10-a2/2+10*I2R(loopa)
                set x=x0+dd*CosBJ(atemp)
                set y=y0+dd*SinBJ(atemp)
                set efftimer=CreateTimer()
                set hd=GetHandleId(efftimer)
                set eff=AddSpecialEffect("Abilities\\Spells\\Undead\\Impale\\ImpaleMissTarget.mdl", x-20, y-20)
                call SaveEffectHandle(UDGht,hd,1,eff)
                call TimerStart(efftimer,1,false,function SysImpaleSecTimer3)
            set loopa=loopa+1
        endloop
    endif
    set gs=CreateGroup()
    call GroupEnumUnitsInRange(gs,x0,y0,dd+r,null)
    set TempG=g
    set TempU=u
    set TempDMG=dmg
    set TempMJ=mj
    set TempOrder=order
    set TempA2=a2
    set TempAr=a
    set TempR=r
    set TempRr=rr
    set TempDd=dd
    set TempX1=x1
    set TempY1=y1
    set TempX2=x2
    set TempY2=y2
    call ForGroup(gs, function SysImpaleSecGroup)
    call DestroyGroup(gs)
    if (dd>=d) then
        call DestroyGroup(g)
        call DestroyTimer(GetExpiredTimer())
    endif

    call SaveReal(UDGht,hd02,1,dmg)
    call SaveReal(UDGht,hd02,2,d)
    call SaveReal(UDGht,hd02,3,r)
    call SaveReal(UDGht,hd02,4,x0)
    call SaveReal(UDGht,hd02,5,y0)
    call SaveReal(UDGht,hd02,6,speed)
    call SaveReal(UDGht,hd02,7,n)
    call SaveReal(UDGht,hd02,8,d2)
    call SaveReal(UDGht,hd02,9,a)
    call SaveUnitHandle(UDGht,hd02,10,u)
    if (mjt>0) then
        call SaveUnitHandle(UDGht,hd02,11,mj)
    endif
    call SaveGroupHandle(UDGht,hd02,12,g)
    call SaveStr(UDGht,hd02,13,order)
    call SaveInteger(UDGht,hd02,14,mjt)
    call SaveReal(UDGht,hd02,15,a2)
    call SaveReal(UDGht,hd02,16,rr)

    set mj = null
    set u = null
    set g = null
    set gs = null
    set eff = null
    set efftimer = null
endfunction

function DYCImpaleSector takes unit u, real dmg, real d, real r, real x0, real y0, real speed, real a, real a2, player pl, integer skl, integer sk, integer mjt, string order returns nothing

    local timer timer1=CreateTimer()
    local timer timer2=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer hd02=GetHandleId(timer2)
    local unit mj
    local group g=CreateGroup()
    local real n=0
    local real d2=0
    local real rr

    if (a2<0) then
        set a2=1
    endif
    if (a2>360) then
        set a2=360
    endif
    if (mjt>0) then
        set mj=CreateUnit( pl, mjt, x0, y0, 0 )
        call ShowUnit( mj, false )
        call UnitAddAbility( mj, sk )
        call SetUnitAbilityLevel(mj,sk,skl)
        call SaveUnitHandle(UDGht,hd01,1,mj)
        call TimerStart(timer1, d/speed+1.2, false, function SysImpaleSecTimer1)
    endif
    if (speed*0.03>=r*2) then
        set rr=speed*0.03-r*2
    else
        set rr=0
    endif

    call SaveReal(UDGht,hd02,1,dmg)
    call SaveReal(UDGht,hd02,2,d)
    call SaveReal(UDGht,hd02,3,r)
    call SaveReal(UDGht,hd02,4,x0)
    call SaveReal(UDGht,hd02,5,y0)
    call SaveReal(UDGht,hd02,6,speed)
    call SaveReal(UDGht,hd02,7,n)
    call SaveReal(UDGht,hd02,8,d2)
    call SaveReal(UDGht,hd02,9,a)
    call SaveUnitHandle(UDGht,hd02,10,u)
    if (mjt>0) then
        call SaveUnitHandle(UDGht,hd02,11,mj)
    endif
    call SaveGroupHandle(UDGht,hd02,12,g)
    call SaveStr(UDGht,hd02,13,order)
    call SaveInteger(UDGht,hd02,14,mjt)
    call SaveReal(UDGht,hd02,15,a2)
    call SaveReal(UDGht,hd02,16,rr)
    call TimerStart(timer2, 0.03, true, function SysImpaleSecTimer2)

    set u = null
    set g = null
    set mj = null
    set pl=null
    set timer1 = null
    set timer2 = null

endfunction


function DYCImpaleSectorSimple takes unit u, real dmg, real d, real r, real x0, real y0, real speed, real a, real a2 returns nothing
	// Extend by XYWE 2016-10-4 00:59:00

	// Ignore
		// player pl    -> 马甲所属玩家
		// integer skl  -> 马甲技能等级
		// integer sk   -> 马甲技能类型
		// integer mjt  -> 马甲类型
		// string order -> 马甲对被穿刺单位发布的命令
	call DYCImpaleSector(u, dmg, d, r, x0, y0, speed, a, a2, Player(0), 1, 'Aply', 0, "")
endfunction
endlibrary

#endif
