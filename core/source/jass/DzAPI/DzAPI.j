#ifndef DZAPIINCLUDE
#define DZAPIINCLUDE

library DzAPI

    native DzAPI_Map_SaveServerValue        takes player whichPlayer, string key, string value returns boolean
    native DzAPI_Map_GetServerValue         takes player whichPlayer, string key returns string
    native DzAPI_Map_IsRPGLobby             takes nothing returns boolean
    native DzAPI_Map_Stat_SetStat           takes player whichPlayer, string key, string value returns nothing
    native DzAPI_Map_GetMapLevel            takes player whichPlayer returns integer
    native DzAPI_Map_GetGameStartTime       takes nothing returns integer

    function DzAPI_Map_StoreBoolean takes player whichPlayer, string key, boolean value returns nothing
        set key="B"+key
        if(value)then
            call DzAPI_Map_SaveServerValue(whichPlayer,key,"1")
        else
            call DzAPI_Map_SaveServerValue(whichPlayer,key,"0")
        endif
        set key=null
        set whichPlayer=null
    endfunction

    function DzAPI_Map_GetStoredBoolean takes player whichPlayer, string key returns boolean
        local boolean value
        set key="B"+key
        set key=DzAPI_Map_GetServerValue(whichPlayer,key)
        if(key=="1")then
            set value=true
        else
            set value=false
        endif
        set key=null
        set whichPlayer=null
        return value
    endfunction

    function DzAPI_Map_StoreInteger takes player whichPlayer, string key, integer value returns nothing
        set key="I"+key
        call DzAPI_Map_SaveServerValue(whichPlayer,key,I2S(value))
        set key=null
        set whichPlayer=null
    endfunction

    function DzAPI_Map_GetStoredInteger takes player whichPlayer, string key returns integer
        local integer value
        set key="I"+key
        set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
        set key=null
        set whichPlayer=null
        return value
    endfunction

    function DzAPI_Map_StoreReal takes player whichPlayer, string key, real value returns nothing
        set key="R"+key
        call DzAPI_Map_SaveServerValue(whichPlayer,key,R2S(value))
        set key=null
        set whichPlayer=null
    endfunction
    function DzAPI_Map_GetStoredReal takes player whichPlayer, string key returns real
        local real value
        set key="R"+key
        set value=S2R(DzAPI_Map_GetServerValue(whichPlayer,key))
        set key=null
        set whichPlayer=null
        return value
    endfunction

    function DzAPI_Map_StoreString takes player whichPlayer, string key, string value returns nothing
        set key="S"+key
        call DzAPI_Map_SaveServerValue(whichPlayer,key,value)
        set key=null
        set whichPlayer=null
    endfunction

    function DzAPI_Map_GetStoredString takes player whichPlayer, string key returns string
        return DzAPI_Map_GetServerValue(whichPlayer,"S"+key)
    endfunction

    function DzAPI_Map_StoreUnitId takes player whichPlayer, string key, integer value returns nothing
        set key="U"+key
        call DzAPI_Map_SaveServerValue(whichPlayer,key,I2S(value))
        set key=null
        set whichPlayer=null
    endfunction

    function DzAPI_Map_GetStoredUnitId takes player whichPlayer, string key returns integer
        local integer value
        set key="U"+key
        set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
        set key=null
        set whichPlayer=null
        return value
    endfunction

    function DzAPI_Map_StoreAbilityId takes player whichPlayer, string key, integer value returns nothing
        set key="A"+key
        call DzAPI_Map_SaveServerValue(whichPlayer,key,I2S(value))
        set key=null
        set whichPlayer=null
    endfunction

    function DzAPI_Map_GetStoredAbilityId takes player whichPlayer, string key returns integer
        local integer value
        set key="A"+key
        set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
        set key=null
        set whichPlayer=null
        return value
    endfunction

    function DzAPI_Map_StoreItemId takes player whichPlayer, string key, integer value returns nothing
        set key="W"+key
        call DzAPI_Map_SaveServerValue(whichPlayer,key,I2S(value))
        set key=null
        set whichPlayer=null
    endfunction

    function DzAPI_Map_GetStoredItemId takes player whichPlayer, string key returns integer
        local integer value
        set key="W"+key
        set value=S2I(DzAPI_Map_GetServerValue(whichPlayer,key))
        set key=null
        set whichPlayer=null
        return value
    endfunction

    function DzAPI_Map_FlushStoredMission takes player whichPlayer, string key returns nothing
        call DzAPI_Map_SaveServerValue(whichPlayer,key,null)
        set key=null
        set whichPlayer=null
    endfunction

endlibrary

#endif
