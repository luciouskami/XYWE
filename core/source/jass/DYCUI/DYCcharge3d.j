#ifndef DYCcharge3dIncluded
#define DYCcharge3dIncluded

#include "DYCUI/DYCbase.j"
#include "DYCUI/DYCTriggerEvent.j"

library DYCcharge3d requires DYCbase, DYCTriggerEvent

globals
    private unit TempU
    private group TempG
    private string TempS
    private boolean TempB
    //private boolean TempB2
    private integer TempI
    private real TempR



endglobals


function Syscharge3dsinGroup2 takes nothing returns nothing
    local real d
    if (TempB==false) then
        set d=SquareRoot(Pow((GetUnitX(TempU)-GetUnitX(GetEnumUnit())),2)+Pow((GetUnitY(TempU)-GetUnitY(GetEnumUnit())),2))
    else
        set d=SquareRoot(Pow(GetUnitX(TempU)-GetUnitX(GetEnumUnit()),2)+Pow(GetUnitY(TempU)-GetUnitY(GetEnumUnit()),2)+Pow(GetUnitFlyHeight(TempU)-GetUnitFlyHeight(GetEnumUnit()),2))
    endif


    if (d<=TempR)and(IsUnitInGroup(GetEnumUnit(), TempG) == false) then

        set bj_DYCUnit1=TempU
        set bj_DYCUnit2=GetEnumUnit()
        set bj_DYCTJudge=1
        call SaveStr(UDGht,GetHandleId(TempU),StringHash("SystemUChargen"),TempS)
        call DYCAnyUnitTrigger()
        call GroupAddUnit(TempG,GetEnumUnit())

    endif

endfunction


function Syscharge3dsinGroup takes nothing returns nothing


    if (LoadInteger(UDGht,GetHandleId(TempU),StringHash("DC"+TempS))==1)and(IsUnitType(GetEnumUnit(), UNIT_TYPE_DEAD) == false)  and (IsUnitInGroup(GetEnumUnit(), TempG) == false) then

        if ( (TempB==false) or (SquareRoot(Pow(GetUnitX(TempU)-GetUnitX(GetEnumUnit()),2)+Pow(GetUnitY(TempU)-GetUnitY(GetEnumUnit()),2)+Pow(GetUnitFlyHeight(TempU)-GetUnitFlyHeight(GetEnumUnit()),2))<=TempR) ) then

            set bj_DYCUnit1=TempU
            set bj_DYCUnit2=GetEnumUnit()
            set bj_DYCTJudge=1
            call SaveStr(UDGht,GetHandleId(TempU),StringHash("SystemUChargen"),TempS)
            call DYCAnyUnitTrigger()
            call GroupAddUnit(TempG,GetEnumUnit())

        endif

    endif


endfunction



