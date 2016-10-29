#ifndef AntiCheatPShanIncluded
#define AntiCheatPShanIncluded
#include "WM/WMBase.j"
#include "WM/DistanceBetweenCoordinates.j"
library AntiCheatPShan initializer init requires WMBase,DistanceBetweenCoordinates
globals
    private real array x
    private real array y
    private unit array u
    private integer n=0
    private trigger t=CreateTrigger()
    private integer array id
endglobals
private function Check takes nothing returns nothing
	local integer uid=id[GetHandleId(GetTriggerUnit())-0x100000]
    if GetIssuedOrderId()==851990 and DistanceBetweenCoordinates(GetUnitX(GetTriggerUnit()),GetUnitY(GetTriggerUnit()),x[uid],y[uid])>26.1 then
    	call SetUnitX(GetTriggerUnit(),x[uid])
    	call SetUnitY(GetTriggerUnit(),y[uid])
    	call DisplayTextToPlayer(GetLocalPlayer(),0,0,"检测到"+GetUnitName(GetTriggerUnit())+"可能P闪，已将该单位复位。")
    endif
endfunction
private function round takes nothing returns nothing
	local integer i=0
	loop
		exitwhen i==n
		set x[i]=GetUnitX(u[i])
    	set y[i]=GetUnitY(u[i])
    	set i=i+1
	endloop
endfunction
function AntiCheatPShan takes unit hero returns nothing
	call TriggerRegisterUnitEvent(t,hero,EVENT_UNIT_ISSUED_POINT_ORDER)
	if GetHandleId(hero)-0x100000>=0x2000 then
		call DisplayTextToPlayer(Player(0),0,0,"数组过小，你可以尝试修改AntiCheatPShan.j文件来增加数组上限")
		return
	endif
	set id[GetHandleId(hero)-0x100000]=n
	set u[n]=hero
	set n=n+1
endfunction
private function init takes nothing returns nothing
    call TimerStart(CreateTimer(),0.05,true,function round)
    call TriggerAddAction(t, function Check)
endfunction
endlibrary
#endif
