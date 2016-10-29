#ifndef unWETextTagIncluded
#define unWETextTagIncluded

library unWETextTag
    
function unWECreateTextTagForDamage takes unit whichUnit, real val, integer R, integer G, integer B returns nothing
    local texttag tag = CreateTextTag()
    local real x = GetUnitX(whichUnit)
    local real y = GetUnitY(whichUnit)    
    local boolean flag = IsUnitVisible(whichUnit,GetLocalPlayer())
    call SetTextTagVisibility(tag,flag)//Òì²½Æ¯¸¡ÎÄ×Ö 
    call SetTextTagPermanent(tag,FALSE) 
    call SetTextTagLifespan(tag,5)
    call SetTextTagFadepoint(tag,2.00)
    call SetTextTagVelocity(tag,0.00,0.04) 
    call SetTextTagPos(tag,x,y,0) 
    call SetTextTagText(tag,I2S(R2I(val))+"!",0.024) 
    call SetTextTagColor(tag,R,G,B,255)
    set tag = null
endfunction

endlibrary

#endif /// unWETextTagIncluded
