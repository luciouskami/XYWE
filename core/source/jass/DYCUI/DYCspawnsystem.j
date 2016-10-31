#ifndef DYCspawnsystemIncluded
#define DYCspawnsystemIncluded

#include "DYCUI/DYCbase.j"

library DYCspawnsystem requires DYCbase

globals
    timer dyc_LastSpawnTimer
    private timer timer0

endglobals


private function SysSpawnSystemTimer3 takes nothing returns nothing
    local integer hd=GetHandleId(GetExpiredTimer())
    call DestroyEffect(LoadEffectHandle(UDGht,hd,1))
    call DestroyTimer(GetExpiredTimer())
endfunction


private function AddEff takes real t, string effmodel, unit u, string effatt returns nothing
    local timer timer0
    local integer hd
    if (effmodel==null) or (effmodel=="") or (effmodel==" ") then
        return
    endif
    if(t<=0) then
        call DestroyEffect(AddSpecialEffectTarget(effmodel,u,effatt))
    else
        set timer0=CreateTimer()
        set hd=GetHandleId(timer0)
        call SaveEffectHandle(UDGht,hd,1,AddSpecialEffectTarget(effmodel,u,effatt))
        call TimerStart(timer0,t,false,function SysSpawnSystemTimer3)
    endif
    set timer0=null
endfunction





