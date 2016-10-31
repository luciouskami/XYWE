#ifndef WMLeakMonitorSystemIncluded
#define WMLeakMonitorSystemIncluded
#include "WM/WMBase.j"
library WMLeakMonitorSystem initializer init
globals
    private integer array data
    private integer time=2
    private integer max=0
    private string array s
    private integer array warn
endglobals
private function round takes nothing returns nothing
    local integer i=data[0]+0x100000
    if WMI2Destructable(i)!=null then
        set data[1]=data[1]+1
    elseif WMI2Item(i)!=null then
        set data[2]=data[2]+1
    elseif WMI2Unit(i)!=null then
        set data[3]=data[3]+1
    elseif WMI2Effect(i)!=null then
        set data[4]=data[4]+1
    elseif WMI2Trigger(i)!=null then
        set data[5]=data[5]+1
    elseif WMI2Timer(i)!=null then
        set data[9]=data[9]+1
    elseif WMI2Group(i)!=null then
        set data[12]=data[12]+1
    elseif WMI2Location(i)!=null then
        set data[16]=data[16]+1
    elseif WMI2Force(i)!=null then
        set data[13]=data[13]+1
    elseif WMI2Rect(i)!=null then
        set data[14]=data[14]+1
    elseif WMI2MultiboardItem(i)!=null then
        set data[11]=data[11]+1
    elseif WMI2TriggerEvent(i)!=null then
        set data[6]=data[6]+1
    elseif WMI2TriggerCondition(i)!=null then
        set data[7]=data[7]+1
    elseif WMI2TriggerAction(i)!=null then
        set data[8]=data[8]+1
    elseif WMI2TimerDialog(i)!=null then
        set data[10]=data[10]+1
    elseif WMI2Region(i)!=null then
        set data[15]=data[15]+1
    endif
    if data[0]>max then
        call DestroyTimer(GetExpiredTimer())
    endif
    set data[0]=data[0]+1
endfunction
private function print takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>16
        if data[i]>warn[i] then
            set s[i+16]="|cffff0000"
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>15
        call DisplayTimedTextToPlayer(Player(0),0,0,30,s[i]+s[16+i]+I2S(data[i])+s[i+1]+s[17+i]+I2S(data[i+1])+s[i+2]+s[18+i]+I2S(data[i+2])+s[i+3]+s[19+i]+I2S(data[i+3]))
        set i=i+4
    endloop
    call DestroyTimer(GetExpiredTimer())
endfunction
function WMLeakMonitorSystem takes nothing returns nothing
    local timer t=CreateTimer()
    local integer i=0
    local integer id=GetHandleId(t)-0x100000
    loop
        exitwhen i>16
        set data[i]=0
        set i=i+1
    endloop
    if max<id then
        set max=id
    endif
    call DisplayTimedTextToPlayer(Player(0),0,0,30,"\n红色代表超过警戒范围，该项可能需要排泄，绿色表明该项出于安全范围内\n目前整数地址最低已使用至"+I2S(max)+"个，以下值仅供参考"+"\n-----------------------------------------------------")
    call TimerStart(t,0,true,function round)
    call TimerStart(CreateTimer(),time,false,function print)
    set t=null
endfunction
private function re1 takes nothing returns nothing
    call DisplayTimedTextToPlayer(Player(0),0,0,30,"max=0")
    set max=0
endfunction
private function re2 takes nothing returns nothing
    set time=S2I(SubString(GetEventPlayerChatString(),7,9))
    call DisplayTimedTextToPlayer(Player(0),0,0,30,"t="+I2S(time))
endfunction
private function init takes nothing returns nothing
    local trigger t=CreateTrigger()
    local trigger t2=CreateTrigger()
    local integer i=17
    call TriggerRegisterPlayerChatEvent(t,Player(0),"-set t=",false)
    call TriggerRegisterPlayerChatEvent(t2,Player(0),"-reset max",true)
    call TriggerAddAction(t2,function re1)
    call TriggerAddAction(t,function re2)
    set s[1]="可破坏物:"
    set s[2]="|r  物品:"
    set s[3]="|r  单位:"
    set s[4]="|r  特效:"
    set s[5]="触发器:"
    set s[6]="|r  事件:"
    set s[7]="|r  条件:"
    set s[8]="|r  动作:"
    set s[9]="计时器:"
    set s[10]="|r  计时器窗口:"
    set s[11]="|r  多面板项目:"
    set s[12]="|r  单位组:"
    set s[13]="玩家组:"
    set s[14]="|r  矩形区域:"
    set s[15]="|r  不规则区域:"
    set s[16]="|r  点:"
    set warn[1]=10000
    set warn[2]=250
    set warn[3]=3000
    set warn[4]=150
    set warn[5]=600
    set warn[6]=800
    set warn[7]=400
    set warn[8]=400
    set warn[9]=75
    set warn[10]=10
    set warn[11]=100
    set warn[12]=100
    set warn[13]=100
    set warn[14]=150
    set warn[15]=150
    set warn[16]=100
    loop
        exitwhen i>32
        set s[i]="|cff00ff00"
        set i=i+1
    endloop
    set t=null
    set t2=null
endfunction
endlibrary
#endif
