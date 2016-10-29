globals
    hashtable WMHT=InitHashtable()
endglobals
//! textmacro I2H takes Name,type
function WMI2$Name$ takes integer i returns $type$
    call SaveFogStateHandle(WMHT,0,0,ConvertFogState(i))
    return Load$Name$Handle(WMHT,0,0)
endfunction
//! endtextmacro
//! runtextmacro I2H("Unit","unit")
//! runtextmacro I2H("Item","item")
//! runtextmacro I2H("Destructable","destructable")
//! runtextmacro I2H("Effect","effect")
//! runtextmacro I2H("Trigger","trigger")
//! runtextmacro I2H("Timer","timer")
//! runtextmacro I2H("Group","group")
//! runtextmacro I2H("Location","location")
//! runtextmacro I2H("Force","force")
//! runtextmacro I2H("Rect","rect")
//! runtextmacro I2H("MultiboardItem","multiboarditem")
//! runtextmacro I2H("TriggerEvent","event")
//! runtextmacro I2H("TriggerCondition","triggercondition")
//! runtextmacro I2H("TriggerAction","triggeraction")
//! runtextmacro I2H("TimerDialog","timerdialog")
//! runtextmacro I2H("Region","region")
