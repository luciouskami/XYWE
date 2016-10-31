#ifndef CustomDefeatExIncluded
#define CustomDefeatExIncluded
library CustomDefeatEx initializer init
globals
    private trigger t
    private dialog d=DialogCreate()
endglobals
private function init takes nothing returns nothing
    if bj_isSinglePlayer then
        set t = CreateTrigger()
        call TriggerRegisterDialogButtonEvent( t, DialogAddButton(d, GetLocalizedString( "GAMEOVER_RESTART" ),82) )
        call TriggerAddAction( t, function CustomDefeatRestartBJ )
        if (GetGameDifficulty() != MAP_DIFFICULTY_EASY) then
            set t = CreateTrigger()
            call TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_REDUCE_DIFFICULTY" ),68) )
            call TriggerAddAction( t, function CustomDefeatReduceDifficultyBJ )
        endif
        set t = CreateTrigger()
        call TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_LOAD" ),76))
        call TriggerAddAction( t, function CustomDefeatLoadBJ )
    endif
    set t = CreateTrigger()
    call TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_QUIT_MISSION" ),81) )
    call TriggerAddAction( t, function CustomDefeatQuitBJ )
endfunction
function CustomDefeatEx takes player whichPlayer,string message returns nothing
    if not IsNoDefeatCheat() then
        call RemovePlayer(whichPlayer, PLAYER_GAME_RESULT_DEFEAT )
        if not bj_isSinglePlayer then
            call DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, GetLocalizedString("PLAYER_DEFEATED"))
        endif
        if (GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
            call DialogSetMessage(d,message)
            if (GetLocalPlayer()==whichPlayer) then
                call EnableUserControl( true )
                if bj_isSinglePlayer then
                    call PauseGame( true )
                endif
                call EnableUserUI(false)
                call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UI, 1.0)
                call StartSound(bj_defeatDialogSound)
            endif
            call DialogDisplay( whichPlayer, d, true )
        endif
    endif
endfunction
endlibrary
#endif
