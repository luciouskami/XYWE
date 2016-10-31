#define PrintToAllPlayer(s) DisplayTextToPlayer(GetLocalPlayer(),0,0,s)
#define AddMoney(p,n) SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+n)
#define SubMoney(p,n) SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)-n)
