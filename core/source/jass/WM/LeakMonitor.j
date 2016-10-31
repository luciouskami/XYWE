#ifndef LeakMonitorIncluded
#define LeakMonitorIncluded
library LeakMonitor
function LeakMonitor takes nothing returns nothing
    call DisplayTextToPlayer( Player(0), 0, 0, "------------YDWE Leak Monitor------------" )
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,"|cff00FF00点(location)|r: " + I2S(GetLocalizedHotkey("yd_leak_monitor::location")))
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,"|cff00FF00特效(effect)|r: " + I2S(GetLocalizedHotkey("yd_leak_monitor::effect")))
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,"|cff00FF00单位组(group)|r: " + I2S(GetLocalizedHotkey("yd_leak_monitor::group")))
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,"|cff00FF00不规则区域(region)|r: " + I2S(GetLocalizedHotkey("yd_leak_monitor::region")))
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,"|cff00FF00矩形区域(rect)|r: " + I2S(GetLocalizedHotkey("yd_leak_monitor::rect")))
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,"|cff00FF00玩家组(force)|r: " + I2S(GetLocalizedHotkey("yd_leak_monitor::force")))
    call DisplayTextToPlayer(GetLocalPlayer(),0,0, "-----------------------------------------" )
endfunction
function CreateLeakMonitorReport takes nothing returns nothing
	call GetLocalizedHotkey("yd_leak_monitor::create_report")
endfunction
endlibrary
#endif
