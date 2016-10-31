#ifndef unWEOperatorRIIncluded
#define unWEOperatorRIIncluded 
//===========================================================================
//À„ ı‘ÀÀ„ (RI) 
//===========================================================================

library unWEOperatorRI
function unWEOperatorRI takes real left, string operator, integer right returns nothing

    if(operator=="+") then
        return left + right
    elseif(operator=="-") then
        return left - right
    elseif(operator=="*") then
        return left * right
    elseif(operator=="/") then
        return left / right
    endif
        return 0.
 
endfunction
endlibrary
 
#endif /// unWEOperatorRIIncluded
