#ifndef SetUnitPathingAllIncluded
#define SetUnitPathingAllIncluded
library SetUnitPathingAll
function SetUnitPathingAll takes unit u,boolean b returns nothing
if GetUnitAbilityLevel(u,'Atwa') < 1 then
call UnitAddAbility( u, 'Atwa' )
call UnitRemoveAbility( u, 'Atwa' )
if b==true then
call ShowUnit(u,false)
call ShowUnit(u,true)
endif
endif
endfunction
endlibrary
#endif