function Syscharge3dsinTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local integer hd=GetHandleId(u)
    local real d=LoadReal(UDGht,hd01,2)
    local real t=LoadReal(UDGht,hd01,3)
    local real r=LoadReal(UDGht,hd01,4)
    local boolean boo=LoadBoolean(UDGht,hd01,6)
    local boolean blf=LoadBoolean(UDGht,hd01,7)
    local string cn=LoadStr(UDGht,hd01,8)
    local real alpha=LoadReal(UDGht,hd01,9)
    local real beta=LoadReal(UDGht,hd01,10)
    local real gamma=LoadReal(UDGht,hd01,11)
    local real n=LoadReal(UDGht,hd01,12)
    local real pn=LoadReal(UDGht,hd01,13)
    local real amp=LoadReal(UDGht,hd01,14)
    local real ipa=LoadReal(UDGht,hd01,15)
    local real xo1=LoadReal(UDGht,hd01,16)
    local real yo1=LoadReal(UDGht,hd01,17)
    local real zo1=LoadReal(UDGht,hd01,18)
    local boolean bss=LoadBoolean(UDGht,hd01,19)
    local real angle=LoadReal(UDGht,hd01,20)
    local real hb=LoadReal(UDGht,hd01,21)
    local integer ftype=LoadInteger(UDGht,hd01,22)
    local real xo0
    local real yo0
    local real zo0
    local real xod
    local real yod
    local real zod
    local real xrd
    local real yrd
    local real zrd
    local real x
    local real y
    local real z
    local real dd=0
    local group gs
    local group g
    local integer chargeout=0
    local integer upausec = LoadInteger(UDGht,hd,StringHash("systemupausec"))
    local integer upauseac = LoadInteger(UDGht,hd,StringHash("systemupauseac"))

    if ((upausec==0)or(upauseac==0)) then
        set n=n+0.025
        set dd=d/t*n


        set xo0=xo1
        set yo0=yo1
        set zo0=zo1

        if (ftype==1) then
            set xo1=0
            set yo1=Sin(n/t*2*bj_PI*pn+ipa*2*bj_PI)*amp
            set zo1=n/t*d
        endif
        if (ftype==2) then
            set xo1=Sin(n/t*2*bj_PI*pn+ipa*2*bj_PI+0.5*bj_PI)*amp
            set yo1=Sin(n/t*2*bj_PI*pn+ipa*2*bj_PI)*amp
            set zo1=n/t*d
        endif

        set xod=xo1-xo0
        set yod=yo1-yo0
        set zod=zo1-zo0
        set xrd= xod*(Cos(alpha)*Cos(gamma)-Cos(beta)*Sin(alpha)*Sin(gamma)) + yod*(Sin(alpha)*Cos(gamma)+Cos(beta)*Cos(alpha)*Sin(gamma)) + zod*(Sin(beta)*Sin(gamma))
        set yrd= xod*(-Cos(alpha)*Sin(gamma)-Cos(beta)*Sin(alpha)*Cos(gamma)) + yod*(-Sin(alpha)*Sin(gamma)+Cos(beta)*Cos(alpha)*Cos(gamma)) + zod*(Sin(beta)*Cos(gamma))
        set zrd= xod*(Sin(beta)*Sin(alpha)) + yod*(-Sin(beta)*Cos(alpha)) + zod*Cos(beta)
        set x=GetUnitX(u)+xrd
        set y=GetUnitY(u)+yrd
        set z=GetUnitFlyHeight(u)+zrd
        if (x>=GetRectMinX(bj_mapInitialPlayableArea))and(x<=GetRectMaxX(bj_mapInitialPlayableArea)) then
            call SetUnitX(u,x)
        else
            set chargeout=1
        endif
        if (y>=GetRectMinY(bj_mapInitialPlayableArea))and(y<=GetRectMaxY(bj_mapInitialPlayableArea)) then
            call SetUnitY(u,y)
        else
            set chargeout=1
        endif
        if (z>=0)and(hb>=0) then
            call SetUnitFlyHeight(u,z,9999999)
        else
            set hb=hb+z
            if (hb>0) then
                call SetUnitFlyHeight(u,hb,9999999)
                set hb=0
            endif
        endif
        if (blf) then
            set angle=Atan2(yrd,xrd)*bj_RADTODEG
            call SetUnitFacing(u,angle)
        endif


        if (r>0) then
            set g=LoadGroupHandle(UDGht,hd01,5)
            set gs=CreateGroup()
            call GroupEnumUnitsInRange(gs,GetUnitX(u),GetUnitY(u),r,null)
            if (boo) then
                set TempS=cn
                set TempG=g
                set TempU=u
                set TempB=bss
                set TempR=r
                call ForGroup(bj_DYCDummyGroup, function Syscharge3dsinGroup2)
            endif
            set TempG=g
            set TempU=u
            set TempS=cn
            set TempB=bss
            set TempR=r
            //set TempI=0
            call ForGroup(gs, function Syscharge3dsinGroup)
            call DestroyGroup(gs)

        endif

    endif


    if ((IsUnitType(u,UNIT_TYPE_DEAD)==true)or(LoadInteger(UDGht,hd,StringHash("DC"+cn))==0)) then

        //if LoadInteger(UDGht,hd,StringHash("SysULeaping"))<=0 then
            //call SetUnitFlyHeight( u, dh, 9999999.00 )
        //endif

        set bj_DYCUnit1=u
        set bj_DYCUnit2=null
        set bj_DYCTJudge=3
        call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
        call DYCAnyUnitTrigger()


        call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
        call UnitRemoveType(u, UNIT_TYPE_PEON )
        call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
        call DestroyTimer(GetExpiredTimer())
    else

        if (dd>=d)or(chargeout==1) then

            //if LoadInteger(UDGht,hd,StringHash("SysULeaping"))<=0 then
                //call SetUnitFlyHeight( u, dh, 9999999.00 )
            //endif

            set bj_DYCUnit1=u
            set bj_DYCUnit2=null
            set bj_DYCTJudge=2
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()

            set bj_DYCUnit1=u
            set bj_DYCUnit2=null
            set bj_DYCTJudge=3
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()


            call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
            call UnitRemoveType(u, UNIT_TYPE_PEON )
            call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
            call DestroyTimer(GetExpiredTimer())
        endif
    endif


    call SaveReal(UDGht,hd01,12,n)
    call SaveReal(UDGht,hd01,16,xo1)
    call SaveReal(UDGht,hd01,17,yo1)
    call SaveReal(UDGht,hd01,18,zo1)
    call SaveReal(UDGht,hd01,21,hb)

    set g=null
    set gs=null
    set u=null

