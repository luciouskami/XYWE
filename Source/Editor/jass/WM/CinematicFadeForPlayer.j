#ifndef CinematicFadeForPlayerIncluded
#define CinematicFadeForPlayerIncluded
#include "WM/WMBase.j"
library CinematicFadeForPlayer
globals
    private timer array t
    constant integer bj_CINEFADETYPE_FADEINOUT=3
endglobals
private function second takes nothing returns nothing
    local timer loc_t=GetExpiredTimer()
    local integer tid=GetHandleId(loc_t)-0x100000
    call DestroyTimer(loc_t)
    call DisplayCineFilter(false)
    set t[WMLoadInteger(tid,1)]=null
    call WMFlushChildHashtable(tid)
    set loc_t=null
endfunction
private function CinematicFadeCommon takes real duration, string tex,integer type1,integer type2,integer r,integer g,integer b,integer startTrans,integer endTrans returns nothing
    call SetCineFilterTexture(tex)
    call SetCineFilterBlendMode(ConvertBlendMode(type1))
    call SetCineFilterTexMapFlags(ConvertTexMapFlags(type2))
    call SetCineFilterStartUV(0, 0, 1, 1)
    call SetCineFilterEndUV(0, 0, 1, 1)
    call SetCineFilterStartColor(r,g,b,startTrans)
    call SetCineFilterEndColor(r,g,b,endTrans)
    call SetCineFilterDuration(duration)
    call DisplayCineFilter(true)
endfunction
private function first takes nothing returns nothing
    local timer loc_t=GetExpiredTimer()
    local integer tid=GetHandleId(loc_t)-0x100000
    local integer r=WMLoadInteger(tid,3)
    local integer g=WMLoadInteger(tid,4)
    local integer b=WMLoadInteger(tid,5)
    local integer pid=WMLoadInteger(tid,1)
    local integer start=0
    local integer end=0
    if WMLoadBoolean(tid,0)then
	    if Player(pid)==GetLocalPlayer()then
    	    if WMLoadBoolean(tid,11)then
    	        set start=WMLoadInteger(tid,7)
   		    else
   		    	set end=WMLoadInteger(tid,6)
        	endif
        	call CinematicFadeCommon(WMLoadReal(tid,2),WMLoadStr(tid,8),WMLoadInteger(tid,9),(WMLoadInteger(tid,10)),r,g,b,start,end)
    	endif
    	call TimerStart(loc_t,WMLoadReal(tid,2),false,function second)
    else
    	call DisplayCineFilter(false)
        call DestroyTimer(loc_t)
        set t[pid]=null
        call WMFlushChildHashtable(tid)
    endif
    set loc_t=null
endfunction
function CinematicFadeForPlayer takes player p,integer fadetype, real duration, string tex,integer blendmodetype,integer texmapflagstype,integer red, integer green, integer blue, integer trans returns nothing
    local integer pid=GetPlayerId(p)
    local integer startTrans=trans
    local integer endTrans=trans
    local integer tid
    local boolean b=false
    local boolean b2=true
    if (t[pid]!=null)then
        call DestroyTimer(t[pid])
    endif
    set t[pid]=CreateTimer()
    set tid=GetHandleId(t[pid])-0x100000
    if fadetype==bj_CINEFADETYPE_FADEOUT then
        set startTrans=0
    elseif fadetype==bj_CINEFADETYPE_FADEIN then
        set endTrans=0
    elseif fadetype==bj_CINEFADETYPE_FADEOUTIN then
        set startTrans=0
        set duration=duration*0.5
        set b=true
    elseif fadetype==bj_CINEFADETYPE_FADEINOUT then
        set duration=duration*0.5
        set b=true
        set b2=false
        set endTrans=0
    endif
    if duration==0then
        set startTrans=endTrans
    endif
    call WMSaveBoolean(tid,0,b)
    call WMSaveInteger(tid,1,pid)
    call WMSaveReal(tid,2,duration)
    call WMSaveInteger(tid,3,red)
    call WMSaveInteger(tid,4,green)
    call WMSaveInteger(tid,5,blue)
    call WMSaveInteger(tid,6,startTrans)
    call WMSaveInteger(tid,7,endTrans)
    call WMSaveStr(tid,8,tex)
    call WMSaveInteger(tid,9,blendmodetype)
    call WMSaveInteger(tid,10,texmapflagstype)
    call WMSaveBoolean(tid,11,b2)
    call TimerStart(t[pid],duration,false,function first)
    if p==GetLocalPlayer()then
	    call CinematicFadeCommon(duration,tex,blendmodetype,texmapflagstype,red,green,blue,startTrans,endTrans)
    endif
endfunction
endlibrary
#endif
