#ifndef WMSlkAbilitysIncluded
#define WMSlkAbilitysIncluded
#include "WM/WMRush.j"
library WMSlkAbilitys uses WMRush
globals
    hashtable WMSlkAbilitysData=InitHashtable()
endglobals
function SpellWMAbilitysAction takes nothing returns nothing
    local integer id=GetSpellAbilityId()
    local unit u=GetTriggerUnit()
    local integer i=GetUnitAbilityLevel(u,id)
    local real x=GetUnitX(u)
    local real y=GetUnitY(u)
    local real x0=GetSpellTargetX()
    local real y0=GetSpellTargetY()
    local real d=Atan2(y0-y,x0-x)*bj_RADTODEG
    if LoadBoolean(WMSlkAbilitysData,id,0) then
        call WMRush(u,d,LoadInteger(WMSlkAbilitysData,id,i),LoadInteger(WMSlkAbilitysData,id,100+i),300,LoadInteger(WMSlkAbilitysData,id,200+i), true, false,0,4,u,LoadStr(WMSlkAbilitysData,id,1))
    endif
    set u=null
endfunction
function InitSlkAbilitysData takes nothing returns nothing
    local trigger t=CreateTrigger()
<?
SLK = require 'slk'
for alias, Obj in pairs(SLK.ability) do
    if alias == 'WMRu' or Obj['code'] == 'WMRu' then
        for k, v in pairs(Obj) do
            log.debug(k)
            log.debug(v)
        end
        local modelPath = string.gsub(Obj['SpecialArt'], "\\", "\\\\")
?>
call SaveBoolean(WMSlkAbilitysData,'<?=alias?>',0,true)
call SaveStr(WMSlkAbilitysData,'<?=alias?>',1,"<?=modelPath?>")//路径特效
<?
        for i = 1, Obj['levels'] do
?>
call SaveInteger(WMSlkAbilitysData,'<?=alias?>',<?=i?>,<?=Obj['DataA'..i]?>)//冲锋距离
call SaveInteger(WMSlkAbilitysData,'<?=alias?>',<?=i+100?>,<?=Obj['DataB'..i]?>)//冲锋速度
call SaveInteger(WMSlkAbilitysData,'<?=alias?>',<?=i+200?>,<?=Obj['DataC'..i]?>)//冲锋伤害
<?
        end
    end
end
?>
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function SpellWMAbilitysAction))
    set t=null
endfunction
endlibrary

#endif

