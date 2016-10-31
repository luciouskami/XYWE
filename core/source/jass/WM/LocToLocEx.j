#ifndef LocToLocExIncluded
#define LocToLocExIncluded

library LocToLocEx//点->伪点
    struct LocEx
        real x
        real y
        static method create takes real x,real y returns thistype
            local thistype l=thistype.allocate()
            set l.x=x
            set l.y=y
            return l
        endmethod
    endstruct
//返回点
    function GetUnitLocEx takes unit u returns LocEx//单位位置
        return LocEx.create(GetUnitX(u),GetUnitY(u))
    endfunction
    function GetDestructableLocEx takes destructable whichDestructable returns LocEx//可破坏物位置
        return LocEx.create(GetDestructableX(whichDestructable), GetDestructableY(whichDestructable))
    endfunction
    function GetOrderPointLocEx takes nothing returns LocEx//命令点
        return LocEx.create(GetOrderPointX(),GetOrderPointY())
    endfunction
    function GetPlayerStartLocationLocEx takes player whichPlayer returns LocEx//开始点
        return LocEx.create(GetStartLocationX(GetPlayerStartLocation(whichPlayer)),GetStartLocationY(GetPlayerStartLocation(whichPlayer)))
    endfunction
    function GetItemLocEx takes item whichItem returns LocEx//物品位置
        return LocEx.create(GetItemX(whichItem), GetItemY(whichItem))
    endfunction
    function WaygateGetDestinationLocBJEx takes unit waygate returns LocEx//传送门目的地
        return LocEx.create(WaygateGetDestinationX(waygate), WaygateGetDestinationY(waygate))
    endfunction
    function GetUnitRallyPointEx takes unit u returns LocEx//单位集结点
        local location l=GetUnitRallyPoint(u)
        local real x=GetLocationX(l)
        local real y=GetLocationY(l)
        call RemoveLocation(l)
        set l=null
        return LocEx.create(x,y)
    endfunction
    function GetRectCenterEx takes rect r returns LocEx//区域中心
        return LocEx.create(GetRectCenterX(r), GetRectCenterY(r))
    endfunction
    function GetRandomLocInRectEx takes rect r returns LocEx//区域随机点
        return LocEx.create(GetRandomReal(GetRectMinX(r), GetRectMaxX(r)), GetRandomReal(GetRectMinY(r), GetRectMaxY(r)))
    endfunction
    function PolarProjectionBJEx takes LocEx l, real dist, real angle returns LocEx//极坐标位移点
        local real x =l.x+ dist * Cos(angle * bj_DEGTORAD)
        local real y =l.y+ dist * Sin(angle * bj_DEGTORAD)
        call l.destroy()
        return LocEx.create(x,y)
    endfunction
    function CameraSetupGetDestPositionLocEx takes camerasetup whichSetup returns LocEx//镜头目标点
        return LocEx.create(CameraSetupGetDestPositionX(whichSetup),CameraSetupGetDestPositionY(whichSetup))
    endfunction
    #if WARCRAFT_VERSION>=124
        function GetSpellTargetLocEx takes nothing returns LocEx//技能释放点
            return LocEx.create(GetSpellTargetX(),GetSpellTargetY())
        endfunction
    #else
        function GetSpellTargetLocEx takes nothing returns LocEx//技能释放点
            local location l=GetSpellTargetLoc()
            local real x=GetLocationX(l)
            local real y=GetLocationY(l)
            call RemoveLocation(l)
            set l=null
            return LocEx.create(x,y)
        endfunction
    #endif
//参数为点
    function SetUnitPositionLocEx takes unit u,LocEx l returns nothing//设置单位位置
        call SetUnitPosition(u,l.x,l.y)
        call l.destroy()
    endfunction
    function SetUnitXYEx takes unit u,LocEx l returns nothing//设置单位位置
        call SetUnitX(u,l.x)
        call SetUnitY(u,l.y)
        call l.destroy()
    endfunction
    function CreateNUnitsAtLocEx takes integer count, integer unitid, player whichPlayer, LocEx loc, real face returns group//创建单位
        call GroupClear(bj_lastCreatedGroup)
        loop
            set count=count-1
            exitwhen count<0
            if (unitid == 'ugol') then
                set bj_lastCreatedUnit = CreateBlightedGoldmine(whichPlayer,loc.x,loc.y,face)
            else
                set bj_lastCreatedUnit = CreateUnit(whichPlayer,unitid,loc.x,loc.y,face)
            endif
            call GroupAddUnit(bj_lastCreatedGroup, bj_lastCreatedUnit)
        endloop
        call loc.destroy()
        return bj_lastCreatedGroup
    endfunction
    function AngleBetweenPointsEx takes LocEx locA,LocEx locB returns real//两点间角度
        local real y=locB.y-locA.y
        local real x=locB.x-locA.x
        call locB.destroy()
        call locA.destroy()
        return bj_RADTODEG * Atan2(y,x)
    endfunction
    function CreateCorpseLocBJEx takes integer unitid, player p,LocEx loc returns unit//创建尸体
        set bj_lastCreatedUnit = CreateCorpse(p,unitid,loc.x,loc.y,GetRandomReal(0, 360))
        call loc.destroy()
        return bj_lastCreatedUnit
    endfunction
    function IssuePointOrderLocEx takes unit u,string s,LocEx l returns nothing//发布命令点
        call IssuePointOrder(u,s,l.x,l.y)
        call l.destroy()
    endfunction
    function GetLocationZEx takes LocEx loc returns real//点Z坐标
        local location l=Location(loc.x,loc.y)
        local real z=GetLocationZ(l)
        call RemoveLocation(l)
        set l=null
        call loc.destroy()
        return z
    endfunction
    function PanCameraToTimedLocForPlayerEx takes player p, LocEx loc, real d returns nothing//移动镜头-指定玩家
        if (GetLocalPlayer() == p) then
            call PanCameraToTimed(loc.x,loc.y, d)
        endif
        call loc.destroy()
    endfunction
    function CreateItemLocEx takes integer itemId,LocEx loc returns item//创建物品
        set bj_lastCreatedItem = CreateItem(itemId,loc.x,loc.y)
        call loc.destroy()
        return bj_lastCreatedItem
    endfunction
    function SetItemPositionLocEx takes item whichItem,LocEx loc returns nothing//移动物品
        call SetItemPosition(whichItem,loc.x,loc.y)
        call loc.destroy()
    endfunction
    function ReviveHeroLocEx takes unit u,LocEx l,boolean b returns nothing//复活英雄
        call ReviveHero(u,l.x,l.y,b)
        call l.destroy()
    endfunction
    function AddSpecialEffectLocBJEx takes LocEx where, string modelName returns nothing//新建特效
	    call DestroyEffect(AddSpecialEffect(modelName,where.x,where.y))
	    call where.destroy()
	endfunction
endlibrary

#endif
