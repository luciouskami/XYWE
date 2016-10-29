#ifndef DYCdmgdisplayIncluded
#define DYCdmgdisplayIncluded

#include "DYCUI/DYCbase.j"
#include "DYCUI/DYCTriggerEvent.j"

library DYCdmgdisplay requires DYCbase, DYCTriggerEvent



function SysdmgdTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local unit du=LoadUnitHandle(UDGht,hd01,2)
    local integer hd=GetHandleId(u)
    local real x0=LoadReal(UDGht,hd,StringHash("systemdmgdx0"))
    local real y0=LoadReal(UDGht,hd,StringHash("systemdmgdy0"))
    local real h=LoadReal(UDGht,hd,StringHash("systemdmgdh"))
    local real fs=LoadReal(UDGht,hd,StringHash("systemdmgdfs"))
    local real t=LoadReal(UDGht,hd,StringHash("systemdmgdt"))
    local real spd=LoadReal(UDGht,hd,StringHash("systemdmgdspd"))
    local real a=LoadReal(UDGht,hd,StringHash("systemdmgda"))
    local string str1=LoadStr(UDGht,hd,StringHash("systemdmgdstr1"))
    local string str2=LoadStr(UDGht,hd,StringHash("systemdmgdstr2"))
    local boolean bool1=LoadBoolean(UDGht,hd,StringHash("systemdmgdbool1"))
    local boolean bool2=LoadBoolean(UDGht,hd,StringHash("systemdmgdbool2"))
    local boolean bool3=LoadBoolean(UDGht,hd,StringHash("systemdmgdbool3"))
    local texttag tag=CreateTextTag()
    local real dmg=LoadReal(UDGht,hd,StringHash("systemdmgtaken"))
    local real dodge=LoadReal(UDGht,hd,StringHash("systemdmgdodged"))

    set dmg=dmg-dodge
    if (dmg<0) then
        set dmg=0
    endif

    set bj_DYCUnit1=du
    set bj_DYCUnit2=u
    set bj_DYCReal1=dmg
    set bj_DYCTJudge=4
    call DYCAnyUnitTrigger()

    call SetTextTagPos(tag,x0,y0,h)
    call SetTextTagText(tag,str1+I2S(R2I(dmg))+str2,fs)
    call SetTextTagPermanent(tag,false)
    call SetTextTagVelocityBJ(tag,spd,a)
    call SetTextTagLifespan(tag,t)
    call SetTextTagFadepoint(tag,0.4*t)
    if (IsUnitVisible(u,GetLocalPlayer())==true)and((bool3==true)or((bool1==true)and(GetOwningPlayer(u)==GetLocalPlayer()))or((bool2==true)and(GetOwningPlayer(du)==GetLocalPlayer()))) then
        call SetTextTagVisibility(tag,true)
    else
        call SetTextTagVisibility(tag,false)
    endif
    call SaveInteger(UDGht,hd,StringHash("systemdmgdj"),0)
    call SaveReal(UDGht,hd,StringHash("systemdmgtaken"),0)
    call SaveReal(UDGht,hd,StringHash("systemdmgdodged"),0)
    call DestroyTimer(GetExpiredTimer())

    set tag=null
    set u=null
    set du=null

endfunction

function DYCdmgdisplay takes real x0, real y0, real h, real fs, real t, real spd, real a, string str1, string str2, boolean bool1, boolean bool2, boolean bool3 returns nothing

    local timer timer1
    local integer hd01
    local unit u=GetTriggerUnit()
    local unit du=GetEventDamageSource()
    local integer hd=GetHandleId(u)
    local real dmg0=GetEventDamage()

    call SaveReal(UDGht,hd,StringHash("systemdmgtaken"),dmg0+LoadReal(UDGht,hd,StringHash("systemdmgtaken")))
    call SaveReal(UDGht,hd,StringHash("systemdmgdx0"),x0)
    call SaveReal(UDGht,hd,StringHash("systemdmgdy0"),y0)
    call SaveReal(UDGht,hd,StringHash("systemdmgdh"),h)
    call SaveReal(UDGht,hd,StringHash("systemdmgdfs"),fs)
    call SaveReal(UDGht,hd,StringHash("systemdmgdt"),t)
    call SaveReal(UDGht,hd,StringHash("systemdmgdspd"),spd)
    call SaveReal(UDGht,hd,StringHash("systemdmgda"),a)
    call SaveStr(UDGht,hd,StringHash("systemdmgdstr1"),str1)
    call SaveStr(UDGht,hd,StringHash("systemdmgdstr2"),str2)
    call SaveBoolean(UDGht,hd,StringHash("systemdmgdbool1"),bool1)
    call SaveBoolean(UDGht,hd,StringHash("systemdmgdbool2"),bool2)
    call SaveBoolean(UDGht,hd,StringHash("systemdmgdbool3"),bool3)
    if (LoadInteger(UDGht,hd,StringHash("systemdmgdj"))==0) then
        set timer1=CreateTimer()
        set hd01=GetHandleId(timer1)
        call SaveUnitHandle(UDGht,hd01,1,u)
        call SaveUnitHandle(UDGht,hd01,2,du)
        call TimerStart(timer1,0.011,false,function SysdmgdTimer1)
    endif
    call SaveInteger(UDGht,hd,StringHash("systemdmgdj"),1)

    set timer1=null
    set u=null
    set du=null

endfunction

endlibrary



#endif /// DYCdmgdisplay
