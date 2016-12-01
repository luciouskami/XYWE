#ifndef CreateAssUnitIncluded
#define CreateAssUnitIncluded
library CreateAssUnit
	function CreateAssUnit takes player p, integer uid, real x, real y, real t, integer aid, integer l returns nothing
		// Modify By XYWE at 2016-11-30 22:38:38
		// + judge aid
		set bj_lastCreatedUnit = CreateUnit(p, uid, x, y, 0)
		call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', t)
		if aid != 0 then
			call UnitAddAbility(bj_lastCreatedUnit, aid)
			call SetUnitAbilityLevel(bj_lastCreatedUnit, aid, l)
		endif
	endfunction
endlibrary
#endif
