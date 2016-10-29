#ifndef XYJapiToLuaIncluded
#define XYJapiToLuaIncluded

<?
import("InitLua.lua")[==[
	console = require 'jass.console'
	console.enable = true

	jass = require 'jass.common'
	japi = require 'jass.japi'
	setmetatable(_ENV, { __index = getmetatable(jass).__index })

	function ClearRequire()
		package.loaded['ClearRequire0'] = nil
		package.loaded['ClearRequire1'] = nil

		package.loaded['WMSetAbilityState'] = nil
		package.loaded['WMGetUnitAbility'] = nil
		package.loaded['WMGetAbilityDataString'] = nil
	end
]==]
import("ClearRequire0.lua")[==[
	ClearRequire()
]==]
import("ClearRequire1.lua")[==[
	ClearRequire()
]==]
import("WMSetAbilityState.lua")[==[
	japi.EXSetAbilityState(XYJapiToLua_Param_Ability[0], XYJapiToLua_Param_Integer[0], XYJapiToLua_Param_Real[0])
]==]
import("WMGetUnitAbility.lua")[==[
	XYJapiToLua_Param_Ability[0] = japi.EXGetUnitAbility(XYJapiToLua_Param_Unit[0], XYJapiToLua_Param_Integer[0])
]==]
import("WMGetAbilityDataString.lua")[==[
	XYJapiToLua_Param_String[0] = japi.EXGetAbilityDataString(XYJapiToLua_Param_Ability[0], XYJapiToLua_Param_Integer[0], XYJapiToLua_Param_Integer[1])
]==]
?>

//! zinc
library XYJapiToLua {
	public integer XYJapiToLua_Param_Integer[];
	public real XYJapiToLua_Param_Real[];
	public string XYJapiToLua_Param_String[];
	public unit XYJapiToLua_Param_Unit[];
	public ability XYJapiToLua_Param_Ability[];

	private boolean clearReverseRequire = true;

	private function onInit() {
		// Lua赋值之前，先在Jass里面赋值(初始化)
		XYJapiToLua_Param_Integer[0] = 0;
		XYJapiToLua_Param_Real[0] = 0;
		XYJapiToLua_Param_String[0] = "";
		XYJapiToLua_Param_Unit[0] = null;
		XYJapiToLua_Param_Ability[0] = null;
		Cheat("exec-lua: InitLua");
	}

	public function WMClearRequire() {
		if (clearReverseRequire) {
			clearReverseRequire = false;
			Cheat("exec-lua: ClearRequire0");
		}
		else {
			clearReverseRequire = true;
			Cheat("exec-lua: ClearRequire1");
		}
	}

	public function WMSetAbilityState(ability a, integer datatype, real value) {
		XYJapiToLua_Param_Ability[0] = a;
		XYJapiToLua_Param_Integer[0] = datatype;
		XYJapiToLua_Param_Real[0] = value;
		Cheat("exec-lua: WMSetAbilityState");
		WMClearRequire();
	}

	public function WMGetUnitAbility(unit u, integer aid) -> ability {
		XYJapiToLua_Param_Unit[0] = u;
		XYJapiToLua_Param_Integer[0] = aid;
		Cheat("exec-lua: WMGetUnitAbility");
		WMClearRequire();
		return XYJapiToLua_Param_Ability[0];
	}

	public function WMGetAbilityDataString(ability a, integer level, integer datatype) -> string {
		XYJapiToLua_Param_Ability[0] = a;
		XYJapiToLua_Param_Integer[0] = level;
		XYJapiToLua_Param_Integer[1] = datatype;
		Cheat("exec-lua: WMGetAbilityDataString");
		WMClearRequire();
		return XYJapiToLua_Param_String[0];
	}

	// 获取技能文本信息
	public function WMGetUnitAbilityDataString(unit u, integer aid, integer level, integer datatype) -> string {
		return WMGetAbilityDataString(WMGetUnitAbility(u, aid), level, datatype)
	}

	// 设置技能冷却时间
	public function WMSetUnitAbilityState(unit u, integer aid, integer t, real cd) {
		WMSetAbilityState(WMGetUnitAbility(u, aid), t, cd)
	}
}
//! endzinc

#endif
