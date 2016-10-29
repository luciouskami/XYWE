#ifndef unWEDummyCasterIncluded 
#define unWEDummyCasterIncluded 

library unWEDummyCaster
//! external ObjectMerger w3u uloc uDMC unam "Dummy Caster" uprw 180 umpm 100000 umpi 100000
globals
    unit unWE_lastCreatedDummy   
endglobals

function unWECreatDummyCaster takes player whichPlayer,location loc returns unit
    local real x = GetLocationX(loc)
    local real y = GetLocationY(loc)
    set unWE_lastCreatedDummy = CreateUnit(whichPlayer,'uDMC',x,y,0)
    call ShowUnit(unWE_lastCreatedDummy,false)
    //call SetUnitX(unWE_lastCreatedDummy,x)
    //call SetUnitY(unWE_lastCreatedDummy,y) 
    return unWE_lastCreatedDummy
endfunction


function unWEGetLastCreatedDummy takes nothing returns unit
    return unWE_lastCreatedDummy
endfunction

endlibrary

#endif ///unWEDummyCasterIncluded 
