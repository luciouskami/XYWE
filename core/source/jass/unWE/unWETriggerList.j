#ifndef unWETriggerListIncluded
#define unWETriggerListIncluded

//===========================================================================
//触发器 - 触发器列表 
//===========================================================================
library unWETriggerList
globals
    private hashtable Data = InitHashtable()
    integer unWE_lastCreatedEventDataKey
endglobals

function unWETriggerListAddNew takes trigger trig, string tag returns nothing
//触发器添加事件(添加标签) 
    local integer key = StringHash(tag)
    local integer flag = LoadInteger(Data,key,0) + 1
    call SaveInteger(Data,key,0,flag)
    call SaveTriggerHandle(Data,key,flag,trig)
endfunction

private function CleanupCache takes nothing returns nothing
//定时清理缓存
    local integer tempKey
    local timer tm = GetExpiredTimer()
    local integer tmId = GetHandleId(tm)
    local integer flag = LoadInteger(Data,tmId,0)
    local integer index = 1
    loop
        exitwhen index > flag
        set tempKey = LoadInteger(Data,tmId,index)
        call FlushChildHashtable(Data,tempKey) 
    endloop
    call FlushChildHashtable(Data,tmId)
    call DestroyTimer(tm)
    set tm = null     
endfunction

function unWETriggerListExecute takes string tag returns nothing
    local integer key = StringHash(tag)
    local integer flag = LoadInteger(Data,key,0)
    local trigger trig
    local timer tm = CreateTimer()
    local integer tmId = GetHandleId(tm) 
    local integer tempKey
    local integer index = 1  
    loop
        exitwhen index > flag
        set trig = LoadTriggerHandle(Data,key,index)
        call ConditionalTriggerExecute(trig)
        set tempKey = GetHandleId(trig)*GetTriggerExecCount(trig)
        call SaveInteger(Data,tempKey,0,tmId)
        call SaveInteger(Data,tmId,index,tempKey)
        set index = index + 1
    endloop
    set unWE_lastCreatedEventDataKey = tmId
    call SaveInteger(Data,tmId,0,flag)
    call TimerStart(tm,60,false,CleanupCache)
    set trig = null
    set tm = null 
endfunction

function unWESaveTriggerDataUnit takes string tag, unit whichUnit returns nothing
    local integer key = unWE_lastCreatedEventDataKey
    local integer val = StringHash(tag)
    call SaveUnitHandle(Data,key,val,whichUnit)
endfunction

function unWELoadTriggerDataUnit takes string tag returns unit
    local trigger trig = GetTriggeringTrigger()
    local integer tempKey = GetHandleId(trig)*GetTriggerExecCount(trig)
    local integer key = LoadInteger(Data,tempKey,0)
    local integer val = StringHash(tag)
    return LoadUnitHandle(Data,key,val)
endfunction 
endlibrary  
 
#endif /// unWETriggerListIncluded
