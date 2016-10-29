#include "TCMain.j"
#include "TCTimerUtils.j"

library_once TCTimerSystem initializer Init requires TCMain,TCTimerUtils

    #define CreateTimer NewTimer
    #define DestroyTimer ReleaseTimer

    private struct tctimer
        public timer t
        public real x
        public real y
        public real rad
        public real dist
        public integer loopn
        public integer loopt
        public unit u1
        public unit u2
        public boolean flag1
        public boolean flag2
        public boolean flag3
        public boolean flag4
        public boolean flag5
        public string str
        public string strg
        public string strw
        
        static method CreateTCTimer takes nothing returns thistype
            local thistype tct=thistype.allocate()
            set tct.t=CreateTimer()
            call SetTimerData(tct.t,integer(tct))
            return tct
        endmethod
        
        method onDestroy takes nothing returns nothing            
            call DestroyTimer(t)
            set t=null
            set u1=null
            set u2=null
            set str=null
            set strg=null
            set strw=null
        endmethod
        
    endstruct
    
    globals
        private integer bindindex
        private integer bindtimer
    endglobals 
    
    private function TCBeatBackTimer takes nothing returns nothing
        local tctimer tct=tctimer(GetTimerData(GetExpiredTimer()))
        if tct.loopn>=tct.loopt then
            if tct.flag2 then 
                call PauseUnit(tct.u1,false)
            endif
            if tct.flag3 then
                call SetUnitPathing(tct.u1,true)
            endif
            call tct.destroy()
            return
        endif
        set tct.loopn=tct.loopn+1
        if tct.flag1 then
            set tct.x=tct.x+tct.dist*Cos(tct.rad)
            set tct.y=tct.y+tct.dist*Sin(tct.rad)
        else   
            set tct.x=GetUnitX(tct.u1)+tct.dist*Cos(tct.rad)
            set tct.y=GetUnitY(tct.u1)+tct.dist*Sin(tct.rad)
        endif
        call SetUnitX(tct.u1,tct.x)
        call SetUnitY(tct.u1,tct.y)
        if tct.str!=null and tct.str!=TCMain_emptyStr then
            if IsTerrainPathable(tct.x,tct.y,PATHING_TYPE_FLOATABILITY) then
                if tct.strg!=null and tct.strg!=TCMain_emptyStr then
                    call DestroyEffect(AddSpecialEffectTarget(tct.strg,tct.u1,tct.str))
                endif
            else  
                if tct.strw!=null and tct.strw!=TCMain_emptyStr then
                    call DestroyEffect(AddSpecialEffectTarget(tct.strw,tct.u1,tct.str))
                endif
            endif
        endif
    endfunction    
    
    public function TCBeatBackRegister takes unit whichUnit , real time , real timeout , real distance , real rad , boolean lockedFlag , boolean pauseFlag , boolean pathFlag , string effectPos , string effectGround , string effectWater returns nothing
        local tctimer tct
        local integer i
        if timeout>0 then
            set i=R2I(time/timeout)
        else
            set i=0
        endif
        if time<=0 or timeout<=0 or i==0 then
            //error
            call SetUnitX(whichUnit,GetUnitX(whichUnit)+distance*Cos(rad))
            call SetUnitY(whichUnit,GetUnitY(whichUnit)+distance*Sin(rad))
            debug call BJDebugMsg("Do not set time or timeout or R2I(time/timeout) <= 0.00")
            return
        endif
        set tct=tctimer.CreateTCTimer()
        set tct.u1=whichUnit
        if pauseFlag then 
            call PauseUnit(whichUnit,true)
        endif
        if pathFlag then
            call SetUnitPathing(whichUnit,false)
        endif
        if lockedFlag then
            set tct.x=GetUnitX(whichUnit)
            set tct.y=GetUnitY(whichUnit)
        endif
        set tct.rad=rad
        set tct.loopt=i
        set tct.loopn=0
        set tct.dist=distance/I2R(i)
        set tct.flag1=lockedFlag
        set tct.flag2=pauseFlag
        set tct.flag3=pathFlag
        if effectPos!=null and effectPos!=TCMain_emptyStr then
            set tct.str=effectPos
        endif
        if effectGround!=null and effectGround!=TCMain_emptyStr then
            set tct.strg=effectGround
        endif
        if effectWater!=null and effectWater!=TCMain_emptyStr then
            set tct.strw=effectWater
        endif
        call TimerStart(tct.t,timeout,true,function TCBeatBackTimer)
    endfunction
    
    /*public function TCBindCancel takes unit whichUnit returns nothing
        local integer h=GetHandleId(whichUnit)
        local timer t
        if LoadInteger(TCHash,h,bindindex)==1 then
            set t=LoadTimer(TCHash,h,bindtimer)
            if t!=null then
                call FlushChildHashtable(TCHash,GetHandleId(t))
                call DestroyTimer(t)
                set t=null
                call SaveInteger(TCHash,h,bindindex,0)
            endif
        endif
    endfunction*/
    
    /*public function TCBindRegister takes unit vestUnit , unit whichUnit , real time , real timeout returns nothing
        local timer t
        local integer h
        local timer t
        local integer h
        local integer i
        call TCBindCancel(vestUnit)
        if time==0.0 then
            set i=-1
        elseif timeout>0 then
            set i=R2I(time/timeout)
        else
            set i=0
        endif
        if time<0 or timeout<=0 or i==0 then
            //error
            call SetUnitX(vestUnit,GetUnitX(whichUnit))
            call SetUnitY(vestUnit,GetUnitY(whichUnit))
            debug call BJDebugMsg("Do not set time or timeout or R2I(time/timeout) <= 0.00 (especially when time==0 the timer would be unlimited)")
            return
        endif
        set t=CreateTimer()
        set h=GetHandleId(t)
        call FlushChildHashtable(TCHash,h)
        call SaveUnitHandle(TCHash,h,0,vestUnit)
        call SaveUnitHandle(TCHash,h,1,whichUnit)
        call Save
    endfunction*/
    
    private function Init takes nothing returns nothing
        //set bindindex=StringHash("TCBindIndex")
        //set bindtimer=StringHash("TCBindTimer")
    endfunction                                        

    #undef CreateTimer
    #undef DestroyTimer

endlibrary
