#ifndef unWEStringFormulaIncluded
#define unWEStringFormulaIncluded

library unWEStringFormula requires YDWEStringFormula
    
    function unWENewItemsFormula_2 takes integer type1, integer type2, integer eventually returns nothing
        call YDWENewItemsFormula(type1,1,type2,1,0,0,0,0,0,0,0,0,eventually)
    endfunction
    
    function unWENewItemsFormula_3 takes integer type1, integer type2, integer type3, integer eventually returns nothing
        call YDWENewItemsFormula(type1,1,type2,1,type3,1,0,0,0,0,0,0,eventually)
    endfunction

endlibrary

#endif /// unWEStringFormulaIncluded
