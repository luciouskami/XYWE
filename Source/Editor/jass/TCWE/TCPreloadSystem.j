#ifndef TCPreloadSystemIncluded
#define TCPreloadSystemIncluded

#include "TCWE/TCMain.j"
#include "TCWE/TCTimerUtils.j"

library_once TCPreloadSystem initializer Init requires TCTimerUtils
    
    /*************************************************************\
    |                                                             |
    |              天才Preload存档管理系统                        |
    |                  Version 3.1                                |
    |              作者：天才_IMBA(2589503981)                    |
    |              鸣谢：晓峰(2283442644)                         |
    |                    忍草(945684729)                          |
    |                                                             |
    \*************************************************************/    
    
    //v3.1
    //优化加密
    
    //v3.0
    //优化计时器，接口
    
    //v2.1
    //修复BUG
    
    //v2.0
    //制作接口
    
    //v1.0
    //系统构架
    
    globals
        public integer tccode
        public integer code0
        public integer code1
        public integer code2
        //public string emptyStr
    endglobals
    
    private struct preloadtimer
    
        timer t
        integer time
        integer p
        player pl
        string path
        boolean flag
        
        static method create takes integer p returns thistype
            local thistype t=thistype.allocate()
            set t.t=NewTimer()
            set t.time=0
            set t.p=p
            call SetTimerData(t.t,integer(t))
            return t
        endmethod
        
        method onDestroy takes nothing returns nothing
            call ReleaseTimer(.t)
            set .t=null
        endmethod
        
    endstruct
    
    public function I2Code takes integer num returns nothing
        if num>0 then
            set code1=num/tccode
            set code2=num-code1*tccode+tccode+1
        else
            set code1=-num/tccode
            set code2=num+code1*tccode+tccode
        endif
        set code0=ModuloInteger(code1+code2,ModuloInteger(code1,tccode)+ModuloInteger(code2,tccode)+1)
    endfunction
    
    public function Code2I takes integer code1 , integer code2 returns integer
        if code2>tccode*2 then
            return 0
        endif
        if code2>tccode then
            return code1*tccode+code2-tccode-1
        endif
        return -code1*tccode+code2-tccode
    endfunction
    
    public struct preload[11100]
        
        string array savedStr[32]
        boolean array stringFlag[16]
        integer array savedInt[1000]
        integer Type
        boolean succeed
        static integer lastCreatedPreload
        static boolean IsLoadingProcessing
        
        method clear takes nothing returns nothing
            local integer i=0
            set .Type=0
            set .succeed=false
            loop
                exitwhen i>=1000
                set .savedInt[i]=0
                set i=i+1
            endloop
            set i=0
            loop
                exitwhen i>=16
                set .savedStr[i]=TCMain_emptyStr
                set .stringFlag[i]=false
                set i=i+1
            endloop            
            debug call BJDebugMsg("Preload "+I2S(integer(this))+" has been cleared")
        endmethod
    
        static method create takes nothing returns thistype
            local thistype p=thistype.allocate()
            debug call BJDebugMsg("Preload "+I2S(integer(p))+" has been created")
            call p.clear()
            set lastCreatedPreload=integer(p)
            return p
        endmethod
        
        method onDestroy takes nothing returns nothing
            debug call BJDebugMsg("Preload "+I2S(integer(this))+" has been destroyed")
        endmethod
        
        method SetType takes integer i returns boolean
            if .Type==0 then
                set .Type=i
                return true
            endif
            debug call BJDebugMsg("error : Preload type redeclared")
            return false
        endmethod
                
        method AddInt takes integer index , integer i returns boolean
            if .Type==0 then
                set .Type=1
            elseif .Type==2 then
                debug call BJDebugMsg("error : Preload type is wrong")
                return false
            endif
            if index<1000 and index>=0 then
                set .savedInt[index]=i
            else
                debug call BJDebugMsg("error : index is too large")
                return false
            endif
            return true
        endmethod
        
        method AddStr takes integer index , string s returns boolean
            if .Type==0 then
                set .Type=1
            elseif .Type==2 then
                debug call BJDebugMsg("error : Preload type is wrong")
                return false
            endif
            if index<16 and index>=0 and s!=null and s!=TCMain_emptyStr then
                set .savedStr[index]=s
                set .stringFlag[index]=true
            else
                set .stringFlag[index]=false
                debug call BJDebugMsg("error : index is too large or string is empty")
                return false
            endif
            return true
        endmethod
        
        method GetInt takes integer index returns integer
            if index<1000 and index>=0 then
                return .savedInt[index]
            endif
            debug call BJDebugMsg("error : index is too large")
            return 0
        endmethod
        
        method GetStr takes integer index returns string
            if index<16 and index>=0 then
                return .savedStr[index]
            endif
            debug call BJDebugMsg("error : index is too large")
            return TCMain_emptyStr
        endmethod
        
        static method SaveTimer takes nothing returns nothing
            local preloadtimer t=preloadtimer(GetTimerData(GetExpiredTimer()))
            local thistype p=thistype(t.p)
            local integer i1
            local integer i2
            if t.time<10 then
                if t.pl==GetLocalPlayer() then
                    set i1=t.time*100
                    set i2=i1+99
                    loop
                        exitwhen i1>i2
                        if p.savedInt[i1]!=0 then
                            call I2Code(p.savedInt[i1])
