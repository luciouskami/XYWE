#ifndef GetItemCostInitIncluded
#define GetItemCostInitIncluded
library GetItemCostInit
globals
    private unit S
    private rect r
endglobals
private function removeitem takes nothing returns nothing
    call RemoveItem(GetEnumItem())
endfunction
function GetItemCostInit takes integer s returns nothing
    call SetPlayerState(Player(15),PLAYER_STATE_RESOURCE_GOLD,1000000)
    call SetPlayerState(Player(15),PLAYER_STATE_RESOURCE_LUMBER,1000000)
    set S=CreateUnit(Player(15),s,GetRectMaxX(bj_mapInitialPlayableArea)-32,GetRectMaxY(bj_mapInitialPlayableArea)-32,0)
    set r=Rect(GetUnitX(S)-32,GetUnitY(S)-32,GetUnitX(S)+32,GetUnitY(S)+32)
endfunction
function GetItemCost takes integer id,boolean b returns integer
    local integer a
    call AddItemToStock(S,id,1,1)
    call IssueNeutralImmediateOrderById(Player(15),S,id)
    call EnumItemsInRect(r,null,function removeitem)
    if b then
        set a=1000000-GetPlayerState(Player(15),PLAYER_STATE_RESOURCE_GOLD)
        call SetPlayerState(Player(15),PLAYER_STATE_RESOURCE_GOLD,1000000)
    else
        set a=1000000-GetPlayerState(Player(15),PLAYER_STATE_RESOURCE_LUMBER)
        call SetPlayerState(Player(15),PLAYER_STATE_RESOURCE_LUMBER,1000000)
    endif
    return a
endfunction
endlibrary
#endif
