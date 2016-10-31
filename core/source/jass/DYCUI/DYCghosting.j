#ifndef DYCghostingIncluded
#define DYCghostingIncluded

#include "DYCUI/DYCbase.j"

library DYCghosting requires DYCbase
//ghosting animation


function SysghostingTimer2 takes nothing returns nothing

    local integer hd02=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd02,1)
    local integer hd=GetHandleId(u)
    local unit mj=LoadUnitHandle(UDGht,hd02,2)
    local real ms=LoadReal(UDGht,hd02,3)
    local real nn=LoadReal(UDGht,hd02,4)
    local real nnn=LoadReal(UDGht,hd02,5)
    local real t=LoadReal(UDGht,hd02,6)
    local real xf=LoadReal(UDGht,hd02,7)
    local real yf=LoadReal(UDGht,hd02,8)
    local real h0=LoadReal(UDGht,hd02,9)
    local real xi
    local real yi
    local real x
    local real y
    local real d
    local integer upausec = LoadInteger(UDGht,hd,StringHash("systemupausec"))
    local integer upauseac = LoadInteger(UDGht,hd,StringHash("systemupauseac"))

    if (upausec==0)or(upauseac==0) then
        call PauseUnit( mj, false )
        call SetUnitTimeScale( mj, 1 )
        set nnn=nnn+0.02
        set nn=nn+0.02
        set xi=GetUnitX(mj)
        set yi=GetUnitY(mj)
        set x=GetUnitX(u)
        set y=GetUnitY(u)
        set d=SquareRoot(Pow((x-xi),2)+Pow((y-yi),2))
        if (nnn>=0.15)and(d>=10) then
            set nnn=0
            call IssuePointOrder(mj,"move",x+xf,y+yf)
        endif
        if (d<=10) then
            call SetUnitFacing(mj,GetUnitFacing(u))
            call IssueImmediateOrder(mj,"stop")
        endif
        call SetUnitMoveSpeed(mj,ms*0.5-ms*nn*0.5/t)
        call SetUnitVertexColorBJ(mj,100,100,100,nn*100/t)
        call SetUnitFlyHeight(mj,h0,500-nn*500/t)
    else
        call PauseUnit( mj, true )
        call SetUnitTimeScale( mj, 0 )
    endif

    if (nn>=t) then
        call RemoveUnit(mj)
        call DestroyTimer(GetExpiredTimer())
    endif

    call SaveUnitHandle(UDGht,hd02,1,u)
    call SaveUnitHandle(UDGht,hd02,2,mj)
    call SaveReal(UDGht,hd02,3,ms)
    call SaveReal(UDGht,hd02,4,nn)
    call SaveReal(UDGht,hd02,5,nnn)
    call SaveReal(UDGht,hd02,6,t)

    set u=null
    set mj=null

endfunction


function SysghostingTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local integer hd=GetHandleId(u)
    local integer j=LoadInteger(UDGht,hd,StringHash("ghostingj"))
    local real x0=LoadReal(UDGht,hd01,2)
    local real y0=LoadReal(UDGht,hd01,3)
    local real x1=LoadReal(UDGht,hd01,4)
    local real y1=LoadReal(UDGht,hd01,5)
    local real n=LoadReal(UDGht,hd01,6)
    local real n2=LoadReal(UDGht,hd01,7)
    local integer mjt=LoadInteger(UDGht,hd01,8)
    local player pl=LoadPlayerHandle(UDGht,hd01,9)
    local real xf=LoadReal(UDGht,hd01,10)
    local real yf=LoadReal(UDGht,hd01,11)
    local real h0=LoadReal(UDGht,hd01,12)
    local real h1=LoadReal(UDGht,hd01,13)
    local real int=LoadReal(UDGht,hd,StringHash("ghostingint"))
    local real t=LoadReal(UDGht,hd,StringHash("ghostingt"))
    local real a
    local real d
    local real ms0=GetUnitMoveSpeed(u)
    local real ms
    local unit mj
    local timer timer2
    local integer hd02

    set n=n+0.02
    set n2=n2+0.02
    set x0=x1
    set y0=y1
    set x1=GetUnitX(u)
    set y1=GetUnitY(u)
    set h0=h1
    set h1=GetUnitFlyHeight(u)
    set d=SquareRoot(Pow((x0-x1),2)+Pow((y0-y1),2))
    set ms=d/0.02
    set a=Atan2(y1-y0,x1-x0)
    if ( ((d<=3000*0.02)and(d>ms0*0.8*0.02)) or RAbsBJ(h0-h1)>10 )and(n2>=int)and(j!=0) then
        set n2=0
        set mj=CreateUnit(pl,mjt,x1,y1,GetUnitFacing(u))
        call UnitAddAbility(mj,'Aloc')
        call UnitAddAbility(mj,'Arav')
        call UnitRemoveAbility(mj,'Arav')
        call SetUnitFlyHeight(mj,GetUnitFlyHeight(u),9999999)
        call SetUnitPathing(mj,false)
        call SetUnitX(mj,x1+xf)
        call SetUnitY(mj,y1+yf)
        call SetUnitMoveSpeed(mj,ms)
        set timer2=CreateTimer()
        set hd02=GetHandleId(timer2)
        call SaveUnitHandle(UDGht,hd02,1,u)
        call SaveUnitHandle(UDGht,hd02,2,mj)
        call SaveReal(UDGht,hd02,3,ms)
        call SaveReal(UDGht,hd02,4,0)
        call SaveReal(UDGht,hd02,5,0)
        call SaveReal(UDGht,hd02,6,t)
        call SaveReal(UDGht,hd02,7,xf)
        call SaveReal(UDGht,hd02,8,yf)
        call SaveReal(UDGht,hd02,9,GetUnitFlyHeight(u))
        call TimerStart(timer2,0.02,true,function SysghostingTimer2)
    endif

    call SaveUnitHandle(UDGht,hd01,1,u)
    call SaveReal(UDGht,hd01,2,x0)
    call SaveReal(UDGht,hd01,3,y0)
    call SaveReal(UDGht,hd01,4,x1)
    call SaveReal(UDGht,hd01,5,y1)
    call SaveReal(UDGht,hd01,6,n)
    call SaveReal(UDGht,hd01,7,n2)
    call SaveInteger(UDGht,hd01,8,mjt)
    call SavePlayerHandle(UDGht,hd01,9,pl)
    call SaveReal(UDGht,hd01,12,h0)
    call SaveReal(UDGht,hd01,13,h1)

    if (j==0) then
        call DestroyTimer(GetExpiredTimer())
    endif

    set u=null
    set mj=null
    set pl=null
    set timer2=null

endfunction


function DYCghosting takes unit u, real int, real t, integer mjt, player pl, real xf, real yf returns nothing

    local timer timer1
    local integer hd01
    local integer hd=GetHandleId(u)
    local integer j=LoadInteger(UDGht,hd,StringHash("ghostingj"))

    if (int<=0) then
        set int=0.1
    endif
    call SaveReal(UDGht,hd,StringHash("ghostingint"),int)
    if (t<=0) then
        set t=0.5
    endif
    call SaveReal(UDGht,hd,StringHash("ghostingt"),t)
    if (j==1) then
        //Do Nothing
    else
        set j=1
        set timer1=CreateTimer()
        set hd01=GetHandleId(timer1)
        call SaveInteger(UDGht,hd,StringHash("ghostingj"),j)
        call SaveUnitHandle(UDGht,hd01,1,u)
        call SaveReal(UDGht,hd01,2,GetUnitX(u))
        call SaveReal(UDGht,hd01,3,GetUnitY(u))
        call SaveReal(UDGht,hd01,4,GetUnitX(u))
        call SaveReal(UDGht,hd01,5,GetUnitY(u))
        call SaveReal(UDGht,hd01,6,0)
        call SaveReal(UDGht,hd01,7,0)
        call SaveInteger(UDGht,hd01,8,mjt)
        call SavePlayerHandle(UDGht,hd01,9,pl)
        call SaveReal(UDGht,hd01,10,xf)
        call SaveReal(UDGht,hd01,11,yf)
        call SaveReal(UDGht,hd01,12,GetUnitFlyHeight(u))
        call SaveReal(UDGht,hd01,13,GetUnitFlyHeight(u))
        call TimerStart(timer1,0.02,true,function SysghostingTimer1)
    endif

    set u=null
    set pl=null
    set timer1=null

endfunction

endlibrary





#endif /// DYCghosting
