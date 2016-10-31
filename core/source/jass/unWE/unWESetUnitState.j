#ifndef unWESetUnitStateIncluded
#define unWESetUnitStateIncluded

library unWESetUnitState
    
    function unWESetUnitState takes unit whichUnit, unitstate whichState,string mod, real Val returns nothing
        local real newVal
        local real oldVal = GetUnitState(whichUnit,whichState)        
        if(mod == "=") then
            set newVal = Val    
        elseif(mod == "+") then 
            set newVal = oldVal + Val
        elseif(mod == "-") then 
            set newVal = oldVal - Val
            set newVal = RMaxBJ(newVal,0.406)
        endif
        call SetUnitState(whichUnit,whichState,newVal)  
    endfunction

endlibrary

#endif /// unWESetUnitStateIncluded
