#ifndef AntiCheatC2IIncluded
#define AntiCheatC2IIncluded
#include "WM/WMBase.j"
library AntiCheatC2I
globals
    integer WMc2i
endglobals
function AntiCheatC2I takes integer i returns nothing
	if WMc2i!=i then
	#ifdef DEBUG
		call DisplayTimedTextToPlayer(Player(0),0,0,30,"²îÖµÎª"+I2S(WMc2i))
	#else
		call Player(16)
	#endif
	endif
endfunction
endlibrary
#endif
