#ifndef CreateTextTagForPlayerIncluded
#define CreateTextTagForPlayerIncluded

library CreateTextTagForPlayer
function CreateTextTagForPlayer takes player p,real x, real y,string s,integer r,integer g,integer b,integer al,real d,real h,real vx,real vy,real z,boolean l returns nothing
    local texttag tt
    if p==GetLocalPlayer()then
        set tt=CreateTextTag()
        call SetTextTagPos(tt,x,y,h)
        call SetTextTagPermanent(tt,l)
        call SetTextTagLifespan(tt,z)
        call SetTextTagText(tt,s,d*0.0023)
        call SetTextTagVelocity(tt,vx,vy)
        call SetTextTagColor(tt,r,g,b,al)
	set bj_lastCreatedTextTag=tt
    endif
endfunction
endlibrary
#endif
