library_once SJWEBase

globals
    private constant hashtable P=InitHashtable()
    private constant hashtable F=InitHashtable()
    constant hashtable DATA=InitHashtable()
    private real array s
    private real spaceVector_x=0.
    private real spaceVector_y=0.
    private real spaceVector_z=0.
    private multiboard array lbn
endglobals

function Hex_Str2I takes string s returns integer
    local integer i = 0
    local string S = ""
    local integer I = 0
    local integer d = StringLength(s)
    loop
        set I = I + 1
        set S = SubString(s,I-1,I)
        if S == "A" then
            set i = i + R2I(10*Pow(16,d-I))
        elseif S == "B" then
            set i = i + R2I(11*Pow(16,d-I))
        elseif S == "C" then
            set i = i + R2I(12*Pow(16,d-I))
        elseif S == "D" then
            set i = i + R2I(13*Pow(16,d-I))
        elseif S == "E" then
            set i = i + R2I(14*Pow(16,d-I))
        elseif S == "F" then
            set i = i + R2I(15*Pow(16,d-I))
        else
            set i = i + R2I(S2I(S)*Pow(16,d-I))
        endif
        exitwhen I == d
    endloop
    return i
endfunction

function I2Hex_Str takes integer i returns string
    local integer ti = i
    local integer I = 0
    local string s = ""
    loop
        set I = i - ( i / 16 ) * 16
        if I < 10 then
            set s = I2S(I) + s
        elseif I == 10 then
            set s = "A" + s
        elseif I == 11 then
            set s = "B" + s
        elseif I == 12 then
            set s = "C" + s
        elseif I == 13 then
            set s = "D" + s
        elseif I == 14 then
            set s = "E" + s
        elseif I == 15 then
            set s = "F" + s
        endif
        set i = i / 16
        exitwhen i == 0
    endloop
    if ti == 0 then
        set s = "00"
	elseif (ti <= 15) and (ti > 0) then
	    set s = "0" + s
    endif
    return s
endfunction

function SetStringColor takes integer a, integer r, integer g, integer b, string s returns string
    set s = "|c" + I2Hex_Str(a) + I2Hex_Str(r) + I2Hex_Str(g) + I2Hex_Str(b) + s + "|r"
	return s
endfunction

function InitIndex takes integer whichID returns nothing
    call SaveInteger(F, (whichID), 0, 1)
endfunction

//为对象分配一个未使用索引
function CreateIndex takes integer whichID returns integer
    local integer i=(LoadInteger(F, (whichID), 0))
    if (LoadInteger(P, (whichID ), ( (LoadInteger(F, (whichID), 0))))) == 0 then
        call SaveInteger(F, (whichID ), 0, ( (LoadInteger(F, (whichID), 0)) + 1))
        call SaveInteger(F, (whichID), 1,LoadInteger(F, (whichID), 0))
    else
        call SaveInteger(F, (whichID ), 0, ( - (LoadInteger(P, (whichID ), ( (LoadInteger(F, (whichID), 0)))))))
    endif
    call SaveBoolean(P, (whichID ), ( i ), ( true))
    return i
endfunction

function GetMaxIndex takes integer whichID returns integer
    return LoadInteger(F, (whichID), 1) - 1
endfunction

//回收对象索引
function DestroyIndex takes integer whichID,integer i returns nothing
    if (LoadBoolean(P, (whichID ), ( i))) == true then
        call SaveInteger(P, (whichID ), ( i ), ( - (LoadInteger(F, (whichID), 0))))
        call SaveInteger(F, (whichID ), 0, ( i))
    endif
endfunction

//回收所有对象索引并重置索引起始值
function DestroyIndexAll takes integer whichID returns nothing
    call FlushChildHashtable(F, whichID)
    call FlushChildHashtable(P, whichID)
endfunction

//===========================快速排序算法============================//
function quick_sort takes integer left,integer right returns nothing
    local integer i = left
    local integer j = right
    local real x = s[(left+right)/2]
    local real t = 0
    loop
        loop
            exitwhen x <= s[i]
            set i = i + 1
        endloop
        loop
            exitwhen x >= s[j]
            set j = j - 1
        endloop
        if i <= j then
            set t = s[i]
            set s[i] = s[j]
            set s[j] = t
            set i = i + 1
            set j = j - 1
        endif
        exitwhen i > j
    endloop
    if left < j then
        call quick_sort(left,j)
    endif
    if i < right then
        call quick_sort(i,right)
    endif
endfunction

//=========================导入排序数据================================//
function SaveData takes integer index, real hartred returns nothing
    set s[index] = hartred
endfunction

function LoadData takes integer index returns real
    return s[index]
endfunction

// 计算以坐标 x,y,z为中心, 距离dist, 方向xDEG, 倾斜角hDEG 的点的坐标
function SpaceVectorRAD takes real x,real y,real z,real dist,real xRadians,real hRadians returns nothing
    set spaceVector_z=dist*Cos(hRadians)
    set spaceVector_x=x+spaceVector_z*Cos(xRadians)
    set spaceVector_y=y+spaceVector_z*Sin(xRadians)
    set spaceVector_z=z+dist*Sin(hRadians)
endfunction