function SysSpawnSystemTimer2 takes nothing returns nothing

    local integer hd2 = GetHandleId(GetExpiredTimer())
    local real n = LoadReal(UDGht,hd2,0)
    local integer hd = LoadInteger(UDGht,hd2,1)
    local integer type1nl = LoadInteger(UDGht,hd2,2)
    local integer type2nl = LoadInteger(UDGht,hd2,3)
    local integer type3nl = LoadInteger(UDGht,hd2,4)
    local integer type4nl = LoadInteger(UDGht,hd2,5)
    local player pl = LoadPlayerHandle(UDGht,hd,0)
    local real x0 = LoadReal(UDGht,hd,1)
    local real y0 = LoadReal(UDGht,hd,2)
    local real xt = LoadReal(UDGht,hd,3)
    local real yt = LoadReal(UDGht,hd,4)
    local real intb2u = LoadReal(UDGht,hd,6)
    local boolean brt = LoadBoolean(UDGht,hd,8)
    local real angle = LoadReal(UDGht,hd,10)
    local real efft = LoadReal(UDGht,hd,12)
    local string effmodel = LoadStr(UDGht,hd,13)
    local string effatt = LoadStr(UDGht,hd,14)
    local integer type1 = LoadInteger(UDGht,hd,111)
    local integer type1n = LoadInteger(UDGht,hd,112)
    local integer type2 = LoadInteger(UDGht,hd,121)
    local integer type2n = LoadInteger(UDGht,hd,122)
    local integer type3 = LoadInteger(UDGht,hd,131)
    local integer type3n = LoadInteger(UDGht,hd,132)
    local integer type4 = LoadInteger(UDGht,hd,141)
    local integer type4n = LoadInteger(UDGht,hd,142)
    local integer ran
    local unit u
    //local integer i
    local integer eloop=0

    set n=n+0.02
    if (n>=intb2u) then
        set n=0
        if (brt) then
            //random type
            //set i=1

            loop
                //exitwhen (i>100) or ()
                exitwhen eloop==1
                set ran=GetRandomInt(1,4)
                if (ran==1) and (type1nl>0) then
                    set u = CreateUnit(pl, type1, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                    set type1nl=type1nl-1
                    set eloop=1
                endif
                if (ran==2) and (type2nl>0) then
                    set u = CreateUnit(pl, type2, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                    set type2nl=type2nl-1
                    set eloop=1
                endif
                if (ran==3) and (type3nl>0) then
                    set u = CreateUnit(pl, type3, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                    set type3nl=type3nl-1
                    set eloop=1
                endif
                if (ran==4) and (type4nl>0) then
                    set u = CreateUnit(pl, type4, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                    set type4nl=type4nl-1
                    set eloop=1
                endif
                if (type1nl<=0) and (type2nl<=0) and (type3nl<=0) and (type4nl<=0) then
                    set eloop=1
                endif
                //set i=i+1
            endloop
            if (type1nl<=0) and (type2nl<=0) and (type3nl<=0) and (type4nl<=0) then
                call DestroyTimer(GetExpiredTimer())
            endif
        else
            //no random type
            if (type1nl>0) then
                set u = CreateUnit(pl, type1, x0, y0, angle)
                call IssuePointOrderById( u, 851983, xt, yt )
                call AddEff(efft,effmodel,u,effatt)
                set type1nl=type1nl-1
            else
                if (type2nl>0) then
                    set u = CreateUnit(pl, type2, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                    set type2nl=type2nl-1
                else
                    if (type3nl>0) then
                        set u = CreateUnit(pl, type3, x0, y0, angle)
                        call IssuePointOrderById( u, 851983, xt, yt )
                        call AddEff(efft,effmodel,u,effatt)
                        set type3nl=type3nl-1
                    else
                        if (type4nl>0) then
                            set u = CreateUnit(pl, type4, x0, y0, angle)
                            call IssuePointOrderById( u, 851983, xt, yt )
                            call AddEff(efft,effmodel,u,effatt)
                            set type4nl=type4nl-1
                        endif
                    endif
                endif
            endif

            if (type1nl<=0) and (type2nl<=0) and (type3nl<=0) and (type4nl<=0) then
                call DestroyTimer(GetExpiredTimer())
            endif

        endif
    endif

    call SaveReal(UDGht,hd2,0,n)
    call SaveInteger(UDGht,hd2,2,type1nl)
    call SaveInteger(UDGht,hd2,3,type2nl)
    call SaveInteger(UDGht,hd2,4,type3nl)
    call SaveInteger(UDGht,hd2,5,type4nl)

    set u=null

endfunction


function SysSpawnSystemSpawn takes integer hd returns nothing

    local player pl = LoadPlayerHandle(UDGht,hd,0)
    local real x0 = LoadReal(UDGht,hd,1)
    local real y0 = LoadReal(UDGht,hd,2)
    local real xt = LoadReal(UDGht,hd,3)
    local real yt = LoadReal(UDGht,hd,4)
    local real intb2u = LoadReal(UDGht,hd,6)
    local boolean brt = LoadBoolean(UDGht,hd,8)
    local real angle = LoadReal(UDGht,hd,10)
    local integer wave = LoadInteger(UDGht,hd,11)
    local real efft = LoadReal(UDGht,hd,12)
    local string effmodel = LoadStr(UDGht,hd,13)
    local string effatt = LoadStr(UDGht,hd,14)
    local integer type1 = LoadInteger(UDGht,hd,111)
    local integer type1n = LoadInteger(UDGht,hd,112)
    local integer type2 = LoadInteger(UDGht,hd,121)
    local integer type2n = LoadInteger(UDGht,hd,122)
    local integer type3 = LoadInteger(UDGht,hd,131)
    local integer type3n = LoadInteger(UDGht,hd,132)
    local integer type4 = LoadInteger(UDGht,hd,141)
    local integer type4n = LoadInteger(UDGht,hd,142)
    //local real a=Atan2BJ(yt-y0,xt-x0)
    local unit u
    local timer timer1
    local integer hd2
    local integer i=1

    set wave=wave+1
    //call BJDebugMsg(I2S(wave))

    if (intb2u<=0) then

        if (type1>0) then
            set i=1
            loop
                exitwhen i > type1n
                    set u = CreateUnit(pl, type1, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                set i = i + 1
            endloop
        endif
        if (type2>0) then
            set i=1
            loop
                exitwhen i > type2n
                    set u = CreateUnit(pl, type2, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                set i = i + 1
            endloop
        endif
        if (type3>0) then
            set i=1
            loop
                exitwhen i > type3n
                    set u = CreateUnit(pl, type3, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                set i = i + 1
            endloop
        endif
        if (type4>0) then
            set i=1
            loop
                exitwhen i > type4n
                    set u = CreateUnit(pl, type4, x0, y0, angle)
                    call IssuePointOrderById( u, 851983, xt, yt )
                    call AddEff(efft,effmodel,u,effatt)
                set i = i + 1
            endloop
        endif

    else
        set timer1=CreateTimer()
        set hd2=GetHandleId(timer1)
        call SaveReal(UDGht,hd2,0,999999)
        call SaveInteger(UDGht,hd2,1,hd)
        if (type1>0) then
            call SaveInteger(UDGht,hd2,2,type1n)
        else
            call SaveInteger(UDGht,hd2,2,0)
        endif
        if (type2>0) then
            call SaveInteger(UDGht,hd2,3,type2n)
        else
            call SaveInteger(UDGht,hd2,3,0)
        endif
        if (type3>0) then
            call SaveInteger(UDGht,hd2,4,type3n)
        else
            call SaveInteger(UDGht,hd2,4,0)
        endif
        if (type4>0) then
            call SaveInteger(UDGht,hd2,5,type4n)
        else
            call SaveInteger(UDGht,hd2,5,0)
        endif
        call TimerStart(timer1, 0.02, true, function SysSpawnSystemTimer2)
    endif

    call SaveInteger(UDGht,hd,11,wave)

    set u=null
    set timer1=null

endfunction


function SysSpawnSystemTimer takes nothing returns nothing

    local integer hd = GetHandleId(GetExpiredTimer())
    local real int = LoadReal(UDGht,hd,5)
    local real n = LoadReal(UDGht,hd,7)
    local boolean ben = LoadBoolean(UDGht,hd,9)


    if (ben) then
        set n=n+0.02
        if (n>=int) then
            set n=0

            call SysSpawnSystemSpawn(hd)
        endif
    endif

    call SaveReal(UDGht,hd,7,n)


endfunction


function DYCspawnsystemstart takes player pl, real x0, real y0, real xt, real yt, integer type1, integer type1n, integer type2, integer type2n, integer type3, integer type3n, integer type4, integer type4n, real angle, real int, real intb2u, boolean brt, real efft, string effmodel, string effatt returns timer
//brt:random type    ben:enabled      attackmove:851983
    local integer hd

    set timer0 = CreateTimer()
    set hd = GetHandleId(timer0)

    if (int<=1) then
        set int=1
    endif

    call SavePlayerHandle(UDGht,hd,0,pl)
    call SaveReal(UDGht,hd,1,x0)
    call SaveReal(UDGht,hd,2,y0)
    call SaveReal(UDGht,hd,3,xt)
    call SaveReal(UDGht,hd,4,yt)
    call SaveReal(UDGht,hd,5,int)
    call SaveReal(UDGht,hd,6,intb2u)
    call SaveReal(UDGht,hd,7,0)
    call SaveBoolean( UDGht, hd, 8, brt )
    call SaveBoolean( UDGht, hd, 9, true )
    call SaveReal(UDGht,hd,10,angle)
    call SaveInteger(UDGht,hd,11,0)
    call SaveReal(UDGht,hd,12,efft)
    call SaveStr(UDGht,hd,13,effmodel)
    call SaveStr(UDGht,hd,14,effatt)
    call SaveInteger(UDGht,hd,111,type1)
    call SaveInteger(UDGht,hd,112,type1n)
    call SaveInteger(UDGht,hd,121,type2)
    call SaveInteger(UDGht,hd,122,type2n)
    call SaveInteger(UDGht,hd,131,type3)
    call SaveInteger(UDGht,hd,132,type3n)
    call SaveInteger(UDGht,hd,141,type4)
    call SaveInteger(UDGht,hd,142,type4n)
    call TimerStart(timer0, 0.02, true, function SysSpawnSystemTimer)

    call SysSpawnSystemSpawn(hd)

    set dyc_LastSpawnTimer=timer0
    return timer0

endfunction


function DYCspawnsystemend takes timer t returns nothing
    call DestroyTimer(t)
endfunction


endlibrary





#endif /// DYCspawnsystem
