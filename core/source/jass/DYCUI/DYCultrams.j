#ifndef DYCultramsIncluded
#define DYCultramsIncluded

#include "DYCUI/DYCbase.j"

library DYCultrams requires DYCbase
//make unit ms larger than 522




function SysultramsTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local integer hd=GetHandleId(u)
    local real ms=LoadReal(UDGht,hd,StringHash("ultramsms"))
    local integer j=LoadInteger(UDGht,hd,StringHash("ultramsj"))
    local real x0=LoadReal(UDGht,hd01,2)
    local real y0=LoadReal(UDGht,hd01,3)
    local real x1=LoadReal(UDGht,hd01,4)
    local real y1=LoadReal(UDGht,hd01,5)
    local real n=LoadReal(UDGht,hd01,6)
    local real n2=LoadReal(UDGht,hd01,7)
    local real intj=LoadReal(UDGht,hd01,8)
    local real x00=LoadReal(UDGht,hd01,9)
    local real y00=LoadReal(UDGht,hd01,10)
    local real cd=LoadReal(UDGht,hd01,11)
    local real a
    local real a2
    local real d
    local real tempd
    local real ms0=GetUnitMoveSpeed(u)

    set n=n+0.01
    set n2=n2+0.01
    if (n2>=intj) then
        set n2=0
        set x00=x0
        set y00=y0
        set x0=x1
        set y0=y1
        set x1=GetUnitX(u)
        set y1=GetUnitY(u)
        set d=SquareRoot(Pow((x0-x1),2)+Pow((y0-y1),2))
        set a=Atan2(y1-y0,x1-x0)
        //set a2=Atan2(y0-y00,x0-x00)
        set a2=Deg2Rad(GetUnitFacing(u))
        if (Cos(a-a2)<0.9)and(d>ms0*0.8*intj) then
            set cd=cd+1*intj
        endif
        if (cd<=0)or(ms<ms0) then
            set cd=0
            if (d<=550*intj)and(d>ms0*0.8*intj) then
                set tempd=ms*intj-d
                set x1=x1+tempd*Cos(a)
                set y1=y1+tempd*Sin(a)
                if (RectContainsCoords(bj_mapInitialPlayableArea,x1,y1)) then
                    call SetUnitX(u,x1)
                    call SetUnitY(u,y1)
                endif
            endif
        else
            set cd=cd-intj
        endif
    endif

    call SaveUnitHandle(UDGht,hd01,1,u)
    call SaveReal(UDGht,hd01,2,x0)
    call SaveReal(UDGht,hd01,3,y0)
    call SaveReal(UDGht,hd01,4,x1)
    call SaveReal(UDGht,hd01,5,y1)
    call SaveReal(UDGht,hd01,6,n)
    call SaveReal(UDGht,hd01,7,n2)
    call SaveReal(UDGht,hd01,8,intj)
    call SaveReal(UDGht,hd01,9,GetUnitX(u))
    call SaveReal(UDGht,hd01,10,GetUnitY(u))
    call SaveReal(UDGht,hd01,11,cd)

    if (j==0) then
        call DestroyTimer(GetExpiredTimer())
    endif

    set u=null

endfunction


function DYCultrams takes unit u, real speed returns nothing

    local timer timer1=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer hd=GetHandleId(u)
    local integer j=LoadInteger(UDGht,hd,StringHash("ultramsj"))
    local real ms
    local real intj=0.02

    set ms=speed
    if (ms<0) then
        set ms=0
    endif
    call SaveReal(UDGht,hd,StringHash("ultramsms"),ms)
    if (j==1) then
        call DestroyTimer(timer1)
    else
        set j=1
        call SaveInteger(UDGht,hd,StringHash("ultramsj"),j)
        call SaveUnitHandle(UDGht,hd01,1,u)
        call SaveReal(UDGht,hd01,2,GetUnitX(u))
        call SaveReal(UDGht,hd01,3,GetUnitY(u))
        call SaveReal(UDGht,hd01,4,GetUnitX(u))
        call SaveReal(UDGht,hd01,5,GetUnitY(u))
        call SaveReal(UDGht,hd01,6,0)
        call SaveReal(UDGht,hd01,7,0)
        call SaveReal(UDGht,hd01,8,intj)
        call SaveReal(UDGht,hd01,9,GetUnitX(u))
        call SaveReal(UDGht,hd01,10,GetUnitY(u))
        call SaveReal(UDGht,hd01,11,0)
        call TimerStart(timer1,0.01,true,function SysultramsTimer1)
    endif

    set u=null
    set timer1=null

endfunction

endlibrary



#endif /// DYCultrams