function SpaceVectorDEG takes real x,real y,real z,real dist,real xDEG,real hDEG returns nothing
    set xDEG=xDEG*bj_DEGTORAD
    set hDEG=hDEG*bj_DEGTORAD
    set spaceVector_z=dist*Cos(hDEG)
    set spaceVector_x=x+spaceVector_z*Cos(xDEG)
    set spaceVector_y=y+spaceVector_z*Sin(xDEG)
    set spaceVector_z=z+dist*Sin(hDEG)
endfunction

function GetSpaceVector_x takes nothing returns real
    return spaceVector_x
endfunction

function GetSpaceVector_y takes nothing returns real
    return spaceVector_y
endfunction

function GetSpaceVector_z takes nothing returns real
    return spaceVector_z
endfunction

function Probability takes real a returns boolean
    local boolean b = false
    if ( a <= 0.00 ) then
        set b = false
    elseif ( ( a > 0.00 ) and ( a < 100.00 ) ) then
        if ( GetRandomReal(0.00, 100.00) <= a ) then
            set b = true
        else
            set b = false
        endif
    elseif ( a >= 100.0 ) then
        set b = true
    endif
    return b
endfunction

function Revive_Hero_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local timerdialog td = LoadTimerDialogHandle(DATA, GetHandleId(t), StringHash("timerdialog"))
    local unit whichhero = LoadUnitHandle(DATA, GetHandleId(t), StringHash("unit"))
    local real locX = LoadReal(DATA, GetHandleId(t), StringHash("locX"))
    local real locY = LoadReal(DATA, GetHandleId(t), StringHash("locY"))
    call DestroyTimerDialog(td)
    call ReviveHero(whichhero, locX, locY, true)
    if (GetLocalPlayer() == GetOwningPlayer(whichhero)) then
        call PanCameraToTimed(locX, locY, 0.0)
    endif
    call FlushChildHashtable(DATA, GetHandleId(t))
    call DestroyTimer(t)
    set t = null
    set td = null
    set whichhero = null
endfunction

function Revive_Hero takes unit whichhero, location point, real timeout returns nothing
    local timer t = CreateTimer()
    local timerdialog td = CreateTimerDialog(t)
    call SaveUnitHandle(DATA, GetHandleId(t), StringHash("unit"), whichhero)
    call SaveReal(DATA, GetHandleId(t), StringHash("locX"), GetLocationX(point))
    call SaveReal(DATA, GetHandleId(t), StringHash("locY"), GetLocationY(point))
    call SaveTimerDialogHandle(DATA, GetHandleId(t), StringHash("timerdialog"), td)
    call TimerDialogSetTitle(td, (GetUnitName(whichhero) + "复活时间："))
    call TimerStart(t, timeout, false, function Revive_Hero_Func)
    call TimerDialogDisplay(td, true)
    call RemoveLocation(point)
    set t = null
    set td = null
endfunction

function ItemSuperimpositionConditions takes nothing returns boolean
    return ((GetItemType(GetManipulatedItem()) == ITEM_TYPE_CHARGED))
endfunction

function ItemSuperimpositionActions takes nothing returns nothing
    local integer i
    local unit U = GetTriggerUnit()
    local item it = GetManipulatedItem()
    set i = 0
    loop
        exitwhen i > 5
        if ((it != UnitItemInSlot(U, i)) and (GetItemTypeId(it) == GetItemTypeId(UnitItemInSlot(U, i)))) then
            call SetItemCharges(UnitItemInSlot(U, i), ( GetItemCharges(UnitItemInSlot(U, i)) + GetItemCharges(it) ))
            call RemoveItem(it)
        else
        endif
        set i = i + 1
    endloop
    set U = null
    set it = null
endfunction

function ItemSuperimposition takes nothing returns nothing
    local trigger tri = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(tri, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(tri, Condition(function ItemSuperimpositionConditions))
    call TriggerAddAction(tri, function ItemSuperimpositionActions)
    set tri = null
endfunction

function CreateMultiboardForPlayer takes player whichplayer, integer i returns multiboard
	if i <= 0 then
		set i = 0
	elseif i >= 680 then
	    set i = 680
    endif
    if (lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))] == null) then
        set lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))] = CreateMultiboard()
        set bj_lastCreatedMultiboard = lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))]
        return lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))]
    else
        return lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))]
    endif
endfunction

function DestroyMultiboardForPlayer takes player whichplayer, integer i returns nothing
	if i <= 0 then
		set i = 0
	elseif i >= 680 then
	    set i = 680
    endif
	call DestroyMultiboard(lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))])
	set lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))] = null
endfunction

function GetPlayerMultiboard takes player whichplayer, integer i returns multiboard
	if i <= 0 then
		set i = 0
	elseif i >= 680 then
	    set i = 680
    endif
	return lbn[S2I(I2S(GetPlayerId(whichplayer) + 1) + I2S(i))]
endfunction

function DisplayMultibosrdToPlayer takes player p, multiboard lb ,boolean b returns nothing
	if GetLocalPlayer() == p then
		call MultiboardDisplay(lb,b)
    endif
endfunction

function DisplayMultibosrdFoForce takes force f, multiboard lb , boolean b returns nothing
	if IsPlayerInForce(GetLocalPlayer(),f) then
		call MultiboardDisplay(lb,b)
    endif
endfunction

endlibrary
