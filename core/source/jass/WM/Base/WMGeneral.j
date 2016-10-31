globals
    real WMMinX
    real WMMaxX
    real WMMinY
    real WMMaxY
    constant integer MinHandleId=0x100000
endglobals
private function zero takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    set WMMinX=GetRectMinX(bj_mapInitialPlayableArea)
    set WMMaxX=GetRectMaxX(bj_mapInitialPlayableArea)
    set WMMinY=GetRectMinY(bj_mapInitialPlayableArea)
    set WMMaxY=GetRectMaxY(bj_mapInitialPlayableArea)
endfunction
private function init takes nothing returns nothing
    call TimerStart(CreateTimer(),0,false,function zero)
endfunction
