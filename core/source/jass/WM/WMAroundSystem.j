#ifndef WMAroundSystemIncluded
#define WMAroundSystemIncluded
#include "WM/WMBase.j"
library WMAroundSystem requires WMBase
function Huanrao takes nothing returns nothing
     local timer t=GetExpiredTimer()
     local integer id=GetHandleId(t)-0x100000
     local unit u=WMLoadUnitHandle(id,1)
     local unit U=WMLoadUnitHandle(id,2)
     local real a=WMLoadReal(id,3)
     local real b=WMLoadReal(id,4)
     local real h=WMLoadReal(id,5)
     local real c1=WMLoadReal(id,6)*bj_DEGTORAD
     local real c2=WMLoadReal(id,7)
     local real c3=WMLoadReal(id,8)
     local real time=WMLoadReal(id,9)
     local real Time=WMLoadReal(id,10)
     local real T=WMLoadReal(id,11)
     local real timepast=WMLoadReal(id,12)
     local real r
     set timepast=timepast+.02
     set T=T+(7.2/time)*bj_DEGTORAD
     if T>=6.28 then
         set T=T-6.28
     endif
     if c1==-1 then
         set c1=(GetUnitFacing(u)-270)*bj_DEGTORAD
     endif
     call WMSaveReal(id,11,T)
     call WMSaveReal(id,12,timepast)
     set r=SquareRoot(a*Cos(c2)*Cos(T)*a*Cos(c2)*Cos(T)+b*Cos(c3)*Sin(T)*b*Cos(c3)*Sin(T))
     call SetUnitX(U,GetUnitX(u)+r*Cos(c1+Atan2(b*Cos(c3)*Sin(T),a*Cos(c2)*Cos(T))))
     call SetUnitY(U,GetUnitY(u)+r*Sin(c1+Atan2(b*Cos(c3)*Sin(T),a*Cos(c2)*Cos(T))))
     call SetUnitFlyHeight(U,GetUnitFlyHeight(u)+h+a*Cos(T)*Sin(c2)+b*Sin(T)*Sin(c3),0)
     if timepast>=Time and Time>0 then
         call RemoveUnit(U)
         call WMFlushChildHashtable(id)
         call DestroyTimer(t)
     endif
     set t=null
     set u=null
     set U=null
endfunction
function WMAroundSystem takes unit u,integer unittypes,real a,real b,real h,real c1,real c2,real c3,real time,real Time returns nothing
     local timer t=CreateTimer()
     local integer id=GetHandleId(t)-0x100000
     local unit U=CreateUnit(GetOwningPlayer(u),unittypes,GetUnitX(u),GetUnitY(u),0)
     call WMSaveUnitHandle(id,1,u)
     call WMSaveUnitHandle(id,2,U)
     call WMSaveReal(id,3,a)
     call WMSaveReal(id,4,b)
     call WMSaveReal(id,5,h)
     call WMSaveReal(id,6,c1)
     call WMSaveReal(id,7,c2*bj_DEGTORAD)
     call WMSaveReal(id,8,c3*bj_DEGTORAD)
     call WMSaveReal(id,9,time)
     call WMSaveReal(id,10,Time)
     call TimerStart(t,.02,true,function Huanrao)
     set U=null
     set t=null
endfunction
endlibrary
#endif
