#ifndef CreateAssUnitIncluded
#define CreateAssUnitIncluded
library CreateAssUnit
    function CreateAssUnit takes player p,integer uid,real x,real y,real t,integer aid,integer l returns nothing
         set bj_lastCreatedUnit=CreateUnit(p,uid,x,y,0)
         call UnitApplyTimedLife(bj_lastCreatedUnit,'BTLF',t)
         call UnitAddAbility(bj_lastCreatedUnit,aid)
         call SetUnitAbilityLevel(bj_lastCreatedUnit,aid,l)
    endfunction
endlibrary
#endif
