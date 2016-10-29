#ifndef unWEUnitAddAbilityIncluded 
#define unWEUnitAddAbilityIncluded 

library unWEUnitAddAbility

function unWEUnitAddAbility takes unit whichUnit, integer skill, integer level, boolean permanent returns nothing
    call UnitAddAbility(whichUnit,skill)
    call SetUnitAbilityLevel(whichUnit,skill,level)
    call UnitMakeAbilityPermanent(whichUnit,permanent,skill)
endfunction

endlibrary

#endif ///unWEUnitAddAbility
