#ifndef DYCbaseIncluded
#define DYCbaseIncluded

library DYCbase initializer DYCbaseini



globals
    hashtable UDGht = InitHashtable(  )
    unit bj_DYCUnit1=null
    unit bj_DYCUnit2=null
    real bj_DYCReal1=0
    integer bj_DYCTJudge=0
    unit array dyc_LastSelectedUnit
endglobals




function EnumDesInCircleDYC takes real radius, real x, real y, code actionFunc returns nothing
    local rect r = Rect(x-radius, y-radius, x+radius, y+radius)
    local location loc = Location(x, y)
    if (radius >= 0) then
        set bj_enumDestructableCenter = loc
        set bj_enumDestructableRadius = radius
        call EnumDestructablesInRect(r, filterEnumDestructablesInCircleBJ, actionFunc)
        call RemoveRect(r)
        call RemoveLocation(loc)
    endif
endfunction

//////////////////////////////////////////////////////////////////////
////////////////////useful tools//////////////////////////////////////

function DYCDM takes string s returns nothing
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,60,s)
endfunction

function DYCDebugMsg takes string s returns nothing
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,60,s)
endfunction

function DYCDisBtwCoords takes real x1, real y1, real x2, real y2 returns real
    return SquareRoot(Pow(x1-x2,2)+Pow(y1-y2,2))
endfunction

function DYCDisSqrBtwCoords takes real x1, real y1, real x2, real y2 returns real
    return Pow(x1-x2,2)+Pow(y1-y2,2)
endfunction

function DYCDisBtwCoordNLine takes real x1,real y1,real x2,real y2,real x3,real y3 returns real
    return RAbsBJ((x1-x3)*(y2-y1)-(x1-x2)*(y3-y1))/SquareRoot((y3-y2)*(y3-y2)+(x3-x2)*(x3-x2))
endfunction

function DYCAngleBtwCoords takes real x1, real y1, real x2, real y2 returns real
    return bj_RADTODEG * Atan2(y2-y1, x2-x1)
endfunction


function DYCaddabilityp takes unit u, integer l, integer a, boolean b, boolean bf returns nothing
    if (bf) then
        call SetPlayerAbilityAvailable(GetOwningPlayer(u),a,false)
    endif
    call UnitAddAbility(u,a)
    call UnitMakeAbilityPermanent(u,b,a)
    call SetUnitAbilityLevel(u,a,l)
endfunction


////////////////////useful tools//////////////////////////////////////
//////////////////////////////////////////////////////////////////////


////////AddLightning
private function SysLightningTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local integer j1=LoadInteger(UDGht,hd01,11)
    local integer j2=LoadInteger(UDGht,hd01,12)
    local unit u
    local unit u2
    local lightning l=LoadLightningHandle(UDGht,hd01,0)
    local real x0=LoadReal(UDGht,hd01,3)
    local real y0=LoadReal(UDGht,hd01,4)
    local real z0=LoadReal(UDGht,hd01,5)
    local real x1=LoadReal(UDGht,hd01,6)
    local real y1=LoadReal(UDGht,hd01,7)
    local real z1=LoadReal(UDGht,hd01,8)
    local real t=LoadReal(UDGht,hd01,9)
    local real tf=LoadReal(UDGht,hd01,10)
    local real n=LoadReal(UDGht,hd01,13)
    local real n2=LoadReal(UDGht,hd01,14)
    local real cr=LoadReal(UDGht,hd01,17)
    local real cg=LoadReal(UDGht,hd01,18)
    local real cb=LoadReal(UDGht,hd01,19)
    local real ca=LoadReal(UDGht,hd01,20)
    local real xf1=LoadReal(UDGht,hd01,21)
    local real yf1=LoadReal(UDGht,hd01,22)
    local real zf1=LoadReal(UDGht,hd01,23)
    local real xf2=LoadReal(UDGht,hd01,24)
    local real yf2=LoadReal(UDGht,hd01,25)
    local real zf2=LoadReal(UDGht,hd01,26)
    local boolean bud=LoadBoolean(UDGht,hd01,27)
    local location p
    local location p2
    local real int=0.02
    local real k
    local integer dead=0
    
    set n=n+0.01
    set n2=n2+0.01
    

    
    if n2>=0.02 then
        set n2=0
        if j1==1 then
            set u=LoadUnitHandle(UDGht,hd01,1)
            set p=LoadLocationHandle(UDGht,hd01,15)
            call MoveLocation(p,GetUnitX(u),GetUnitY(u))
            set x0=GetUnitX(u)+xf1
            set y0=GetUnitY(u)+yf1
            set z0=GetLocationZ(p)+GetUnitFlyHeight(u)+zf1
            if (IsUnitType(u,UNIT_TYPE_DEAD)==true) then
                set dead=1
            endif
        endif
        if j2==1 then
            set u2=LoadUnitHandle(UDGht,hd01,2)
            set p2=LoadLocationHandle(UDGht,hd01,16)
            call MoveLocation(p2,GetUnitX(u2),GetUnitY(u2))
            set x1=GetUnitX(u2)+xf2
            set y1=GetUnitY(u2)+yf2
            set z1=GetLocationZ(p2)+GetUnitFlyHeight(u2)+zf2
            if (IsUnitType(u2,UNIT_TYPE_DEAD)==true) then
                set dead=1
            endif
        endif
        if ((j1==1)or(j2==1)) then
            
            call MoveLightningEx(l,false,x0,y0,z0,x1,y1,z1)
        endif
    endif
    
    if (n<t)and(dead==1)and(bud==true) then
        set n=t
    endif
    if n>=t then
        set k=(1-(n-t)/tf)*ca
        call SetLightningColor(l,cr,cg,cb,k)
    endif
    
    if (n>=t+tf)or(l==null) then
        if j1==1 then
            set p=LoadLocationHandle(UDGht,hd01,15)
            call RemoveLocation(p)
        endif
        if j2==1 then
            set p2=LoadLocationHandle(UDGht,hd01,16)
            call RemoveLocation(p2)
        endif        
        call DestroyLightning(l)
        call DestroyTimer(GetExpiredTimer())
    endif    
    
    
    call SaveReal(UDGht,hd01,13,n)
    call SaveReal(UDGht,hd01,14,n)
    
    set p=null
    set p2=null
    set u=null
    set u2=null
    
