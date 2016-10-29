#ifndef unWESetUnitPositionByVectorIncluded
#define unWESetUnitPositionByVectorIncluded

library unWESetUnitPositionByVector
    
    function unWESetUnitPositionByVector takes unit whichUnit, real dist, real angle, string mod returns nothing
        local real x = GetUnitX(whichUnit) + dist * Cos(angle * bj_DEGTORAD)
        local real y = GetUnitY(whichUnit) + dist * Sin(angle * bj_DEGTORAD)        
        if(mod == "Loc") then
            call SetUnitPosition(whichUnit,x,y)    
        elseif(mod == "Cxy") then 
            call SetUnitX(whichUnit,x)
            call SetUnitY(whichUnit,y)
        endif  
    endfunction

endlibrary

#endif /// unWESetUnitPositionByVectorIncluded
