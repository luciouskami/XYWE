#ifndef SetCameraTargetControllerExIncluded
#define SetCameraTargetControllerExIncluded
library SetCameraTargetControllerEx initializer init
globals
    private constant real dur=1
    private camerasetup camera=CreateCameraSetup()
    private force f=CreateForce()
    private unit array u
endglobals
function SetCameraTargetControllerEx takes player p,unit t,boolean b returns nothing
    if p!=null then
        if b then
            call ForceAddPlayer(f,p)
            set u[GetPlayerId(p)]=t
        else
            call ForceRemovePlayer(f,p)
        endif
    endif
endfunction
private function Control takes nothing returns nothing
    if IsPlayerInForce(GetLocalPlayer(),f) then
        call CameraSetupApplyForceDuration(camera,true,dur)
        call SetCameraTargetController(u[GetPlayerId(GetLocalPlayer())],0,0,false)
        call SetCameraField(CAMERA_FIELD_ROTATION,90,dur)
        call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,1650,dur)
        call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK,304,dur)
        call SetCameraField(CAMERA_FIELD_ROLL,0,dur)
    endif
endfunction
private function init takes nothing returns nothing
    call CameraSetupSetField(camera, CAMERA_FIELD_ZOFFSET, 0.0, 0.0 )
    call CameraSetupSetField(camera, CAMERA_FIELD_ROTATION, 90.0, 0.0 )
    call CameraSetupSetField(camera, CAMERA_FIELD_ANGLE_OF_ATTACK, 304.0, 0.0 )
    call CameraSetupSetField(camera, CAMERA_FIELD_TARGET_DISTANCE, 1650.0, 0.0 )
    call CameraSetupSetField(camera, CAMERA_FIELD_ROLL, 0.0, 0.0 )
    call CameraSetupSetField(camera, CAMERA_FIELD_FIELD_OF_VIEW, 70.0, 0.0 )
    call CameraSetupSetField(camera, CAMERA_FIELD_FARZ, 5000.0, 0.0 )
    call CameraSetupSetDestPosition(camera, 0.0, 0.0, 0.0 )
    call TimerStart(CreateTimer(),1,true,function Control)
endfunction
endlibrary
#endif