endfunction

function DYCaddlightning takes string lt, real x0, real y0, real z0, real x1, real y1, real z1, real cr, real cg, real cb, real ca, unit u, unit u2, real t, real tf, boolean bud, real xf1, real yf1, real zf1, real xf2, real yf2, real zf2 returns lightning
//DYC addlightning system
//lt:lightning type. cr,cg,cb,ca:red,green,blue,alpha. t:exist time. tf:fade time. bud:destroy when any unit is dead. xf,yf,zf:coord fix params  
//eg. set udg_l=DYCaddlightning("MFPB",-100,-100,100,100,100,100,1,1,1,0.5,udg_u,udg_u2,3,0.3,false,0,0,60,0,0,60)
    local lightning l=AddLightningEx(lt, false, x0, y0, z0, x1, y1, z1)
    local timer timer1=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer j1=0
    local integer j2=0
    local location p
    local location p2

    set bj_lastCreatedLightning=l
    
    //make sure variables are valid    
    if (tf<0) then
        set tf=0
    endif
    
    //ini
    call SetLightningColor(l,cr,cg,cb,ca)
    if u!=null then
        set j1=1
        call SaveUnitHandle(UDGht,hd01,1,u)
        set p=Location(GetUnitX(u),GetUnitY(u))
        call SaveLocationHandle(UDGht,hd01,15,p)
        call MoveLocation(p,GetUnitX(u),GetUnitY(u))
        set x0=GetUnitX(u)+xf1
        set y0=GetUnitY(u)+yf1
        set z0=GetLocationZ(p)+GetUnitFlyHeight(u)+zf1
    endif
    if u2!=null then
        set j2=1
        call SaveUnitHandle(UDGht,hd01,2,u2)
        set p2=Location(GetUnitX(u2),GetUnitY(u2))
        call SaveLocationHandle(UDGht,hd01,16,p2)
        call MoveLocation(p2,GetUnitX(u2),GetUnitY(u2))
        set x1=GetUnitX(u2)+xf2
        set y1=GetUnitY(u2)+yf2
        set z1=GetLocationZ(p2)+GetUnitFlyHeight(u2)+zf2
    endif
    if (j1==1)or(j2==1) then
        call MoveLightningEx(l,false,x0,y0,z0,x1,y1,z1)
    endif
        
    call SaveLightningHandle(UDGht,hd01,0,l)
    call SaveReal(UDGht,hd01,3,x0)
    call SaveReal(UDGht,hd01,4,y0)
    call SaveReal(UDGht,hd01,5,z0)
    call SaveReal(UDGht,hd01,6,x1)
    call SaveReal(UDGht,hd01,7,y1)
    call SaveReal(UDGht,hd01,8,z1)
    call SaveReal(UDGht,hd01,9,t)
    call SaveReal(UDGht,hd01,10,tf)
    call SaveInteger(UDGht,hd01,11,j1)
    call SaveInteger(UDGht,hd01,12,j2)
    call SaveReal(UDGht,hd01,13,0)
    call SaveReal(UDGht,hd01,14,0)
    call SaveReal(UDGht,hd01,17,cr)
    call SaveReal(UDGht,hd01,18,cg)
    call SaveReal(UDGht,hd01,19,cb)
    call SaveReal(UDGht,hd01,20,ca)
    call SaveReal(UDGht,hd01,21,xf1)
    call SaveReal(UDGht,hd01,22,yf1)
    call SaveReal(UDGht,hd01,23,zf1)
    call SaveReal(UDGht,hd01,24,xf2)
    call SaveReal(UDGht,hd01,25,yf2)
    call SaveReal(UDGht,hd01,26,zf2)
    call SaveBoolean(UDGht,hd01,27,bud)
    call TimerStart(timer1,0.01,true,function SysLightningTimer1)
    
    set p=null
    set p2=null
    set timer1=null
    set u=null
    set u2=null
    return l
    set l=null
    return bj_lastCreatedLightning
    return null

endfunction
///////////////////////////
///////////ini/////////////
private function SysDYCPlayerSelection takes nothing returns nothing
    set dyc_LastSelectedUnit[GetPlayerId(GetTriggerPlayer())] = GetTriggerUnit()    
endfunction

private function DYCbaseini takes nothing returns nothing
    local trigger tri
    local integer i
    
    set tri=CreateTrigger()
    call TriggerAddAction(tri, function SysDYCPlayerSelection)
    set i=0
    loop
        exitwhen i>15
        set dyc_LastSelectedUnit[i]=null
        call TriggerRegisterPlayerSelectionEventBJ(tri,Player(i), true )
        set i=i+1
    endloop
    
    
    set tri=null
endfunction
///////////ini/////////////
///////////////////////////



endlibrary



#endif // DYCbaseIncluded
