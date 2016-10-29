#ifndef IsUnitInvulnerableIncluded
#define IsUnitInvulnerableIncluded
library IsUnitInvulnerable
function IsUnitInvulnerable takes unit u returns boolean
    local real h = GetUnitState(u,UNIT_STATE_LIFE)
    call UnitDamageTarget(u,u,0.01,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
    if GetUnitState(u,UNIT_STATE_LIFE) < h then
        call SetUnitState(u,UNIT_STATE_LIFE,h) 
        return false
    endif
    return true
endfunction
endlibrary
#endif
