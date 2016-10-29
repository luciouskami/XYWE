#ifndef unWEUnitDamageTargetIncluded 
#define unWEUnitDamageTargetIncluded 

library unWEUnitDamageTarget

function unWEUnitDamageTarget takes unit whichUnit, unit target, real amount, string mod, attacktype whichAttack, damagetype whichDamage, weapontype whichWeapon returns boolean
    local boolean attack
    local boolean ranged
    if(mod == "Melee") then
        set attack = TRUE
        set ranged = FALSE
    elseif(mod == "Range") then
        set attack = TRUE
        set ranged = TRUE
    elseif(mod == "Spell") then
        set attack = FALSE
        set ranged = FALSE
    endif         
    return UnitDamageTarget(whichUnit,target,amount,attack,ranged,whichAttack,whichDamage,whichWeapon)
endfunction

endlibrary

#endif ///unWEUnitDamageTargetIncluded 