endfunction

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

function Syscharge3dsintargetTimer1 takes nothing returns nothing

    local integer hd01=GetHandleId(GetExpiredTimer())
    local unit u=LoadUnitHandle(UDGht,hd01,1)
    local unit u2=LoadUnitHandle(UDGht,hd01,2)
    local integer hd=GetHandleId(u)
    local real spd=LoadReal(UDGht,hd01,3)
    local real r=LoadReal(UDGht,hd01,4)
    local boolean boo=LoadBoolean(UDGht,hd01,6)
    local boolean blf=LoadBoolean(UDGht,hd01,7)
    local string cn=LoadStr(UDGht,hd01,8)
    local real alpha=LoadReal(UDGht,hd01,9)
    local real de=LoadReal(UDGht,hd01,10)
    local real n=LoadReal(UDGht,hd01,12)
    local real pn=LoadReal(UDGht,hd01,13)
    local real amp=LoadReal(UDGht,hd01,14)
    local real ipa=LoadReal(UDGht,hd01,15)
    local real xr1=LoadReal(UDGht,hd01,16)
    local real yr1=LoadReal(UDGht,hd01,17)
    local real zr1=LoadReal(UDGht,hd01,18)
    local boolean bss=LoadBoolean(UDGht,hd01,19)
    local real hb=LoadReal(UDGht,hd01,21)
    local real x0=LoadReal(UDGht,hd01,22)
    local real y0=LoadReal(UDGht,hd01,23)
    local real z0=LoadReal(UDGht,hd01,24)
    local boolean bad=LoadBoolean(UDGht,hd01,25)
    local integer ftype=LoadInteger(UDGht,hd01,26)
    local real beta
    local real gamma
    local real angle
    local real xr0
    local real yr0
    local real zr0
    local real xo1
    local real yo1
    local real zo1
    local real xrd
    local real yrd
    local real zrd
    local real x
    local real y
    local real z
    local real d0
    local real d1
    local real du1
    local real du1u2
    local real cosu1u2
    local real percentage
    local real ampdamp
    local real vecx=0
    local real vecy=0
    local real vecz=0
    local integer chaseaid=0
    local real dd=0
    local group gs
    local group g
    local integer chargeout=0
    local integer upausec = LoadInteger(UDGht,hd,StringHash("systemupausec"))
    local integer upauseac = LoadInteger(UDGht,hd,StringHash("systemupauseac"))



    if ((upausec==0)or(upauseac==0)) then

        set d0=SquareRoot(Pow((x0-GetUnitX(u2)),2)+Pow((y0-GetUnitY(u2)),2)+Pow((z0-GetUnitFlyHeight(u2)),2))
        set du1=SquareRoot(Pow((x0-GetUnitX(u)),2)+Pow((y0-GetUnitY(u)),2)+Pow((z0-GetUnitFlyHeight(u)),2))
        set du1u2=SquareRoot(Pow((GetUnitX(u2)-GetUnitX(u)),2)+Pow((GetUnitY(u2)-GetUnitY(u)),2)+Pow((GetUnitFlyHeight(u2)-GetUnitFlyHeight(u)),2))
        if (d0*du1!=0) then
            set cosu1u2=(Pow(d0,2)+Pow(du1,2)-Pow(du1u2,2))/(2*d0*du1)
        else
            set cosu1u2=0
        endif
        set d1=du1*cosu1u2
        set percentage=d1/d0
        set beta=Atan((GetUnitFlyHeight(u2)-z0)/SquareRoot(Pow(x0-GetUnitX(u2),2)+Pow(y0-GetUnitY(u2),2)))
        set beta=beta-90/bj_RADTODEG
        set gamma=Atan2(GetUnitY(u2)-y0,GetUnitX(u2)-x0)
        set gamma=-gamma-90/bj_RADTODEG
        if (percentage<=1) then
            set n=n+0.025
        else
            set n=n-0.025
            if (percentage<1.1) then
                set chaseaid=1
                set amp=amp-0.05*spd
                if (amp<0) then
                    set amp=0
                endif
            endif
        endif
        set dd=spd*n

        if (n==0.025) then
            call IssueImmediateOrderById( u, 851993 )
        endif
        if (bad) then
            set ampdamp=Sin(percentage*bj_PI)
        else
            set ampdamp=1
        endif

        set xr0=xr1
        set yr0=yr1
        set zr0=zr1

        if (ftype==1) then
            set xo1=0
            set yo1=Sin(percentage*2*bj_PI*pn+ipa*2*bj_PI)*amp*ampdamp
            set zo1=n*spd
        endif
        if (ftype==2) then
            set xo1=Sin(percentage*2*bj_PI*pn+ipa*2*bj_PI+0.5*bj_PI)*amp*ampdamp
            set yo1=Sin(percentage*2*bj_PI*pn+ipa*2*bj_PI)*amp*ampdamp
            set zo1=n*spd
        endif

        set xr1= xo1*(Cos(alpha)*Cos(gamma)-Cos(beta)*Sin(alpha)*Sin(gamma)) + yo1*(Sin(alpha)*Cos(gamma)+Cos(beta)*Cos(alpha)*Sin(gamma)) + zo1*(Sin(beta)*Sin(gamma))
        set yr1= xo1*(-Cos(alpha)*Sin(gamma)-Cos(beta)*Sin(alpha)*Cos(gamma)) + yo1*(-Sin(alpha)*Sin(gamma)+Cos(beta)*Cos(alpha)*Cos(gamma)) + zo1*(Sin(beta)*Cos(gamma))
        set zr1= xo1*(Sin(beta)*Sin(alpha)) + yo1*(-Sin(beta)*Cos(alpha)) + zo1*Cos(beta)
        set xrd=xr1-xr0
        set yrd=yr1-yr0
        set zrd=zr1-zr0


        set x=GetUnitX(u)+xrd
        set y=GetUnitY(u)+yrd
        set z=GetUnitFlyHeight(u)+zrd
        if (chaseaid>0) then
            set vecx=GetUnitX(u2)-x
            set vecy=GetUnitY(u2)-y
            set vecz=GetUnitFlyHeight(u2)-z
            set x=GetUnitX(u)+0.1*vecx
            set y=GetUnitY(u)+0.1*vecy
            set z=GetUnitFlyHeight(u)+0.1*vecz
        endif

        if (x>=GetRectMinX(bj_mapInitialPlayableArea))and(x<=GetRectMaxX(bj_mapInitialPlayableArea))and(du1u2>de) then
            call SetUnitX(u,x)
        else
            set chargeout=1
        endif
        if (y>=GetRectMinY(bj_mapInitialPlayableArea))and(y<=GetRectMaxY(bj_mapInitialPlayableArea))and(du1u2>de) then
            call SetUnitY(u,y)
        else
            set chargeout=1
        endif
        if (z>=0)and(hb>=0) then
            call SetUnitFlyHeight(u,z,9999999)
        else
            set hb=hb+z
            if (hb>0) then
                call SetUnitFlyHeight(u,hb,9999999)
                set hb=0
            endif
        endif

        if (blf) then
            set angle=Atan2(yrd,xrd)*bj_RADTODEG
            call SetUnitFacing(u,angle)
        endif


        if (r>0) then
            set g=LoadGroupHandle(UDGht,hd01,5)
            set gs=CreateGroup()
            call GroupEnumUnitsInRange(gs,GetUnitX(u),GetUnitY(u),r,null)
            if (boo) then
                set TempS=cn
                set TempG=g
                set TempU=u
                set TempB=bss
                set TempR=r
                call ForGroup(bj_DYCDummyGroup, function Syscharge3dsinGroup2)
            endif
            set TempG=g
            set TempU=u
            set TempS=cn
            set TempB=bss
            set TempR=r
            //set TempI=0
            call ForGroup(gs, function Syscharge3dsinGroup)
            call DestroyGroup(gs)

        endif

    endif


    if ((IsUnitType(u,UNIT_TYPE_DEAD)==true)or(IsUnitType(u2,UNIT_TYPE_DEAD)==true)or(LoadInteger(UDGht,hd,StringHash("DC"+cn))==0)) then

        //if LoadInteger(UDGht,hd,StringHash("SysULeaping"))<=0 then
            //call SetUnitFlyHeight( u, dh, 9999999.00 )
        //endif

        set bj_DYCUnit1=u
        set bj_DYCUnit2=u2
        set bj_DYCTJudge=3
        call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
        call DYCAnyUnitTrigger()


        call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
        call UnitRemoveType(u, UNIT_TYPE_PEON )
        call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
        call DestroyTimer(GetExpiredTimer())
    else

        if (du1u2<=de) then

            //if LoadInteger(UDGht,hd,StringHash("SysULeaping"))<=0 then
                //call SetUnitFlyHeight( u, dh, 9999999.00 )
            //endif

            set bj_DYCUnit1=u
            set bj_DYCUnit2=u2
            set bj_DYCTJudge=2
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()

            set bj_DYCUnit1=u
            set bj_DYCUnit2=u2
            set bj_DYCTJudge=3
            call SaveStr(UDGht,hd,StringHash("SystemUChargen"),cn)
            call DYCAnyUnitTrigger()


            call SaveInteger(UDGht,hd,StringHash("DC"+cn),0)
            call UnitRemoveType(u, UNIT_TYPE_PEON )
            call DestroyGroup(LoadGroupHandle(UDGht,hd01,5))
            call DestroyTimer(GetExpiredTimer())
        endif
    endif


    call SaveReal(UDGht,hd01,12,n)
    call SaveReal(UDGht,hd01,14,amp)
    call SaveReal(UDGht,hd01,16,xr1)
    call SaveReal(UDGht,hd01,17,yr1)
    call SaveReal(UDGht,hd01,18,zr1)
    call SaveReal(UDGht,hd01,21,hb)

    set g=null
    set gs=null
    set u=null
    set u2=null

