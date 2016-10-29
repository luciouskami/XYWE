#ifndef unWERectLocIncluded
#define unWERectLocIncluded

//===========================================================================
//触发器 - 触发器列表 
//===========================================================================
library unWERectLoc 
function unWECreateNUnitsAtRect takes integer count, integer unitId, player whichPlayer, rect r, real face returns group
    local real x = GetRectCenterX(r)
    local real y = GetRectCenterY(r)
    call GroupClear(bj_lastCreatedGroup)
    loop
        set count = count - 1
        exitwhen count < 0
        set bj_lastCreatedUnit = CreateUnit(whichPlayer,unitId,x,y,face)
        call GroupAddUnit(bj_lastCreatedGroup, bj_lastCreatedUnit)
    endloop
    return bj_lastCreatedGroup
endfunction

function unWEIssueRectOrder takes unit whichUnit, string order, rect r returns boolean
    local real x = GetRectCenterX(r)
    local real y = GetRectCenterY(r)
    return IssuePointOrder(whichUnit,order,x,y)
endfunction

function unWEIssueRectOrderById takes unit whichUnit, integer order, rect r returns boolean
    local real x = GetRectCenterX(r)
    local real y = GetRectCenterY(r)
    return IssuePointOrderById(whichUnit,order,x,y)
endfunction

function unWEGroupRectOrder takes group whichGroup, string order, rect r returns boolean
    local real x = GetRectCenterX(r)
    local real y = GetRectCenterY(r)
    return GroupPointOrder(whichGroup,order,x,y)
endfunction

function unWEGroupRectOrderById takes group whichGroup, integer order, rect r returns boolean
    local real x = GetRectCenterX(r)
    local real y = GetRectCenterY(r)
    return GroupPointOrderById(whichGroup,order,x,y)
endfunction

endlibrary 
#endif /// unWERectLocIncluded 
