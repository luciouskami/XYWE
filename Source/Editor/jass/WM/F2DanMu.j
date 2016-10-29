#ifndef F2DanMuIncluded
#define F2DanMuIncluded
#include "WM/UnitAlive.j"
#include "WM/WMBase.j"
#include "WM/Common/TerrainPathability.j"
library F2DanMu uses WMBase,TerrainPathability
globals
	private group g=CreateGroup()
	private boolean b
	private real damage_D
	public unit u1
	public unit u2
	public unit ue
endglobals
private function DanMu takes nothing returns nothing
	if GetWidgetLife(GetEnumDestructable())>0 then
   	 	call SetWidgetLife(GetEnumDestructable(),GetWidgetLife(GetEnumDestructable())-damage_D)
    	set b=true
	endif
endfunction
private function danmu4_move takes nothing returns nothing
	local integer id= GetHandleId(GetExpiredTimer())-MinHandleId
	local real n=WMLoadReal(id,8)+1
	local real v=WMLoadReal(id,3)+WMLoadReal(id,11)*n
	local real angle
	local real range=WMLoadReal(id,6)
	local boolean b0 = false
	local real x
	local real y
	local boolean bbb=false
	local rect rct
	local boolean array b_Dis
	local boolean b_u
	set u1=WMLoadUnitHandle(id,1)
	set u2=WMLoadUnitHandle(id,2)
	set angle=GetUnitFacing(u1)
	set x=GetUnitX(u1)+v*Cos(angle* bj_DEGTORAD)
	set y=GetUnitY(u1)+v*Sin(angle* bj_DEGTORAD)
	if x>WMMaxX or x<WMMinX or y<WMMinY or y>WMMaxY then
		call KillUnit(u1)
    	call DestroyGroup(WMLoadGroupHandle(id,14))
    	call WMFlushChildHashtable(id)
    	call PauseTimer(GetExpiredTimer())
    	call DestroyTimer(GetExpiredTimer())
    	return
	endif
    set damage_D=WMLoadReal(id,7)
    call WMSaveReal(id,8,n)
	if not (IsTerrainWalkable(x,y) or WMLoadBoolean(id,15)) then
    	set b=false
    	if WMLoadBoolean(id,16) then
        	set rct = Rect(x-range*2, y-range*2, x+64+range, y+64+range)
        	call EnumDestructablesInRect(rct,null,function DanMu)
        	call RemoveRect(rct)
			set rct = null
    	endif
   		if b then
        	set b0 = true
    	elseif not WMLoadBoolean(id,12) then
        	set b_Dis[1]=IsTerrainWalkable(x+v,y)//右
        	set b_Dis[2]=IsTerrainWalkable(x,y+v)//上
        	set b_Dis[3]=IsTerrainWalkable(x-v,y)//左
        	set b_Dis[4]=IsTerrainWalkable(x,y-v)//下
        	if b_Dis[1] and b_Dis[2]==false and b_Dis[3]==false and b_Dis[4]==false then
            	call SetUnitFacing(u1,180-angle)
        	elseif b_Dis[1]==false and b_Dis[2] and b_Dis[3]==false and b_Dis[4]==false then
            	call SetUnitFacing(u1,-angle)
        	elseif b_Dis[1]==false and b_Dis[2]==false and b_Dis[3] and b_Dis[4]==false then
            	call SetUnitFacing(u1,180-angle)
        	elseif b_Dis[1]==false and b_Dis[2]==false and b_Dis[3]==false and b_Dis[4] then
            	call SetUnitFacing(u1,-angle)
        	else
            	call SetUnitFacing(u1,angle+180)
        	endif
    	else
        	set b0 = true
    	endif
	else
    	call SetUnitX(u1,x)
    	call SetUnitY(u1,y)
	endif
    call GroupEnumUnitsInRange(g,x,y,range,null)
    loop
    	set ue=FirstOfGroup(g)
    	exitwhen ue==null
        if ue==u1 then
            set b_u=false
        else
            if WMLoadBoolean(id,18) then
                set b_u = true
            else
                set b_u = IsUnitEnemy(u2,GetOwningPlayer(ue))
            endif
        endif
        if b_u and UnitAlive(u2) and UnitAlive(ue) and (not IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE)) and not IsUnitInGroup(u2,WMLoadGroupHandle(id,14)) then
            if TriggerEvaluate(WMLoadTriggerHandle(id,17))!=null then
                call TriggerExecute(WMLoadTriggerHandle(id,17))
            endif
            call GroupAddUnit(WMLoadGroupHandle(id,14),u2)
            if WMLoadBoolean(id,13) then
                set b0 = true
            endif
            if WMLoadBoolean(id,10) then
   				call UnitDamageTarget(u2,ue,damage_D,true, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
			else
    			call UnitDamageTarget(u2,ue,damage_D,true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS )
			endif
        endif
    	call GroupRemoveUnit(g,ue)
    endloop
	if b0 or n>WMLoadReal(id,9) then
    	call KillUnit(u1)
    	call DestroyGroup(WMLoadGroupHandle(id,14))
    	call WMFlushChildHashtable(id)
    	call PauseTimer(GetExpiredTimer())
    	call DestroyTimer(GetExpiredTimer())
	endif
endfunction
function F2DanMu takes unit u,unit u0,real v,real v2,real range,real damage,real time,boolean b1,boolean b2,boolean b3,boolean b4,boolean b5,boolean b6,trigger tr returns nothing
	local timer t = CreateTimer()
	local integer id= GetHandleId(t)-MinHandleId
    call WMSaveUnitHandle(id,1,u)
    call WMSaveUnitHandle(id,2,u0)
    call WMSaveReal(id,3,v*0.03)
    call WMSaveReal(id,6,range)
    call WMSaveReal(id,7,damage)
    call WMSaveReal(id,8,0)
    call WMSaveReal(id,9,time/0.03)
    call WMSaveBoolean(id,10,b1)
    call WMSaveReal(id,11,(v2-v)*0.03/(time/0.03))
    call WMSaveBoolean(id,12,b2)
    call WMSaveBoolean(id,13,b3)
    call WMSaveGroupHandle(id,14,CreateGroup())
    call WMSaveBoolean(id,15,b4)
    call WMSaveBoolean(id,16,b5)
    call WMSaveTriggerHandle(id,17,tr)
    call WMSaveBoolean(id,18,b6)
    call TimerStart(t,0.03,true,function danmu4_move)
	set t = null
endfunction
endlibrary
#endif