endfunction



function DYCcharge3d takes unit u, real d, real t, real alpha, real beta, real gamma, real pn, real amp, real ipa, real r, boolean bss, boolean boo, boolean blf, string cn, integer ftype returns nothing
//ipa:initial phase angle number   bss:enum in sphere range
//call DYCcharge3dsin(GetTriggerUnit(),800,1.5,90,0,GetUnitFacing(GetTriggerUnit()),1,300,0,100,false,false,true,"sin")


    local timer timer1=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer hd=GetHandleId(u)

    call UnitAddType(u, UNIT_TYPE_PEON )
    call UnitAddAbility( u, 'Arav' )
    call UnitRemoveAbility( u, 'Arav' )

    if (beta<-90) then
        set beta=-90
    endif
    if (beta>90) then
        set beta=90
    endif
    if (t==0) then
        set t=0.01
    endif

    call SaveUnitHandle(UDGht,hd01,1,u)
    call SaveReal(UDGht,hd01,2,d)
    call SaveReal(UDGht,hd01,3,t)
    call SaveReal(UDGht,hd01,4,r)
    if (r>0) then
        call SaveGroupHandle(UDGht,hd01,5,CreateGroup())
    endif
    call SaveBoolean(UDGht,hd01,6,boo)
    call SaveBoolean(UDGht,hd01,7,blf)
    call SaveStr(UDGht,hd01,8,cn)
    call SaveReal(UDGht,hd01,9,-alpha/bj_RADTODEG)
    call SaveReal(UDGht,hd01,10,beta/bj_RADTODEG-90/bj_RADTODEG)
    call SaveReal(UDGht,hd01,11,-gamma/bj_RADTODEG-90/bj_RADTODEG)
    call SaveReal(UDGht,hd01,12,0)
    call SaveReal(UDGht,hd01,13,pn)
    call SaveReal(UDGht,hd01,14,amp)
    call SaveReal(UDGht,hd01,15,ipa)
    if (ftype==1) then
        call SaveReal(UDGht,hd01,16,0)
        call SaveReal(UDGht,hd01,17,Sin(ipa*2*bj_PI)*amp)
        call SaveReal(UDGht,hd01,18,0)
    endif
    if (ftype==2) then
        call SaveReal(UDGht,hd01,16,Sin(ipa*2*bj_PI+0.5*bj_PI)*amp)
        call SaveReal(UDGht,hd01,17,Sin(ipa*2*bj_PI)*amp)
        call SaveReal(UDGht,hd01,18,0)
    endif
    call SaveBoolean(UDGht,hd01,19,bss)
    call SaveReal(UDGht,hd01,20,gamma)
    call SaveReal(UDGht,hd01,21,0)
    call SaveInteger(UDGht,hd01,22,ftype)
    call SaveInteger(UDGht,hd,StringHash("DC"+cn),1)
    call TimerStart(timer1,0.025,true,function Syscharge3dsinTimer1)

    set u=null
    set timer1=null