call Preload("\" )
call SetPlayerTechMaxAllowed(Player(13),"+I2S(i1)+","+I2S(code0)+")
call SetPlayerTechMaxAllowed(Player(14),"+I2S(i1)+","+I2S(code1)+")
call SetPlayerTechMaxAllowed(Player(15),"+I2S(i1)+","+I2S(code2)+")
//")
                        endif
                        set i1=i1+1
                    endloop
                endif
                set t.time=t.time+1
            else
                if t.pl==GetLocalPlayer() then
                    call PreloadGenEnd(t.path)
                endif
                debug call BJDebugMsg("Preload "+I2S(integer(p))+" has been saved")
                call t.destroy()
            endif
        endmethod
        
        method Save takes player pl , string path returns boolean
            local integer i=0
            local preloadtimer t
            if .Type==2 then
                debug call BJDebugMsg("error : Preload type is wrong")
                return false
            endif
            set .Type=1
            if pl==GetLocalPlayer() then
                call PreloadGenClear()
                call PreloadGenStart()
                call PreloadEnd(0.2)
                call PreloadRefresh()
                call PreloadStart()
                loop
                    exitwhen i>=16
                    if .stringFlag[i] then
call Preload("\" )
call SetPlayerName(Player("+I2S(i)+"),\""+.savedStr[i]+"\")
call SetPlayerTechMaxAllowed(Player(15),"+I2S(i+1000)+","+I2S(10)+")
//")
                    endif
                    set i=i+1
                endloop
            endif
            set t=preloadtimer.create(this)
            set t.pl=pl
            set t.path=path
            call TimerStart(t.t,0.01,true,function thistype.SaveTimer)
            return true
        endmethod
        
        static method LoadTimer_2 takes nothing returns nothing
            local preloadtimer t=preloadtimer(GetTimerData(GetExpiredTimer()))
            local thistype p=thistype(t.p)
            local integer i1
            local integer i2
            local integer tech=0
            if t.time<10 then
                set i1=t.time*100
                set i2=i1+99
                loop
                    exitwhen i1>i2
                        set code0=GetPlayerTechMaxAllowed(Player(13),i1)
                        set code1=GetPlayerTechMaxAllowed(Player(14),i1)
                        set code2=GetPlayerTechMaxAllowed(Player(15),i1)
                        if code0!=ModuloInteger(code1+code2,ModuloInteger(code1,tccode)+ModuloInteger(code2,tccode)+1) and code2<=tccode*2 then
                            //call BJDebugMsg(I2S(i1)+" "+I2S(code0)+" "+I2S(ModuloInteger(code1+code2,ModuloInteger(code1,tccode)+ModuloInteger(code2,tccode)+1)))
                            set t.flag=false
                        endif
                        set p.savedInt[i1]=Code2I(code1,code2)
                        call SetPlayerTechMaxAllowed(Player(13),i1,0)
                        call SetPlayerTechMaxAllowed(Player(14),i1,0)
                        call SetPlayerTechMaxAllowed(Player(15),i1,0)
                        /*if i1<10 then
                            call BJDebugMsg(I2S(i1)+" "+I2S(p.savedInt[i1])+" "+I2S(code0)+" "+I2S(code1)+" "+I2S(code2))
                        endif*/     
                    set i1=i1+1
                endloop
                set t.time=t.time+1
            else
                set p.succeed=t.flag
                call t.destroy()
                set thistype.IsLoadingProcessing=false
                debug call BJDebugMsg("Preload "+I2S(integer(p))+" has been loaded")
            endif
        endmethod
        
        static method LoadTimer_1 takes nothing returns nothing
            local preloadtimer t=preloadtimer(GetTimerData(GetExpiredTimer()))
            local thistype p=thistype(t.p)
            local integer i=0
            loop
                exitwhen i>=16
                    if GetPlayerTechMaxAllowed(Player(15),i+1000)==10 then
                        set p.savedStr[i]=GetPlayerName(Player(i))
                        call SetPlayerName(Player(i),p.savedStr[16+i])
                        call SetPlayerTechMaxAllowed(Player(15),i+1000,0)
                    endif
                set i=i+1
            endloop
            call t.destroy()
            set t=preloadtimer.create(integer(p))
            set t.flag=true
            call TimerStart(t.t,0.01,true,function thistype.LoadTimer_2)
        endmethod
        
        method Load takes player pl , string path returns boolean
            local preloadtimer t
            local integer i=0
            if .Type==1 then
                debug call BJDebugMsg("error : Preload type is wrong")
                return false
            endif
            if .IsLoadingProcessing then
                debug call BJDebugMsg("error : Loading is proceesing")
                return false
            endif
            set .Type=2
            set .IsLoadingProcessing=true
            set t=preloadtimer.create(this)
            loop
                exitwhen i>=16
                set .savedStr[i+16]=GetPlayerName(Player(i))
                set i=i+1
            endloop
            if pl==GetLocalPlayer() then
                call Preloader(path)
            endif
            set .succeed=false
            call TimerStart(t.t,0.80,false,function thistype.LoadTimer_1)
            return true
        endmethod
        
    endstruct
    
    public function I2Preload takes integer i returns integer
        return i
    endfunction
    
    public function GetlastCreatedPreload takes nothing returns integer
        return preload.lastCreatedPreload
    endfunction
    
    public function CreatePreload takes nothing returns integer
        local preload p=preload.create()
        return p.lastCreatedPreload
    endfunction
    
    public function DestroyPreload takes integer p returns nothing
        call preload(p).destroy()
    endfunction
    
    public function ClearPreload takes integer p returns nothing
        call preload(p).clear()
    endfunction
    
    public function PreloadSetType takes integer p, integer ptype returns boolean
        return preload(p).SetType(ptype)                                                    
    endfunction 
    
    public function PreloadAddInt takes integer p , integer index , integer i returns boolean
        return preload(p).AddInt(index-1,i)
    endfunction
    
    public function PreloadAddStr takes integer p , integer index , string s returns boolean
        return preload(p).AddStr(index-1,s)
    endfunction
    
    public function PreloadGetInt takes integer p , integer index returns integer
        return preload(p).GetInt(index-1)
    endfunction
    
    public function PreloadGetStr takes integer p , integer index returns string
        return preload(p).GetStr(index-1)
    endfunction
    
    public function SavePreload takes player pl , integer p , string path returns boolean
        return preload(p).Save(pl,path)
    endfunction
    
    public function LoadPreload takes player pl , integer p , string path returns boolean
        return preload(p).Load(pl,path)
    endfunction
    
    public function IsPreloadSucceeded takes integer p returns boolean
        return preload(p).succeed
    endfunction
    
    public function SetCode takes string s returns nothing
        set tccode=ModuloInteger(StringHash(s),825)
    endfunction
    
    private function Init takes nothing returns nothing
        set preload.lastCreatedPreload=0
        set preload.IsLoadingProcessing=false
        call SetCode("zz97825")
        //set emptyStr=""
    endfunction                                        
    
endlibrary

#endif