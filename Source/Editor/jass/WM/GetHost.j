#ifndef GetHostIncluded
#define GetHostIncluded
library GetHost initializer InitGetHost
globals
    private player Host=Player(0)
endglobals
function GetHost takes nothing returns player
    return Host
endfunction
private function InitGetHost takes nothing returns nothing
    local gamecache g=InitGameCache("map.w3v")
    call StoreInteger(g,"Map","Host",GetPlayerId(GetLocalPlayer()))
    call TriggerSyncStart()
    call SyncStoredInteger(g,"Map","Host")
    call TriggerSyncReady()
    set Host=Player(GetStoredInteger(g,"Map","Host"))
    call FlushGameCache(g)
    set g=null
endfunction
endlibrary
#endif