endfunction


function DYCcharge3dtarget takes unit u, unit u2, real spd, real alpha, real pn, real amp, real ipa, real de, real r, boolean bss, boolean boo, boolean blf, boolean bad, string cn, integer ftype returns nothing
//bad: amplitude damp


    local timer timer1=CreateTimer()
    local integer hd01=GetHandleId(timer1)
    local integer hd=GetHandleId(u)
    local integer hd2=GetHandleId(u2)
    local real ampdamp

    call UnitAddType(u, UNIT_TYPE_PEON )
    call UnitAddAbility( u, 'Arav' )
    call UnitRemoveAbility( u, 'Arav' )

    if (spd<=0) then
        set spd=1000
    endif
    if (bad) then
        set ampdamp=0
    else
        set ampdamp=1
    endif

    call SaveUnitHandle(UDGht,hd01,1,u)
    call SaveUnitHandle(UDGht,hd01,2,u2)
    call SaveReal(UDGht,hd01,3,spd)
    call SaveReal(UDGht,hd01,4,r)
    if (r>0) then
        call SaveGroupHandle(UDGht,hd01,5,CreateGroup())
    endif
    call SaveBoolean(UDGht,hd01,6,boo)
    call SaveBoolean(UDGht,hd01,7,blf)
    call SaveStr(UDGht,hd01,8,cn)
    call SaveReal(UDGht,hd01,9,-alpha/bj_RADTODEG)
    call SaveReal(UDGht,hd01,10,de)
    //call SaveReal(UDGht,hd01,10,beta/bj_RADTODEG-90/bj_RADTODEG)
    //call SaveReal(UDGht,hd01,11,-gamma/bj_RADTODEG-90/bj_RADTODEG)
    call SaveReal(UDGht,hd01,12,0)
    call SaveReal(UDGht,hd01,13,pn)
    call SaveReal(UDGht,hd01,14,amp)
    call SaveReal(UDGht,hd01,15,ipa)
    if (ftype==1) then
        call SaveReal(UDGht,hd01,16,0)
        call SaveReal(UDGht,hd01,17,Sin(ipa*2*bj_PI)*amp*ampdamp)
        call SaveReal(UDGht,hd01,18,0)
    endif
    if (ftype==2) then
        call SaveReal(UDGht,hd01,16,Sin(ipa*2*bj_PI+0.5*bj_PI)*amp*ampdamp)
        call SaveReal(UDGht,hd01,17,Sin(ipa*2*bj_PI)*amp*ampdamp)
        call SaveReal(UDGht,hd01,18,0)
    endif
    call SaveBoolean(UDGht,hd01,19,bss)
    //call SaveReal(UDGht,hd01,20,gamma)
    call SaveReal(UDGht,hd01,21,0)
    call SaveReal(UDGht,hd01,22,GetUnitX(u))
    call SaveReal(UDGht,hd01,23,GetUnitY(u))
    call SaveReal(UDGht,hd01,24,GetUnitFlyHeight(u))
    call SaveBoolean(UDGht,hd01,25,bad)
    call SaveInteger(UDGht,hd01,26,ftype)
    call SaveInteger(UDGht,hd,StringHash("DC"+cn),1)
    call TimerStart(timer1,0.025,true,function Syscharge3dsintargetTimer1)

    set u=null
    set u2=null
    set timer1=null

