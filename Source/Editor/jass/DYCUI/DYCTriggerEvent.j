#ifndef DYCTriggerEventIncluded
#define DYCTriggerEventIncluded

#include "DYCUI/DYCbase.j"


library DYCTriggerEvent requires DYCbase

globals
#ifndef DYC_AnyUnitEventTrigger
#define DYC_AnyUnitEventTrigger
    trigger dyc_DummyDieTrigger = null
#endif
    private trigger array AnyUnitEventQueue
    private integer array AnyUnitEventType
    private integer AnyUnitEventNumber = 0

    unit bj_GetDYCChargedUnit= null
    unit bj_GetDYCChargingUnit= null
    unit bj_GetDYCDDUnit=null
    unit bj_GetDYCDDSUnit=null
    string bj_GetDYCChargeName=""
    real bj_GetDYCDDValue=0
    group bj_DYCDummyGroup



endglobals

//===========================================================================
//DYC Any Unit Does Any Thing Event
//===========================================================================


function DYCAnyUnitTrigger takes nothing returns nothing

    local unit u=bj_DYCUnit1
    local unit u2=bj_DYCUnit2
    local real r1=bj_DYCReal1
    local integer hd=GetHandleId(u)
    local integer i = 0

    if (bj_DYCTJudge==1) then
        set bj_GetDYCChargedUnit=u2
        set bj_GetDYCChargingUnit=u
        set bj_GetDYCChargeName=LoadStr(UDGht,hd,StringHash("SystemUChargen"))
        set i=0
        loop
            exitwhen i >= AnyUnitEventNumber
            if AnyUnitEventType[i]==1 and AnyUnitEventQueue[i] != null and IsTriggerEnabled(AnyUnitEventQueue[i]) and TriggerEvaluate(AnyUnitEventQueue[i]) then
                call TriggerExecute(AnyUnitEventQueue[i])

            endif
            set i = i + 1
        endloop
    endif

    if (bj_DYCTJudge==2) then
        set bj_GetDYCChargedUnit=u2
        set bj_GetDYCChargingUnit=u
        set bj_GetDYCChargeName=LoadStr(UDGht,hd,StringHash("SystemUChargen"))
        set i=0
        loop
            exitwhen i >= AnyUnitEventNumber
            if AnyUnitEventType[i]==2 and AnyUnitEventQueue[i] != null and IsTriggerEnabled(AnyUnitEventQueue[i]) and TriggerEvaluate(AnyUnitEventQueue[i]) then
                call TriggerExecute(AnyUnitEventQueue[i])

            endif
            set i = i + 1
        endloop
    endif

    if (bj_DYCTJudge==3) then
        set bj_GetDYCChargedUnit=u2
        set bj_GetDYCChargingUnit=u
        set bj_GetDYCChargeName=LoadStr(UDGht,hd,StringHash("SystemUChargen"))
        set i=0
        loop
            exitwhen i >= AnyUnitEventNumber
            if AnyUnitEventType[i]==3 and AnyUnitEventQueue[i] != null and IsTriggerEnabled(AnyUnitEventQueue[i]) and TriggerEvaluate(AnyUnitEventQueue[i]) then
                call TriggerExecute(AnyUnitEventQueue[i])

            endif
            set i = i + 1
        endloop
    endif

    if (bj_DYCTJudge==4) then
        set bj_GetDYCDDUnit=u2
        set bj_GetDYCDDSUnit=u
        set bj_GetDYCDDValue=r1
        set i=0
        loop
            exitwhen i >= AnyUnitEventNumber
            if AnyUnitEventType[i]==4 and AnyUnitEventQueue[i] != null and IsTriggerEnabled(AnyUnitEventQueue[i]) and TriggerEvaluate(AnyUnitEventQueue[i]) then
                call TriggerExecute(AnyUnitEventQueue[i])

            endif
            set i = i + 1
        endloop
    endif

    set bj_DYCTJudge=0
    set u=null
    set u2=null

endfunction




function DummyDieActions takes nothing returns nothing
    if GetUnitAbilityLevel(GetTriggerUnit(), 'Aloc') > 0 then
        call GroupRemoveUnit(bj_DYCDummyGroup,GetTriggerUnit())
        //call BJDebugMsg(I2S(CountUnitsInGroup(bj_DYCDummyGroup)))
    endif
endfunction



function DYCDummyFilter takes nothing returns boolean
    if GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') > 0 then
        call GroupAddUnit(bj_DYCDummyGroup,GetFilterUnit())
        //call BJDebugMsg(I2S(CountUnitsInGroup(bj_DYCDummyGroup)))
    endif
    return false
endfunction

function DYCDummyEnumUnit takes nothing returns nothing
    local trigger t = CreateTrigger()
    local region  r = CreateRegion()
    local group   g = CreateGroup()

    call RegionAddRect(r, GetWorldBounds())
    call TriggerRegisterEnterRegion(t, r, Condition(function DYCDummyFilter))
    call GroupEnumUnitsInRect(g, GetWorldBounds(), Condition(function DYCDummyFilter))

    call DestroyGroup(g)
    set r = null
    set t = null
    set g = null
endfunction


function DYCAnyUnitRegistTrigger takes trigger trg, integer etype returns nothing
    if trg == null then
        return
    endif

    if AnyUnitEventNumber == 0 then
        set dyc_DummyDieTrigger = CreateTrigger()
        set bj_DYCDummyGroup=CreateGroup()
        call TriggerRegisterAnyUnitEventBJ( dyc_DummyDieTrigger, EVENT_PLAYER_UNIT_DEATH )
        call TriggerAddAction(dyc_DummyDieTrigger, function DummyDieActions)
        call DYCDummyEnumUnit()
    endif

    set AnyUnitEventQueue[AnyUnitEventNumber] = trg
    set AnyUnitEventType[AnyUnitEventNumber]=etype
    set AnyUnitEventNumber = AnyUnitEventNumber + 1
endfunction

/////////////////events
function DYCAnyUnitChargedRegistTrigger takes trigger trg returns nothing
    call DYCAnyUnitRegistTrigger(trg,1)
endfunction

function DYCAnyUnitChargeOverRegistTrigger takes trigger trg returns nothing
    call DYCAnyUnitRegistTrigger(trg,2)
endfunction

function DYCAnyUnitChargeStopRegistTrigger takes trigger trg returns nothing
    call DYCAnyUnitRegistTrigger(trg,3)
endfunction

function DYCAnyUnitDDOverRegistTrigger takes trigger trg returns nothing
    call DYCAnyUnitRegistTrigger(trg,4)
endfunction

///////////////variables
function GetDYCChargeName takes nothing returns string
    return  bj_GetDYCChargeName
endfunction

function GetDYCChargedUnit takes nothing returns unit
    return  bj_GetDYCChargedUnit
endfunction

function GetDYCChargingUnit takes nothing returns unit
    return  bj_GetDYCChargingUnit
endfunction

function GetDYCDDUnit takes nothing returns unit
    return  bj_GetDYCDDUnit
endfunction

function GetDYCDDSUnit takes nothing returns unit
    return  bj_GetDYCDDSUnit
endfunction

function GetDYCDDValue takes nothing returns real
    return  bj_GetDYCDDValue
endfunction





endlibrary

#endif /// DYCTriggerEventIncluded
