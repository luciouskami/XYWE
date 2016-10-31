#ifndef DYCbarsimIncluded
#define DYCbarsimIncluded

#include "DYCUI/DYCbase.j"




library DYCbarsim requires DYCbase

globals

    private integer loopa
    private integer loopam
endglobals



function SysbarsimTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local texttag bar=LoadTextTagHandle(UDGht,hd01,2)
    local integer hd=GetHandleId(u)
    local integer j=LoadInteger(UDGht,hd,StringHash("barsimj"))
    local integer sn=LoadInteger(UDGht,hd,StringHash("barsimsn"))
    local integer p=LoadInteger(UDGht,hd,StringHash("barsimp"))
    local integer max=LoadInteger(UDGht,hd,StringHash("barsimmax"))
    local real h=LoadReal(UDGht,hd,StringHash("barsimh"))
    local real fs=LoadReal(UDGht,hd,StringHash("barsimfs"))
    local string str=LoadStr(UDGht,hd,StringHash("barsimstr"))
    local string c1=LoadStr(UDGht,hd,StringHash("barsimc1"))
    local string c2=LoadStr(UDGht,hd,StringHash("barsimc2"))
    local boolean show1=LoadBoolean(UDGht,hd,StringHash("barsimshow1"))
    local real xf=LoadReal(UDGht,hd,StringHash("barsimxf"))
    local real yf=LoadReal(UDGht,hd,StringHash("barsimyf"))
    local string tx

    set tx=""
    if (p>=max/sn) then
        set loopa=1
        set loopam=p/(max/sn)
        loop
            exitwhen loopa>loopam
                set tx=tx+c1+str
            set loopa=loopa+1
        endloop
        set loopa=1
        set loopam=sn-p/(max/sn)
        loop
            exitwhen loopa>loopam
                set tx=tx+c2+str
            set loopa=loopa+1
        endloop
    else
        set loopa=1
        set loopam=sn
        loop
            exitwhen loopa>loopam
                set tx=tx+c2+str
            set loopa=loopa+1
        endloop
    endif
    call SetTextTagPos(bar,GetUnitX(u)+(-8*50*fs)*I2R(sn)+xf,GetUnitY(u)+yf,h+GetUnitFlyHeight(u))
    call SetTextTagText(bar,tx,fs)
    if (GetLocalPlayer()==GetOwningPlayer(u))or(show1==false) then
        if ((IsUnitType(u,UNIT_TYPE_DEAD)==true)) then
            call SetTextTagVisibility(bar,false)
        else
            call SetTextTagVisibility(bar,true)
        endif
    else
        call SetTextTagVisibility(bar,false)
    endif

    if (j==0) then
        call SetTextTagPermanent(bar,false)
        call SetTextTagLifespan(bar,0.01)
        call DestroyTimer(GetExpiredTimer())
    endif

    set u=null
    set bar=null

endfunction


function DYCbarsim takes unit u, integer sn, integer p, integer max, real h, real fs, string str, string c1, string c2, boolean show1, real xf, real yf returns nothing

    local timer timer1
    local integer hd01
    local integer hd=GetHandleId(u)
    local integer j=LoadInteger(UDGht,hd,StringHash("barsimj"))
    local texttag bar

    if (sn<=0) then
        set sn=5
    endif
    if (p<=0) then
        set p=1
    endif
    if (max<=0) then
        set max=5
    endif
    call SaveInteger(UDGht,hd,StringHash("barsimsn"),sn)
    call SaveInteger(UDGht,hd,StringHash("barsimp"),p)
    call SaveInteger(UDGht,hd,StringHash("barsimmax"),max)
    call SaveReal(UDGht,hd,StringHash("barsimh"),h)
    call SaveReal(UDGht,hd,StringHash("barsimfs"),fs)
    call SaveStr(UDGht,hd,StringHash("barsimstr"),str)
    call SaveStr(UDGht,hd,StringHash("barsimc1"),c1)
    call SaveStr(UDGht,hd,StringHash("barsimc2"),c2)
    call SaveBoolean(UDGht,hd,StringHash("barsimshow1"),show1)
    call SaveReal(UDGht,hd,StringHash("barsimxf"),xf)
    call SaveReal(UDGht,hd,StringHash("barsimyf"),yf)

    if (j==1) then
        //do nothing
    else
        set j=1
        set timer1=CreateTimer()
        set hd01=GetHandleId(timer1)
        call SaveInteger(UDGht,hd,StringHash("barsimj"),j)
        set bar=CreateTextTag()
        call SetTextTagVisibility(bar,false)
        call SetTextTagPermanent(bar,true)
        call SaveUnitHandle(UDGht,hd01,1,u)
        call SaveTextTagHandle(UDGht,hd01,2,bar)
        call TimerStart(timer1,0.02,true,function SysbarsimTimer1)
    endif

    set timer1=null
    set u=null
    set bar=null

endfunction

endlibrary





#endif /// DYCbarsim