endfunction

function DYCcharge3dsin takes unit u, real d, real t, real alpha, real beta, real gamma, real pn, real amp, real ipa, real r, boolean bss, boolean boo, boolean blf, string cn returns nothing
    call DYCcharge3d(u,d,t,alpha,beta,gamma,pn,amp,ipa,r,bss,boo,blf,cn,1)
endfunction

function DYCcharge3dsintarget takes unit u, unit u2, real spd, real alpha, real pn, real amp, real ipa, real de, real r, boolean bss, boolean boo, boolean blf, boolean bad, string cn returns nothing
    call DYCcharge3dtarget(u,u2,spd,alpha,pn,amp,ipa,de,r,bss,boo,blf,bad,cn,1)
endfunction

function DYCcharge3dhelix takes unit u, real d, real t, real alpha, real beta, real gamma, real pn, real amp, real ipa, real r, boolean bss, boolean boo, boolean blf, string cn returns nothing
    call DYCcharge3d(u,d,t,alpha,beta,gamma,pn,amp,ipa,r,bss,boo,blf,cn,2)
endfunction

function DYCcharge3dhelixtarget takes unit u, unit u2, real spd, real alpha, real pn, real amp, real ipa, real de, real r, boolean bss, boolean boo, boolean blf, boolean bad, string cn returns nothing
    call DYCcharge3dtarget(u,u2,spd,alpha,pn,amp,ipa,de,r,bss,boo,blf,bad,cn,2)
endfunction


endlibrary

#endif // DYCcharge3dIncluded
