#ifndef SWEsystemIncluded
#define SWEsystemIncluded
#include "SJ/SJWEBase.j"

library_once SWEsystem requires SJWEBase

globals
    private hashtable         DSHT = InitHashtable()
    private hashtable         DSITHT = InitHashtable()
    private group             DamagedGroup
    private boolean           DisplayDamageBool = false
    private string            str1 = ""
    private trigger           trig  
    private real              RANDOM_Factor = 0.0       
    private integer           ImmuneDamageID = 0
    private integer           ITEM_SLOT_UNIT_TYPE = 'h000'
    private integer           MaxPlayerNumber = 0
    private integer           MIMETIC_SKILL_0 = 0   
    private integer           MIMETIC_SKILL_1 = 0   
    private integer           MIMETIC_SKILL_2 = 0    
    private integer           MIMETIC_BUFF_1 = 0   
    private integer           MIMETIC_BUFF_2 = 0    
    private integer           MagicListEnd = 0
    private integer           MeleeListEnd = 0
    private string array      color_str 
    private real array        rgb_A
    private integer array     rgb_R
    private integer array     rgb_G
    private integer array     rgb_B
    private integer array     MagicLastIndex
    private integer array     MagicNextIndex
    private integer array     MeleeLastIndex
    private integer array     MeleeNextIndex 
    private trigger array     MagicTriggerList
    private trigger array     MeleeTriggerList
    private real              EXP_A = 1.0       
    private real              EXP_B = 5.0       
    private real              EXP_C = 5.0      
    private real              EXP_A_Hero = 1.0       
    private real              EXP_B_Hero = 5.0       
    private real              EXP_C_Hero = 100.0      
    private real              EXP_D = 0.5  
    private real              Range = 1200.0
    private integer array     EXP
    private integer array     EXP_Hero
    private integer           EXP_c = 25
    private integer           EXP_c_Hero = 100
    private boolean           BUDILINGKILL = false    
    private trigger array     trA
    private trigger array     trB
    private trigger array     trC   
    private dialog array      DialogA
    private dialog array      DialogB
    private dialog array      DialogC
    private dialog array      DialogD
    private dialog array      DialogE   
    private dialog array      DialogF
    private button array      ButtonA
    private button array      ButtonB
    private button array      ButtonC   
endglobals

function SetDisplayDamageColor takes integer index, real a, integer r, integer g, integer b returns nothing
    set rgb_A[index] = a
    set rgb_R[index] = r
    set rgb_G[index] = g
    set rgb_B[index] = b
endfunction

function SetDisplayPredicableColor takes integer index, integer a, integer r, integer g, integer b returns nothing
    set color_str[index] = "|c" + I2Hex_Str(a) + I2Hex_Str(r) + I2Hex_Str(g) + I2Hex_Str(b)
endfunction

function SetAllPredicableStringColor takes integer a, integer r, integer g, integer b returns nothing
    local integer i = 1
    loop
        exitwhen i > 51
        if ((i != 20) and (i != 42)) then
            call SetDisplayPredicableColor(i,a,r,g,b)
        endif
        set i = i + 1
    endloop
endfunction

function Print takes real timeout, string s returns nothing
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,timeout,s)
endfunction

function GetSystemHashtable takes nothing returns hashtable
    return DSHT
endfunction

function GetItemSystemHashtable takes nothing returns hashtable
    return DSITHT
endfunction

function GetEventDamagedUnitZJ takes nothing returns unit
    local unit u = GetTriggerUnit()
    if (GetEventDamage() == 0.0) then
        set u = LoadUnitHandle(DSHT,GetHandleId(GetTriggeringTrigger()),3)
    endif
    return u
endfunction

function GetEventDamageSourceZJ takes nothing returns unit
    local unit u = GetEventDamageSource()
    if (GetEventDamage() == 0.0) then
        set u = LoadUnitHandle(DSHT,GetHandleId(GetTriggeringTrigger()),2)
    endif
    return u
endfunction

function GetEventDamageZJ takes nothing returns real
    local real damage = GetEventDamage()
    if (GetEventDamage() == 0.0) then
        set damage = LoadReal(DSHT,GetHandleId(GetTriggeringTrigger()),4)
    endif
    return damage
endfunction

function EXPSet takes nothing returns nothing
    local integer i = 0
    local integer n = 0
    set EXP[1] = EXP_c
    set i = 2
    loop
        exitwhen i > 1000
        set EXP[i] = EXP[i-1] * R2I(EXP_A) + R2I(EXP_B) * i + R2I(EXP_C)
        set i = i + 1
    endloop
    set EXP_Hero[1] = EXP_c_Hero
    set n = 2
    loop
        exitwhen n > 1000
        set EXP_Hero[n] = EXP_Hero[n-1] * R2I(EXP_A_Hero) + R2I(EXP_B_Hero) * n + R2I(EXP_C_Hero)
        set n = n + 1
    endloop
endfunction

function EXPCoefficient takes real A, real B, real C, integer c, real Ah, real Bh, real Ch, integer ch, real D, real R, boolean b returns nothing
    set EXP_A = A
    set EXP_B = B
    set EXP_C = C
    set EXP_A_Hero = Ah
    set EXP_B_Hero = Bh
    set EXP_C_Hero = Ch
    set EXP_D = D
    set EXP_c = c
    set EXP_c_Hero = ch 
    set Range = R
    set BUDILINGKILL = b
endfunction

function HeroGetEXP takes unit DeadUnit,unit Attacker returns nothing
    local group group1
    local group group2    
    local unit unit1
    local unit unit2
    local integer i = 0
    set group1 = CreateGroup()
    set group2 = CreateGroup()
    call GroupEnumUnitsInRange(group1, GetUnitX(DeadUnit), GetUnitY(DeadUnit), Range, null)
    loop
        set unit1 = FirstOfGroup(group1)
        exitwhen unit1 == null
        call GroupRemoveUnit(group1, unit1)
        call GroupAddUnit(group2,unit1)
        if (((IsUnitType(unit1, UNIT_TYPE_HERO) == true)) and ((IsUnitAlly(unit1, GetOwningPlayer(Attacker)) == true) or (IsUnitOwnedByPlayer(unit1, GetOwningPlayer(Attacker)) == true))) then
            set i = ( i + 1 )
        endif
    endloop
    call DestroyGroup(group1)
    set group1 = null
    set unit1 = null
    if (i <= 1) then
        set i = 1
    endif
    loop
        set unit2 = FirstOfGroup(group2)
        exitwhen unit2 == null
        call GroupRemoveUnit(group2, unit2)
        if (((IsUnitType(unit2, UNIT_TYPE_HERO) == true)) and ((IsUnitAlly(unit2, GetOwningPlayer(Attacker)) == true) or (IsUnitOwnedByPlayer(unit2, GetOwningPlayer(Attacker)) == true))) then
            if (((IsUnitType(Attacker, UNIT_TYPE_STRUCTURE) == false) or (BUDILINGKILL == true))) then
                if ((IsUnitType(DeadUnit, UNIT_TYPE_HERO) == true)) then
                    call AddHeroXP( unit2, ( EXP_Hero[GetUnitLevel(DeadUnit)] / i ), true )
                else
                    if ((IsUnitType(DeadUnit, UNIT_TYPE_SUMMONED) == true)) then
                        call AddHeroXP( unit2, ( R2I(EXP_D) * EXP[GetUnitLevel(DeadUnit)] / i ), true )
                    else
                        call AddHeroXP( unit2, ( EXP[GetUnitLevel(DeadUnit)] / i ), true )
                    endif
                endif
            endif
        endif
    endloop
    call DestroyGroup(group2)
    set group2 = null
    set unit2 = null
endfunction

function TextTag_Run takes nothing returns nothing
    call SaveReal(DSHT,GetHandleId(LoadUnitHandle(DSHT,GetHandleId(GetExpiredTimer()),7)),6,0.0)
    call DestroyTextTag(LoadTextTagHandle(DSHT,GetHandleId(GetExpiredTimer()),8))
    call FlushChildHashtable(DSHT,GetHandleId(GetExpiredTimer()))
    call DestroyTimer(GetExpiredTimer())
endfunction

function DisplayDamage takes unit whichunit, real Damage, real zOffset, real size, integer r, integer g, integer b, real transparency returns nothing
    local timer tm 
    local texttag tt
    set tm = CreateTimer()
    set tt = CreateTextTag()
    call SetTextTagText(tt,I2S(R2I(Damage)),size * ( 0.023 / 10 ))
    call SetTextTagPos(tt,GetUnitX(whichunit),GetUnitY(whichunit),zOffset)
    call SetTextTagColor(tt,r,g,b,PercentTo255(100.0 - transparency))
    call SetTextTagVelocityBJ(tt,100.00,GetRandomReal(80.00,110.00))
    call SaveTextTagHandle(DSHT,GetHandleId(tm),8,tt)
    call SaveUnitHandle(DSHT,GetHandleId(tm),7,whichunit)
    call TimerStart(tm,2.0,false,function TextTag_Run)
    set tm = null
    set tt = null
endfunction

function UnitTypeConditions_A takes unit u returns boolean
    return ((IsUnitType(u, UNIT_TYPE_STRUCTURE) == true) or (IsUnitType(u, UNIT_TYPE_MECHANICAL) == true))
endfunction

function SetTypeName takes integer typeid, string typename returns nothing
    if ( typeid <= 11 ) then
        set typeid = 11
    endif
    call SaveStr(DSHT, typeid, 9, typename)
    call SaveInteger(DSHT, StringHash(typename), 10, typeid)
endfunction
function GetTypeId takes string typename returns integer
    return LoadInteger(DSHT, StringHash(typename), 10)
endfunction
function TypeId2S takes integer typeid returns string
    if ( typeid <= 11 ) then
        set typeid = 11
    endif
    return LoadStr(DSHT, typeid, 9)
endfunction
function SetType takes integer whichid, integer typeid, integer value returns nothing
    call SaveInteger(DSHT, whichid, typeid, value)
endfunction
function GetType takes integer whichid, integer typeid returns integer
    return LoadInteger(DSHT, whichid, typeid)
endfunction
function SetTypeData takes integer whichid, integer typeid, real value returns nothing
    call SaveReal(DSHT, whichid, typeid, value)
endfunction
function GetTypeData takes integer whichid, integer typeid returns real
    return LoadReal(DSHT, whichid, typeid)
endfunction

function SetUnitData takes unit whichunit, integer typeid, real value returns nothing
    call SaveReal(DSHT, GetHandleId(whichunit), typeid, value)
endfunction
function GetUnitData takes unit whichunit, integer typeid returns real
    return LoadReal(DSHT, GetHandleId(whichunit), typeid)
endfunction

function SetType_System takes nothing returns nothing
    call SetTypeName(11,"攻击类型")
    call SetTypeName(12,"防御类型")
    call SetTypeName(13,"技能伤害类型")
    call SetTypeName(14,"技能伤害防御类型")
    call SetTypeName(15,"是否能化解技能伤害")
    call SetTypeName(16,"攻击随机因子")
    call SetTypeName(17,"暴击概率")
    call SetTypeName(18,"暴击倍数")
    call SetTypeName(19,"技能闪避力")
    call SetTypeName(20,"技能暴击概率")
    call SetTypeName(21,"技能暴击倍数")
    call SetTypeName(22,"减伤（百分比）")
    call SetTypeName(23,"增伤（百分比）")
    call SetTypeName(24,"伤害修改（数值）")
    call SetTypeName(25,"物品——技能伤害加成（倍数加成）")
    call SetTypeName(26,"物品——技能伤害加成（数值加成）")
    call SetTypeName(27,"总物品攻击值加成")
    call SetTypeName(28,"总物品防御值加成")
    call SetTypeName(29,"总物品技能防御值加成")
    call SetTypeName(30,"总物品——暴击概率")
    call SetTypeName(31,"总物品——暴击倍数")
    call SetTypeName(32,"总物品——技能闪避力")
    call SetTypeName(33,"总物品——技能暴击概率")
    call SetTypeName(34,"总物品——技能暴击倍数")
    call SetTypeName(35,"总物品——技能伤害加成（倍数加成）")
    call SetTypeName(36,"总物品——技能伤害加成（数值加成）")
    call SetTypeName(37,"总物品——减伤（百分比）")
    call SetTypeName(38,"总物品——伤害修改（数值）")
    call SetTypeName(39,"总物品——增伤（百分比）")
    call SetTypeName(40,"普通伤害化解概率")
    call SetTypeName(41,"技能伤害化解概率")
    call SetTypeName(42,"攻击增量")
    call SetTypeName(43,"防御增量")
    call SetTypeName(44,"技能伤害增量")
    call SetTypeName(45,"技能伤害防御增量") 
    call SetTypeName(46,"是否免疫默认伤害")
    call SetTypeName(47,"是否暴击伤害") 
    call SetTypeName(48,"是否闪避伤害") 
    call SetTypeName(49,"是否化解伤害") 
    call SetTypeName(50,"伤害前的伤害")
    call SetTypeName(51,"物品类型父类")
    call SetTypeName(52,"物品父类最大持有数")
    call SetTypeName(53,"单位附加技能伤害")
    call SetTypeName(54,"暴击伤害减少")
    call SetTypeName(55,"技能暴击伤害减少")
    call SetTypeName(56,"暴击抵抗率")
    call SetTypeName(57,"技能暴击抵抗率")  
    call SetTypeName(58,"指定单位攻击")
    call SetTypeName(59,"指定单位防御")
    call SetTypeName(60,"指定单位技能攻击") 
    call SetTypeName(61,"指定单位技能防御") 
    call SetTypeName(62,"指定单位暴击")       
    call SetTypeName(63,"指定单位暴击倍数")
    call SetTypeName(64,"指定单位技能暴击") 
    call SetTypeName(65,"指定单位技能暴击倍数")   
    call SetTypeName(66,"指定单位技能闪避") 
    call SetTypeName(67,"指定单位伤害化解概率")       
    call SetTypeName(68,"指定单位技能伤害化解概率") 
    call SetTypeName(69,"指定单位暴击伤害减少")   
    call SetTypeName(70,"指定单位技能暴击伤害减少") 
    call SetTypeName(71,"指定单位暴击抵抗率")
    call SetTypeName(72,"指定单位技能暴击抵抗率")  
    call SetTypeName(73,"物品——暴击伤害减少")
    call SetTypeName(74,"物品——技能暴击伤害减少")
    call SetTypeName(75,"物品——暴击抵抗率")    
    call SetTypeName(76,"物品——技能暴击抵抗率")          
    call SetTypeName(77,"总物品——暴击伤害减少")
    call SetTypeName(78,"总物品——技能暴击伤害减少")
    call SetTypeName(79,"总物品——暴击抵抗率")   
    call SetTypeName(80,"总物品——技能暴击抵抗率") 
    call SetTypeName(81,"指定单位透甲率")  
    call SetTypeName(82,"指定单位技能透甲率")    
    call SetTypeName(83,"指定单位吸血率")  
    call SetTypeName(84,"指定单位技能吸血率")        
    call SetTypeName(85,"物品——透甲率")  
    call SetTypeName(86,"物品——技能透甲率")    
    call SetTypeName(87,"物品——吸血率")  
    call SetTypeName(88,"物品——技能吸血率")    
    call SetTypeName(89,"总物品——透甲率") 
    call SetTypeName(90,"总物品——技能透甲率")   
    call SetTypeName(91,"总物品——吸血率") 
    call SetTypeName(92,"总物品——技能吸血率")   
    call SetTypeName(93,"指定单位反弹伤害率") 
    call SetTypeName(94,"指定单位技能反弹伤害率")   
    call SetTypeName(95,"指定单位吸收伤害率") 
    call SetTypeName(96,"指定单位技能吸收伤害率")   
endfunction

function SetTypeNamePreinstall takes nothing returns nothing
    call SetTypeName(100,"法术攻击")
    call SetTypeName(101,"普通攻击")
    call SetTypeName(102,"穿刺攻击")
    call SetTypeName(103,"攻城攻击")
    call SetTypeName(104,"魔法攻击")
    call SetTypeName(105,"混乱攻击")
    call SetTypeName(106,"英雄攻击")
    call SetTypeName(200,"没有护甲")
    call SetTypeName(201,"小型护甲")
    call SetTypeName(202,"中型护甲")
    call SetTypeName(203,"大型护甲")
    call SetTypeName(204,"建筑护甲")
    call SetTypeName(205,"普通护甲")
    call SetTypeName(206,"英雄护甲")
    call SetTypeName(207,"神圣护甲")
    call SetTypeName(300,"真实伤害")
    call SetTypeName(301,"通用伤害")
    call SetTypeName(302,"普通伤害")
    call SetTypeName(303,"强化伤害")
    call SetTypeName(304,"火焰伤害")
    call SetTypeName(305,"冰冻伤害")
    call SetTypeName(306,"闪电伤害")
    call SetTypeName(307,"暴风伤害")
    call SetTypeName(308,"毒药伤害")
    call SetTypeName(309,"神圣伤害")
    call SetTypeName(310,"暗魔伤害")
    call SetTypeName(400,"真实伤害防御")
    call SetTypeName(401,"通用伤害防御")
    call SetTypeName(402,"普通伤害防御")
    call SetTypeName(403,"强化伤害防御")
    call SetTypeName(404,"火焰伤害防御")
    call SetTypeName(405,"冰冻伤害防御")
    call SetTypeName(406,"闪电伤害防御")
    call SetTypeName(407,"暴风伤害防御")
    call SetTypeName(408,"毒药伤害防御")
    call SetTypeName(409,"神圣伤害防御")
    call SetTypeName(410,"暗魔伤害防御")
endfunction

function AttackDefensePreinstallDATA takes nothing returns nothing
    local integer i = 0
    local integer n = 0
    call SaveReal(DSHT, 100, 200, 1.00)
    call SaveReal(DSHT, 100, 201, 1.00)
    call SaveReal(DSHT, 100, 202, 1.00)
    call SaveReal(DSHT, 100, 203, 1.00)
    call SaveReal(DSHT, 100, 204, 1.00)
    call SaveReal(DSHT, 100, 205, 1.00)
    call SaveReal(DSHT, 100, 206, 0.70)
    call SaveReal(DSHT, 100, 207, 0.05)
    call SaveReal(DSHT, 101, 200, 1.00)
    call SaveReal(DSHT, 101, 201, 1.00)
    call SaveReal(DSHT, 101, 202, 1.50)
    call SaveReal(DSHT, 101, 203, 1.00)
    call SaveReal(DSHT, 101, 204, 0.70)
    call SaveReal(DSHT, 101, 205, 1.00)
    call SaveReal(DSHT, 101, 206, 1.00)
    call SaveReal(DSHT, 101, 207, 0.05)
    call SaveReal(DSHT, 102, 200, 1.50)
    call SaveReal(DSHT, 102, 201, 2.00)
    call SaveReal(DSHT, 102, 202, 0.75)
    call SaveReal(DSHT, 102, 203, 1.00)
    call SaveReal(DSHT, 102, 204, 0.35)
    call SaveReal(DSHT, 102, 205, 1.00)
    call SaveReal(DSHT, 102, 206, 0.50)
    call SaveReal(DSHT, 102, 207, 0.05)
    call SaveReal(DSHT, 103, 200, 1.50)
    call SaveReal(DSHT, 103, 201, 1.00)
    call SaveReal(DSHT, 103, 202, 0.50)
    call SaveReal(DSHT, 103, 203, 1.00)
    call SaveReal(DSHT, 103, 204, 1.50)
    call SaveReal(DSHT, 103, 205, 1.00)
    call SaveReal(DSHT, 103, 206, 0.50)
    call SaveReal(DSHT, 103, 207, 0.05)
    call SaveReal(DSHT, 104, 200, 1.00)
    call SaveReal(DSHT, 104, 201, 1.25)
    call SaveReal(DSHT, 104, 202, 0.75)
    call SaveReal(DSHT, 104, 203, 2.00)
    call SaveReal(DSHT, 104, 204, 0.35)
    call SaveReal(DSHT, 104, 205, 1.00)
    call SaveReal(DSHT, 104, 206, 1.00)
    call SaveReal(DSHT, 104, 207, 0.05)
    call SaveReal(DSHT, 105, 200, 1.00)
    call SaveReal(DSHT, 105, 201, 1.00)
    call SaveReal(DSHT, 105, 202, 1.00)
    call SaveReal(DSHT, 105, 203, 1.00)
    call SaveReal(DSHT, 105, 204, 1.00)
    call SaveReal(DSHT, 105, 205, 1.00)
    call SaveReal(DSHT, 105, 206, 1.00)
    call SaveReal(DSHT, 105, 207, 1.00)
    call SaveReal(DSHT, 106, 200, 1.00)
    call SaveReal(DSHT, 106, 201, 1.00)
    call SaveReal(DSHT, 106, 202, 1.00)
    call SaveReal(DSHT, 106, 203, 1.00)
    call SaveReal(DSHT, 106, 204, 0.50)
    call SaveReal(DSHT, 106, 205, 1.00)
    call SaveReal(DSHT, 106, 206, 1.00)
    call SaveReal(DSHT, 106, 207, 0.05)
    set i = 0
    loop
        exitwhen ( i > 10 )
        call SaveReal(DSHT, 300, ( 400 + i ), 1.00)
        set i = i + 1
    endloop
    call SaveReal(DSHT, 301, 401, 1.00)
    call SaveReal(DSHT, 301, 402, 1.25)
    call SaveReal(DSHT, 301, 403, 0.75)
    call SaveReal(DSHT, 301, 404, 1.00)
    call SaveReal(DSHT, 301, 405, 1.00)
    call SaveReal(DSHT, 301, 406, 1.00)
    call SaveReal(DSHT, 301, 407, 1.00)
    call SaveReal(DSHT, 301, 408, 1.00)
    call SaveReal(DSHT, 301, 409, 0.25)
    call SaveReal(DSHT, 301, 410, 1.25)
    call SaveReal(DSHT, 302, 401, 0.90)
    call SaveReal(DSHT, 302, 402, 1.00)
    call SaveReal(DSHT, 302, 403, 0.50)
    call SaveReal(DSHT, 302, 404, 1.00)
    call SaveReal(DSHT, 302, 405, 1.00)
    call SaveReal(DSHT, 302, 406, 1.00)
    call SaveReal(DSHT, 302, 407, 1.00)
    call SaveReal(DSHT, 302, 408, 1.00)
    call SaveReal(DSHT, 302, 409, 0.05)
    call SaveReal(DSHT, 302, 410, 1.00)
    call SaveReal(DSHT, 303, 401, 1.25)
    call SaveReal(DSHT, 303, 402, 1.50)
    call SaveReal(DSHT, 303, 403, 1.00)
    call SaveReal(DSHT, 303, 404, 1.00)
    call SaveReal(DSHT, 303, 405, 2.00)
    call SaveReal(DSHT, 303, 406, 0.50)
    call SaveReal(DSHT, 303, 407, 0.05)
    call SaveReal(DSHT, 303, 408, 1.00)
    call SaveReal(DSHT, 303, 409, 0.05)
    call SaveReal(DSHT, 303, 410, 1.00)
    call SaveReal(DSHT, 304, 401, 1.25)
    call SaveReal(DSHT, 304, 402, 2.00)
    call SaveReal(DSHT, 304, 403, 0.50)
    call SaveReal(DSHT, 304, 404, 1.00)
    call SaveReal(DSHT, 304, 405, 0.05)
    call SaveReal(DSHT, 304, 406, 2.00)
    call SaveReal(DSHT, 304, 407, 0.50)
    call SaveReal(DSHT, 304, 408, 1.00)
    call SaveReal(DSHT, 304, 409, 0.05)
    call SaveReal(DSHT, 304, 410, 0.75)
    call SaveReal(DSHT, 305, 401, 1.25)
    call SaveReal(DSHT, 305, 402, 1.50)
    call SaveReal(DSHT, 305, 403, 0.05)
    call SaveReal(DSHT, 305, 404, 2.00)
    call SaveReal(DSHT, 305, 405, 1.00)
    call SaveReal(DSHT, 305, 406, 0.50)
    call SaveReal(DSHT, 305, 407, 0.50)
    call SaveReal(DSHT, 305, 408, 1.00)
    call SaveReal(DSHT, 305, 409, 0.05)
    call SaveReal(DSHT, 305, 410, 1.00)
    call SaveReal(DSHT, 306, 401, 1.25)
    call SaveReal(DSHT, 306, 402, 2.00)
    call SaveReal(DSHT, 306, 403, 0.50)
    call SaveReal(DSHT, 306, 404, 1.00)
    call SaveReal(DSHT, 306, 405, 0.50)
    call SaveReal(DSHT, 306, 406, 1.00)
    call SaveReal(DSHT, 306, 407, 2.00)
    call SaveReal(DSHT, 306, 408, 1.00)
    call SaveReal(DSHT, 306, 409, 0.05)
    call SaveReal(DSHT, 306, 410, 1.25)
    call SaveReal(DSHT, 307, 401, 1.25)
    call SaveReal(DSHT, 307, 402, 1.25)
    call SaveReal(DSHT, 307, 403, 1.00)
    call SaveReal(DSHT, 307, 404, 0.05)
    call SaveReal(DSHT, 307, 405, 1.00)
    call SaveReal(DSHT, 307, 406, 0.05)
    call SaveReal(DSHT, 307, 407, 1.00)
    call SaveReal(DSHT, 307, 408, 1.00)
    call SaveReal(DSHT, 307, 409, 0.05)
    call SaveReal(DSHT, 307, 410, 1.00)
    call SaveReal(DSHT, 308, 401, 1.25)
    call SaveReal(DSHT, 308, 402, 1.50)
    call SaveReal(DSHT, 308, 403, 1.00)
    call SaveReal(DSHT, 308, 404, 1.00)
    call SaveReal(DSHT, 308, 405, 1.00)
    call SaveReal(DSHT, 308, 406, 1.00)
    call SaveReal(DSHT, 308, 407, 1.00)
    call SaveReal(DSHT, 308, 408, 0.05)
    call SaveReal(DSHT, 308, 409, 0.05)
    call SaveReal(DSHT, 308, 410, 0.25)
    call SaveReal(DSHT, 309, 401, 1.25)
    call SaveReal(DSHT, 309, 402, 2.00)
    call SaveReal(DSHT, 309, 403, 1.00)
    call SaveReal(DSHT, 309, 404, 1.00)
    call SaveReal(DSHT, 309, 405, 1.00)
    call SaveReal(DSHT, 309, 406, 1.00)
    call SaveReal(DSHT, 309, 407, 1.00)
    call SaveReal(DSHT, 309, 408, 1.50)
    call SaveReal(DSHT, 309, 409, 1.00)
    call SaveReal(DSHT, 309, 410, 2.00)
    call SaveReal(DSHT, 310, 401, 1.50)
    call SaveReal(DSHT, 310, 402, 2.00)
    call SaveReal(DSHT, 310, 403, 1.00)
    call SaveReal(DSHT, 310, 404, 1.50)
    call SaveReal(DSHT, 310, 405, 1.00)
    call SaveReal(DSHT, 310, 406, 1.00)
    call SaveReal(DSHT, 310, 407, 1.00)
    call SaveReal(DSHT, 310, 408, 0.75)
    call SaveReal(DSHT, 310, 409, 2.00)
    call SaveReal(DSHT, 310, 410, 1.00)
    set n = 1
    loop
        exitwhen ( n > 10 )
        call SaveReal(DSHT, ( 300 + n ), 400, 1.00)
        set n = n + 1
    endloop    
endfunction

function SetSkillHalfDamageBoolean takes integer unitid, boolean b returns nothing
    call SaveBoolean(DSHT, unitid, 15, b)
endfunction
function GetSkillHalfDamageBoolean takes integer unitid returns boolean
    return LoadBoolean(DSHT, unitid, 15)
endfunction
function SetHalfDamageFactor takes integer unitid, real HDF returns nothing
    call SetTypeData(unitid,40,HDF)
endfunction
function GetHalfDamageFactor takes integer unitid returns real
    return GetTypeData(unitid,40)
endfunction
function SetSkillHalfDamageFactor takes integer unitid, real SHDF returns nothing
    call SetTypeData(unitid,41,SHDF)
endfunction
function GetSkillHalfDamageFactor takes integer unitid returns real
    return GetTypeData(unitid,41)
endfunction

function SetItemTypeName takes integer itemid,string typename returns nothing
    if (typename == "") then
        set typename = "null"
    endif
    call SaveStr(DSITHT,itemid,51,typename) 
endfunction

function SetItemTypeNumberMax takes string typename,integer number returns nothing
    call SaveInteger(DSITHT,StringHash(typename),52,number)
endfunction

function GetItemTypeNumberMax takes string typename returns integer
    return LoadInteger(DSITHT,StringHash(typename),52) 
endfunction

function GetItemTypeName takes integer itemid returns string
    return LoadStr(DSITHT,itemid,51) 
endfunction

//! textmacro SetDataType takes Name,Index
function SetUnit$Name$Type takes unit whichunit,integer typeid,boolean b returns nothing
    local integer id = S2I(I2S(GetHandleId(whichunit))+I2S($Index$))
    call SaveBoolean(DSHT,id,typeid,b)
endfunction

function Unit$Name$Conditions takes unit whichunit,integer typeid returns boolean
    local integer id = S2I(I2S(GetHandleId(whichunit))+I2S($Index$))
    return LoadBoolean(DSHT,id,typeid)
endfunction

function SetUnit$Name$Damage takes unit whichunit,boolean b returns nothing
    local integer i = 100
    local integer n = 300   
    call SetUnit$Name$Type(whichunit,46,b)
    loop
        exitwhen i > 107
        call SetUnit$Name$Type(whichunit,i,b)
        set i = i + 1
    endloop
    loop
        exitwhen n > 311
        call SetUnit$Name$Type(whichunit,n,b)
        set n = n + 1
    endloop
endfunction
//! endtextmacro 

//! runtextmacro SetDataType ("Immune","11")
//! runtextmacro SetDataType ("Rebound","12")
//! runtextmacro SetDataType ("Absorption","13")

function SetReduceDamagePercent takes integer whichid, real c returns nothing
    if ( c <= 0.0 ) then
        set c = 0.0
    elseif ( c >= 1.0 ) then
        set c = 1.0
    endif
    call SaveReal(DSHT, whichid, 22, c) 
endfunction
function SetReduceDamage takes integer whichid, real c returns nothing
    call SaveReal(DSHT, whichid, 24,c) 
endfunction
function SetIncreaseDamagePercent takes integer whichid, real c returns nothing
    if ( c <= 0.0 ) then
        set c = 0.0
    endif
    call SaveReal(DSHT, whichid, 23, c) 
endfunction

function GetReduceDamagePercent takes integer whichid returns real
    return LoadReal(DSHT, whichid, 22) 
endfunction
function GetReduceDamage takes integer whichid returns real
    return LoadReal(DSHT, whichid, 24) 
endfunction
function GetIncreaseDamagePercent takes integer whichid returns real
    return LoadReal(DSHT, whichid, 23) 
endfunction

function GetUnitThumpDamageBool takes unit whichunit returns boolean
    return LoadBoolean(DSHT, GetHandleId(whichunit), 47) 
endfunction
function GetUnitDodgeDamageBool takes unit whichunit returns boolean
    return LoadBoolean(DSHT, GetHandleId(whichunit), 48) 
endfunction
function GetUnitHalfDamageBool takes unit whichunit returns boolean
    return LoadBoolean(DSHT, GetHandleId(whichunit), 49) 
endfunction

function SetUnitPredicable takes integer unitid, boolean bf, string AttackTypeName, real AttackValue, real RandomFactor, real Thump, real ThumpMultiple, string DefenseTypeName, real DefenseValue, string SkillDefenseTypeName, real SkillDefenseValue, real SkillDodge returns nothing   
    if ( AttackValue <= 0.0 ) then
        set AttackValue = 0
    endif
    if ( RandomFactor <= 0.0 ) then
        set RandomFactor = 0
    endif
    if ( Thump <= 0.0 ) then
        set Thump = 0.0
    elseif ( Thump >= 100.0 ) then
        set Thump = 100.0
    endif
    if ( ThumpMultiple <= 0.0 ) then
        set ThumpMultiple = 0.0
    endif
    if ( SkillDodge <= 0.0 ) then
        set SkillDodge = 0.0
    elseif ( SkillDodge >= 100.0 ) then
        set SkillDodge = 100.0
    endif
    call SetSkillHalfDamageBoolean(unitid,bf)
    call SetType(unitid,11,GetTypeId(AttackTypeName))
    call SetTypeData(unitid,GetTypeId(AttackTypeName),AttackValue)
    call SetTypeData(unitid,16,RandomFactor)
    call SetTypeData(unitid,17,Thump)
    call SetTypeData(unitid,18,ThumpMultiple)
    call SetType(unitid,12,GetTypeId(DefenseTypeName))
    call SetTypeData(unitid,GetTypeId(DefenseTypeName),DefenseValue)
    call SetType(unitid,14,GetTypeId(SkillDefenseTypeName))
    call SetTypeData(unitid,GetTypeId(SkillDefenseTypeName),SkillDefenseValue)
    call SetTypeData(unitid,19,SkillDodge)
    call SetTypeData(unitid,40,5.0)
    call SetTypeData(unitid,41,2.0)
endfunction   

function SetUnitSpecialPredicable takes integer unitid, real a, real b, real c, real d returns nothing
    call SetTypeData(unitid,54,a) //暴击伤害减少
    call SetTypeData(unitid,55,b) //技能暴击伤害减少
    call SetTypeData(unitid,56,c) //暴击抵抗率
    call SetTypeData(unitid,57,d) //技能暴击抵抗率 
endfunction
 
function SetSkillPredicable takes integer skillid, string SkillDamageTypeName, real SkillDamageValue, real SkillThump, real SkillThumpMultiple returns nothing    
    if ( SkillThump <= 0.0 ) then
        set SkillThump = 0.0
    elseif ( SkillThump >= 100.0 ) then
        set SkillThump = 100.0
    endif
    if ( SkillThumpMultiple <= 0.0 ) then
        set SkillThumpMultiple = 0.0
    endif
    call SetType(skillid,13,GetTypeId(SkillDamageTypeName))
    call SetTypeData(skillid,GetTypeId(SkillDamageTypeName),SkillDamageValue)
    call SetTypeData(skillid,20,SkillThump)
    call SetTypeData(skillid,21,SkillThumpMultiple)
endfunction   

function SetUnitSkillDamage takes integer unitid, real SkillDamage returns nothing    
    call SaveReal(DSHT,unitid,53,SkillDamage)
endfunction 
 
function SetUnitSkillPredicable takes integer unitid, real UnitSkillThump, real UnitSkillThumpMultiple returns nothing   
    if ( UnitSkillThump <= 0.0 ) then
        set UnitSkillThump = 0.0
    elseif ( UnitSkillThump >= 100.0 ) then
        set UnitSkillThump = 100.0
    endif
    if ( UnitSkillThumpMultiple <= 0.0 ) then
        set UnitSkillThumpMultiple = 0.0
    endif
    call SetTypeData(unitid,20,UnitSkillThump)
    call SetTypeData(unitid,21,UnitSkillThumpMultiple)
endfunction
 
function SetItemPredicable takes integer itemid, real AttackValue, real DefenseValue, real SkillDefenseValue, real Thump, real ThumpMultiple, real SkillDodge, real SkillThump, real SkillThumpMultiple, real SkillDamageIncrease , real SkillDamageValueIncrease returns nothing 
    if ( AttackValue <= 0.0 ) then
        set AttackValue = 0
    endif
    if ( Thump <= 0.0 ) then
        set Thump = 0.0
    elseif ( Thump >= 100.0 ) then
        set Thump = 100.0
    endif
    if ( ThumpMultiple <= 0.0 ) then
        set ThumpMultiple = 0.0
    endif
    if ( SkillDodge <= 0.0 ) then
        set SkillDodge = 0.0
    elseif ( SkillDodge >= 100.0 ) then
        set SkillDodge = 100.0
    endif
    if ( SkillThump <= 0.0 ) then
        set SkillThump = 0.0
    elseif ( SkillThump >= 100.0 ) then
        set SkillThump = 100.0
    endif
    if ( SkillThumpMultiple <= 0.0 ) then
        set SkillThumpMultiple = 0.0
    endif
    if ( SkillDamageIncrease <= 0.0 ) then
        set SkillDamageIncrease = 0.0
    endif
    if ( SkillDamageValueIncrease <= 0.0 ) then
        set SkillDamageValueIncrease = 0.0
    endif
    call SetTypeData(itemid,11,AttackValue)
    call SetTypeData(itemid,12,DefenseValue)
    call SetTypeData(itemid,14,SkillDefenseValue)
    call SetTypeData(itemid,17,Thump)
    call SetTypeData(itemid,18,ThumpMultiple)
    call SetTypeData(itemid,19,SkillDodge)
    call SetTypeData(itemid,20,SkillThump)
    call SetTypeData(itemid,21,SkillThumpMultiple)
    call SetTypeData(itemid,25,SkillDamageIncrease)
    call SetTypeData(itemid,26,SkillDamageValueIncrease)
    call SetReduceDamagePercent(itemid,0.0)
    call SetReduceDamage(itemid,0.0)
    call SetIncreaseDamagePercent(itemid,0.0)
endfunction

function SetItemSpecialPredicable takes integer itemid, real a, real b, real c, real d returns nothing
    call SetTypeData(itemid,73,a) //物品暴击伤害减少
    call SetTypeData(itemid,74,b) //物品技能暴击伤害减少
    call SetTypeData(itemid,75,c) //物品暴击抵抗率
    call SetTypeData(itemid,76,d) //物品技能暴击抵抗率   
endfunction

function SetItemSpecialPredicableAother takes integer itemid, real a, real b, real c, real d returns nothing
    call SetTypeData(itemid,85,a) //物品透甲率
    call SetTypeData(itemid,86,b) //物品技能透甲率
    call SetTypeData(itemid,87,c) //物品吸血率
    call SetTypeData(itemid,88,d) //物品技能吸血率 
endfunction

function UnitItemPredicable takes unit whichunit returns nothing
    local integer I = 0
    local integer UnitHandleId = S2I(I2S(10)+I2S(GetHandleId(whichunit))+I2S(1))   
    local real a = 0.0
    local real b = 0.0 
    local real c = 0.0
    local real d = 0.0
    local real e = 0.0
    local real f = 0.0
    local real g = 0.0
    local real h = 1.0
    local real i = 1.0
    local real j = 0.0
    local real k = 0.0
    local real l = 0.0
    local real m = 1.0
    local real n = 0.0  
    local real o = 0.0  
    local real p = 0.0  
    local real q = 0.0      
    local real r = 0.0  
    local real s = 0.0  
    local real t = 0.0  
    local real w = 0.0          
    set I = 1
    loop
        exitwhen ( I > GetMaxIndex(UnitHandleId) )
        set a = a + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 11)
        set b = b + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 12)
        set c = c + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 14)
        set d = d + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 17)
        set e = e + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 18)
        set f = f + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 19)
        set g = g + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 20)
        set h = h + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 21)
        set i = i + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 25)
        set j = j + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 26)
        set k = k + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 22)
        set l = l + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 24)
        set m = m + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 23)
        set n = n + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 73)      
        set o = o + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 74)      
        set p = p + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 75)      
        set q = q + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 76)
        set r = r + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 85)      
        set s = s + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 86)      
        set t = t + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 87)      
        set w = w + LoadReal(DSHT, GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT, GetHandleId(whichunit), I),0x100001)), 88)
        set I = I + 1
    endloop
    call SaveReal(DSHT, GetHandleId(whichunit), 27, a)     
    call SaveReal(DSHT, GetHandleId(whichunit), 28, b)               
    call SaveReal(DSHT, GetHandleId(whichunit), 29, c) 
    call SaveReal(DSHT, GetHandleId(whichunit), 30, d) 
    call SaveReal(DSHT, GetHandleId(whichunit), 31, e) 
    call SaveReal(DSHT, GetHandleId(whichunit), 32, f) 
    call SaveReal(DSHT, GetHandleId(whichunit), 33, g) 
    call SaveReal(DSHT, GetHandleId(whichunit), 34, h) 
    call SaveReal(DSHT, GetHandleId(whichunit), 35, i)
    call SaveReal(DSHT, GetHandleId(whichunit), 36, j)
    call SaveReal(DSHT, GetHandleId(whichunit), 37, k)
    call SaveReal(DSHT, GetHandleId(whichunit), 38, l)
    call SaveReal(DSHT, GetHandleId(whichunit), 39, m)
    call SaveReal(DSHT, GetHandleId(whichunit), 77, n)
    call SaveReal(DSHT, GetHandleId(whichunit), 78, o)
    call SaveReal(DSHT, GetHandleId(whichunit), 79, p)
    call SaveReal(DSHT, GetHandleId(whichunit), 80, q)
    call SaveReal(DSHT, GetHandleId(whichunit), 89, r)
    call SaveReal(DSHT, GetHandleId(whichunit), 90, s)
    call SaveReal(DSHT, GetHandleId(whichunit), 91, t)
    call SaveReal(DSHT, GetHandleId(whichunit), 92, w)  
endfunction

function DamageDispose takes unit whichunit, real damage returns real
    local real I = 0.0
    local real R1 = 0.0
    local real R2 = 0.0
    local real Damage = 0.0
    set I = LoadReal(DSHT, GetHandleId(whichunit), 23) + LoadReal(DSHT, GetHandleId(whichunit), 39)
    set R1 = LoadReal(DSHT, GetHandleId(whichunit), 22) + LoadReal(DSHT, GetHandleId(whichunit), 37) 
    set R2 = LoadReal(DSHT, GetHandleId(whichunit), 24) + LoadReal(DSHT, GetHandleId(whichunit), 38) 
    if ( I <= 0.0 ) then
        set I = 1.0
    endif
    if ( R1 <= 0.0 ) then
        set R1 = 1.0
    elseif ( R1 >= 1.0 ) then
        set R1 = 0.0
    elseif ( ( R1 > 0.0 ) and ( R1 < 1.0 ) ) then
        set R1 = 1.0 - R1
    endif
    set Damage = damage * I * R1 + R2
    if ( Damage <= 0.0 ) then
        set Damage = 0.0
    endif
    return Damage
endfunction

function CountMeleeOriginalDamageMain takes integer AttackTypeID, unit DamageSource, unit whichunit, real damage returns real
    local integer DamageSourceID
    local integer whichunitID
    local integer DefenseType
    local real Thump
    local real ThumpMultiple
    local real AttackValue
    local real DefenseValue
    local real DefensePercentage
    local real Coefficient
    local real Damage
    local real p    
    set DamageSourceID = GetUnitTypeId(DamageSource)
    set whichunitID = GetUnitTypeId(whichunit)
    call UnitItemPredicable(whichunit)
    set DefenseType = GetType(whichunitID,12)
    set Thump = LoadReal(DSHT, DamageSourceID, 17) + LoadReal(DSHT, GetHandleId(DamageSource), 30) - LoadReal(DSHT, whichunitID, 56) + LoadReal(DSHT,GetHandleId(DamageSource),62) - LoadReal(DSHT, GetHandleId(whichunit), 79) - LoadReal(DSHT, GetHandleId(whichunit), 71)
    if Thump <= 0.0 then
       set Thump = 0.0
    endif
    set ThumpMultiple = LoadReal(DSHT, DamageSourceID, 18) + LoadReal(DSHT, GetHandleId(DamageSource), 31) - LoadReal(DSHT, whichunitID, 54) + LoadReal(DSHT,GetHandleId(DamageSource),63) - LoadReal(DSHT, GetHandleId(whichunit), 77) - LoadReal(DSHT, GetHandleId(whichunit), 69)
    if ThumpMultiple <= 1.0 then
       set ThumpMultiple = 1.0
    endif
    set AttackValue = damage + ( RANDOM_Factor * GetRandomReal(0.0,LoadReal(DSHT, DamageSourceID, 16)) ) + LoadReal(DSHT, GetHandleId(DamageSource), 27) + LoadReal(DSHT,GetHandleId(DamageSource),42) + LoadReal(DSHT,GetHandleId(DamageSource),58)
    if ( LoadReal(DSHT, GetHandleId(DamageSource), 81) != 0.0 ) then
       set p = LoadReal(DSHT, GetHandleId(DamageSource), 81) + LoadReal(DSHT, GetHandleId(DamageSource), 89)
    elseif ( LoadReal(DSHT, GetHandleId(DamageSource), 81) == 0.0 ) then
       set p = 0
    endif   
    if ( p >= 1.0 ) then
       set p = 1.0
    elseif ( p <= 0.0 ) then
       set p = 0.0
    endif
    set DefenseValue = ( LoadReal(DSHT, whichunitID, DefenseType) + LoadReal(DSHT, GetHandleId(whichunit), 28) + LoadReal(DSHT,GetHandleId(whichunit),43) + LoadReal(DSHT,GetHandleId(whichunit),59) ) * ( 1 - p )
    if ( DefenseValue >= 0 ) then
        set DefensePercentage = ( DefenseValue * 0.06 ) / ( 1.0 + ( DefenseValue * 0.06 ) )
    elseif ( DefenseValue < 0 ) then
        set DefensePercentage = 2.0 - Pow(0.94,DefenseValue)
    endif
    set Coefficient = GetTypeData(AttackTypeID,DefenseType)
    if ( Probability(100.0 - (GetHalfDamageFactor(whichunitID)) + LoadReal(DSHT, GetHandleId(whichunit), 67)) == true ) then
        if ( Probability(Thump) == true ) then
            set Damage = Coefficient * ( ( ThumpMultiple * AttackValue ) * ( 1.0 - DefensePercentage ) )
            call SaveBoolean(DSHT,GetHandleId(whichunit),47,true)
            call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
            call SaveBoolean(DSHT,GetHandleId(whichunit),49,false)
        else
            set Damage = Coefficient * ( AttackValue * ( 1.0 - DefensePercentage ) )
            call SaveBoolean(DSHT,GetHandleId(whichunit),47,false)
            call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
            call SaveBoolean(DSHT,GetHandleId(whichunit),49,false)
        endif
    else
        set Damage = Coefficient * 0.5 * ( AttackValue * ( 1.0 - DefensePercentage ) )
        call SaveBoolean(DSHT,GetHandleId(whichunit),47,false)
        call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
        call SaveBoolean(DSHT,GetHandleId(whichunit),49,true)
    endif
    set Damage = DamageDispose(whichunit,Damage)
    call SaveReal(DSHT,GetHandleId(whichunit),50,Damage)
    return Damage
endfunction

function CountSkillOriginalDamageMain takes integer SkillID, integer DamageTypeID, unit DamageSource, unit whichunit, real damage returns real
    local integer DamageSourceID
    local integer whichunitID
    local integer SkillDefenseType
    local boolean bf
    local real SkillThump
    local real SkillDodge
    local real SkillThumpMultiple
    local real SkillDefenseValue
    local real DefensePercentage
    local real SkillCoefficient
    local real SkillDamage
    local real Damage
    local real p        
    set DamageSourceID = GetUnitTypeId(DamageSource)
    set whichunitID = GetUnitTypeId(whichunit)
    call UnitItemPredicable(whichunit)
    set bf = GetSkillHalfDamageBoolean(whichunitID)
    set SkillDefenseType = GetType(whichunitID,14)
    set SkillDamage = damage * LoadReal(DSHT, GetHandleId(DamageSource), 35) + LoadReal(DSHT, GetHandleId(DamageSource), 36) + LoadReal(DSHT,GetHandleId(DamageSource),44) + LoadReal(DSHT,DamageSourceID,53) + LoadReal(DSHT,GetHandleId(DamageSource),60)
    set SkillThump = LoadReal(DSHT, DamageSourceID, 20) + LoadReal(DSHT, SkillID, 20) + LoadReal(DSHT, GetHandleId(DamageSource), 33) - LoadReal(DSHT, whichunitID, 57) + LoadReal(DSHT,GetHandleId(DamageSource),64) - LoadReal(DSHT, GetHandleId(whichunit), 80) - LoadReal(DSHT, GetHandleId(whichunit), 72)
    if SkillThump <= 0.0 then
       set SkillThump = 0.0
    endif
    set SkillThumpMultiple = LoadReal(DSHT, DamageSourceID, 21) + LoadReal(DSHT, SkillID, 21) + LoadReal(DSHT, GetHandleId(DamageSource), 34) - LoadReal(DSHT, whichunitID, 55) + LoadReal(DSHT,GetHandleId(DamageSource),65) - LoadReal(DSHT, GetHandleId(whichunit), 78) - LoadReal(DSHT, GetHandleId(whichunit), 70)
    if SkillThumpMultiple <= 1.0 then
       set SkillThumpMultiple = 1.0
    endif
    set SkillCoefficient = GetTypeData(DamageTypeID,SkillDefenseType)
    if ( LoadReal(DSHT, GetHandleId(DamageSource), 82) != 0.0 ) then
       set p = LoadReal(DSHT, GetHandleId(DamageSource), 82) + LoadReal(DSHT, GetHandleId(DamageSource), 90)
    elseif ( LoadReal(DSHT, GetHandleId(DamageSource), 82) == 0.0 ) then
       set p = 0
    endif   
    if ( p >= 1.0 ) then
       set p = 1.0
    elseif ( p <= 0.0 ) then
       set p = 0.0
    endif   
    if (SkillDefenseType == 400) then
        set SkillDefenseValue = 0.0
    else
        set SkillDefenseValue = ( LoadReal(DSHT, whichunitID, SkillDefenseType) + LoadReal(DSHT, GetHandleId(whichunit), 29) + LoadReal(DSHT,GetHandleId(whichunit),45) + LoadReal(DSHT,GetHandleId(whichunit),61) ) * ( 1 - p )
    endif
    if ( SkillDefenseValue >= 0 ) then
        set DefensePercentage = ( SkillDefenseValue * 0.06 ) / ( 1.0 + ( SkillDefenseValue * 0.06 ) )
    elseif ( SkillDefenseValue < 0 ) then
        set DefensePercentage = 2.0 - Pow(0.94,SkillDefenseValue)
    endif
    set SkillDodge = LoadReal(DSHT, whichunitID, 19) + LoadReal(DSHT, GetHandleId(whichunit), 32) + LoadReal(DSHT,GetHandleId(whichunit),66)
    if ( Probability(SkillDodge) == true ) then
        set Damage = 0.0
        call SaveBoolean(DSHT,GetHandleId(whichunit),47,false)
        call SaveBoolean(DSHT,GetHandleId(whichunit),48,true)
        call SaveBoolean(DSHT,GetHandleId(whichunit),49,false)
    else
        if ( bf == true) then
            if ( Probability(100.0 - (GetSkillHalfDamageFactor(whichunitID) + LoadReal(DSHT, GetHandleId(whichunit), 68))) == true ) then
                if ( Probability(SkillThump) == true ) then
                    set Damage = SkillThumpMultiple * ( SkillDamage * ( 1.0 - DefensePercentage ) )
                    call SaveBoolean(DSHT,GetHandleId(whichunit),47,true)
                    call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
                    call SaveBoolean(DSHT,GetHandleId(whichunit),49,false)
                else
                    set Damage = SkillDamage * ( 1.0 - DefensePercentage )
                    call SaveBoolean(DSHT,GetHandleId(whichunit),47,false)
                    call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
                    call SaveBoolean(DSHT,GetHandleId(whichunit),49,false)
                endif
            else
                set Damage = 0.5 * SkillDamage * ( 1.0 - DefensePercentage )
                call SaveBoolean(DSHT,GetHandleId(whichunit),47,false)
                call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
                call SaveBoolean(DSHT,GetHandleId(whichunit),49,true)
            endif
        else
            if ( Probability(SkillThump) == true ) then
                set Damage = SkillThumpMultiple * ( SkillDamage * ( 1.0 - DefensePercentage ) )
                call SaveBoolean(DSHT,GetHandleId(whichunit),47,true)
                call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
                call SaveBoolean(DSHT,GetHandleId(whichunit),49,false)
            else
                set Damage = SkillDamage * ( 1.0 - DefensePercentage )
                call SaveBoolean(DSHT,GetHandleId(whichunit),47,false)
                call SaveBoolean(DSHT,GetHandleId(whichunit),48,false)
                call SaveBoolean(DSHT,GetHandleId(whichunit),49,false)
            endif
        endif
    endif
    set Damage = DamageDispose(whichunit,Damage) * SkillCoefficient
    call SaveReal(DSHT,GetHandleId(whichunit),50,Damage)
    return Damage
endfunction

function MeleeOriginalDamageMain takes unit DamageSource, unit whichunit returns real
    return CountMeleeOriginalDamageMain(GetType(GetUnitTypeId(DamageSource),11),DamageSource,whichunit,LoadReal(DSHT,GetUnitTypeId(DamageSource),GetType(GetUnitTypeId(DamageSource),11)))
endfunction

function SkillOriginalDamageMain takes integer SkillID, unit DamageSource, unit whichunit returns real
    return CountSkillOriginalDamageMain(SkillID,GetType(SkillID,13),DamageSource,whichunit,LoadReal(DSHT,SkillID,GetType(SkillID,13)))
endfunction

function MimeticdDamage takes unit DamageSource, unit DamagedUnit, real Damage returns nothing
    local real UnitState = GetUnitState(DamagedUnit, UNIT_STATE_LIFE)
    if ( Damage != 0.0 ) then
        if ( UnitState > Damage ) then
            call SaveReal(DSHT,GetHandleId(DamagedUnit),6,Damage)
            call SetUnitState( DamagedUnit, UNIT_STATE_LIFE, (UnitState - Damage) )
        elseif ( UnitState <= Damage ) then
            call SaveBoolean(DSHT,GetHandleId(DamagedUnit),5,true)
            call KillUnit(DamagedUnit)
            call HeroGetEXP(DamagedUnit,DamageSource)
            call SaveReal(DSHT,GetHandleId(DamagedUnit),6,UnitState)
        endif
    elseif ( Damage == 0.0 ) then
        call SaveReal(DSHT,GetHandleId(DamagedUnit),6,0.0)
    endif
endfunction

function GetUnitDamageBeforeMimeticd takes unit DamagedUnit returns real
    return LoadReal(DSHT,GetHandleId(DamagedUnit),50)
endfunction

function GetUnitMimeticdDamage takes unit DamagedUnit returns real
    return LoadReal(DSHT,GetHandleId(DamagedUnit),6)
endfunction

function MimeticdMeleeDamage takes unit DamageSource, unit DamagedUnit returns nothing
    local real a = LoadReal(DSHT, GetHandleId(DamagedUnit), 93)
    local real b = LoadReal(DSHT, GetHandleId(DamagedUnit), 95)
    local real c = LoadReal(DSHT, GetHandleId(DamageSource), 83) + LoadReal(DSHT, GetHandleId(DamageSource), 91)
    local real d = 0.0
    local boolean b0 = UnitImmuneConditions(DamagedUnit,GetType(GetUnitTypeId(DamageSource),11))
    local boolean B1 = UnitReboundConditions(DamagedUnit,GetType(GetUnitTypeId(DamageSource),11))
    local boolean B2 = UnitAbsorptionConditions(DamagedUnit,GetType(GetUnitTypeId(DamageSource),11))
    if (a >= 1.0) then
        set a = 1.0
    elseif (a <= 0.0) then
        set a = 0.0
    endif
    if ( b <= 0.0 ) then
        set b = 0.0
    endif    
    if ( c >= 1.0 ) then 
        set c = 1.0
    elseif ( c <= 0.0 ) then 
        set c = 0.0
    endif   
    if (b0 == false) then
        set d = MeleeOriginalDamageMain(DamageSource,DamagedUnit)
        call MimeticdDamage(DamageSource,DamagedUnit,d)
        call SaveReal(DSHT,GetHandleId(DamagedUnit),6,d)    
    elseif (b0 == true) then
        set d = 0.0
        call SaveReal(DSHT,GetHandleId(DamagedUnit),6,d)    
    endif   
    if ((IsUnitType(DamagedUnit, UNIT_TYPE_HERO) == true)) then
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamagedUnit,d,20.0,11.0,rgb_R[1],rgb_G[1],rgb_B[1],rgb_A[1])
        endif
    elseif ((IsUnitType(DamagedUnit, UNIT_TYPE_HERO) == false)) then
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamagedUnit,d,20.0,11.0,rgb_R[2],rgb_G[2],rgb_B[2],rgb_A[2])
        endif
    endif
    if (( UnitTypeConditions_A(DamagedUnit) == false )) then
        call SetUnitState( DamageSource, UNIT_STATE_LIFE, (GetUnitState(DamageSource, UNIT_STATE_LIFE) + d * c) )
    endif
    if ((a != 0.0) and (B1 == true)) then
        call MimeticdDamage(DamagedUnit,DamageSource,a * d)
        call SaveReal(DSHT,GetHandleId(DamageSource),6,a * d)   
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamageSource,GetUnitMimeticdDamage(DamageSource),20.0,11.0,rgb_R[6],rgb_G[6],rgb_B[6],rgb_A[6])
        endif
    endif
    if ((b != 0.0) and (B2 == true)) then
        call SetUnitState( DamagedUnit, UNIT_STATE_LIFE, (GetUnitState(DamagedUnit, UNIT_STATE_LIFE) + b * d) )
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamagedUnit,b*d,20.0,11.0,rgb_R[5],rgb_G[5],rgb_B[5],rgb_A[5])
        endif
    endif   
endfunction

function MimeticdSkillDamage takes integer SkillID, unit DamageSource, unit DamagedUnit returns nothing
    local real a = LoadReal(DSHT, GetHandleId(DamagedUnit), 94)
    local real b = LoadReal(DSHT, GetHandleId(DamagedUnit), 96)
    local real c = LoadReal(DSHT, GetHandleId(DamageSource), 84) + LoadReal(DSHT, GetHandleId(DamageSource), 92)
    local real d = 0.0
    local boolean b0 = UnitImmuneConditions(DamagedUnit,GetType(SkillID,13))    
    local boolean B1 = UnitReboundConditions(DamagedUnit,GetType(SkillID,13))
    local boolean B2 = UnitAbsorptionConditions(DamagedUnit,GetType(SkillID,13))  
    if (a >= 1.0) then
        set a = 1.0
    elseif (a <= 0.0) then
        set a = 0.0
    endif
    if ( b <= 0.0 ) then
        set b = 0.0
    endif
    if ( c >= 1.0 ) then 
        set c = 1.0
    elseif ( c <= 0.0 ) then 
        set c = 0.0
    endif   
    if (b0 == false) then
        set d = SkillOriginalDamageMain(SkillID,DamageSource,DamagedUnit)
        call UnitDamageTarget(DamageSource,DamagedUnit,0.01,false,false,ATTACK_TYPE_NORMAL,null,WEAPON_TYPE_WHOKNOWS)
        call MimeticdDamage(DamageSource,DamagedUnit,d)
        call SaveReal(DSHT,GetHandleId(DamagedUnit),6,d)    
    elseif (b0 == true) then
        set d = 0.0 
    endif   
    if (( UnitTypeConditions_A(DamagedUnit) == false )) then
        call SetUnitState( DamageSource, UNIT_STATE_LIFE, (GetUnitState(DamageSource, UNIT_STATE_LIFE) + d * c) )
    endif
    if ((a != 0.0) and (B1 == true)) then
        call MimeticdDamage(DamagedUnit,DamageSource,a * d)
        call SaveReal(DSHT,GetHandleId(DamageSource),6,a * d)
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamageSource,GetUnitMimeticdDamage(DamageSource),20.0,11.0,rgb_R[6],rgb_G[6],rgb_B[6],rgb_A[6])
        endif
    endif
    if ((b != 0.0) and (B2 == true)) then
        call SetUnitState( DamagedUnit, UNIT_STATE_LIFE, (GetUnitState(DamagedUnit, UNIT_STATE_LIFE) + b * d) )
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamagedUnit,b*d,20.0,11.0,rgb_R[5],rgb_G[5],rgb_B[5],rgb_A[5])
        endif
    endif
endfunction

function MimeticdMeleeDamage_Type takes unit DamageSource, unit DamagedUnit, integer AttackTypeID, real damage returns nothing
    local real a = LoadReal(DSHT, GetHandleId(DamagedUnit), 93)
    local real b = LoadReal(DSHT, GetHandleId(DamagedUnit), 95)
    local real c = LoadReal(DSHT, GetHandleId(DamageSource), 83) + LoadReal(DSHT, GetHandleId(DamageSource), 91)
    local real d = 0.0
    local boolean b0 = UnitImmuneConditions(DamagedUnit,AttackTypeID)   
    local boolean B1 = UnitReboundConditions(DamagedUnit,AttackTypeID)
    local boolean B2 = UnitAbsorptionConditions(DamagedUnit,AttackTypeID)   
    if (a >= 1.0) then
        set a = 1.0
    elseif (a <= 0.0) then
        set a = 0.0
    endif
    if ( b <= 0.0 ) then
        set b = 0.0
    endif    
    if ( c >= 1.0 ) then 
        set c = 1.0
    elseif ( c <= 0.0 ) then 
        set c = 0.0
    endif   
    if (b0 == false) then
        set d = CountMeleeOriginalDamageMain(AttackTypeID,DamageSource,DamagedUnit,damage)  
        call MimeticdDamage(DamageSource,DamagedUnit,d)
        call SaveReal(DSHT,GetHandleId(DamagedUnit),6,d)    
    elseif (b0 == true) then
        set d = 0.0
    endif   
    if (( UnitTypeConditions_A(DamagedUnit) == false )) then
        call SetUnitState( DamageSource, UNIT_STATE_LIFE, (GetUnitState(DamageSource, UNIT_STATE_LIFE) + d * c) )
    endif  
    if ((a != 0.0) and (B1 == true)) then
        call MimeticdDamage(DamagedUnit,DamageSource,a * d)
        call SaveReal(DSHT,GetHandleId(DamageSource),6,a * d)
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamageSource,GetUnitMimeticdDamage(DamageSource),20.0,11.0,rgb_R[6],rgb_G[6],rgb_B[6],rgb_A[6])
        endif
    endif
    if ((b != 0.0) and (B2 == true)) then
        call SetUnitState( DamagedUnit, UNIT_STATE_LIFE, (GetUnitState(DamagedUnit, UNIT_STATE_LIFE) + b * d) )
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamagedUnit,b*d,20.0,11.0,rgb_R[5],rgb_G[5],rgb_B[5],rgb_A[5])
        endif
    endif
endfunction

function MimeticdSkillDamage_Type takes integer SkillID, unit DamageSource, unit DamagedUnit, integer DamageTypeID, real damage returns nothing
    local real a = LoadReal(DSHT, GetHandleId(DamagedUnit), 94)
    local real b = LoadReal(DSHT, GetHandleId(DamagedUnit), 96)
    local real c = LoadReal(DSHT, GetHandleId(DamageSource), 84) + LoadReal(DSHT, GetHandleId(DamageSource), 92)
    local real d = 0.0
    local boolean b0 = UnitImmuneConditions(DamagedUnit,DamageTypeID)       
    local boolean B1 = UnitReboundConditions(DamagedUnit,DamageTypeID)
    local boolean B2 = UnitAbsorptionConditions(DamagedUnit,DamageTypeID)   
    if (a >= 1.0) then
        set a = 1.0
    elseif (a <= 0.0) then
        set a = 0.0
    endif
    if ( b <= 0.0 ) then
        set b = 0.0
    endif
    if ( c >= 1.0 ) then 
        set c = 1.0
    elseif ( c <= 0.0 ) then 
        set c = 0.0
    endif   
    if (b0 == false) then
        set d = CountSkillOriginalDamageMain(SkillID,DamageTypeID,DamageSource,DamagedUnit,damage)
        call UnitDamageTarget(DamageSource,DamagedUnit,0.01,false,false,ATTACK_TYPE_NORMAL,null,WEAPON_TYPE_WHOKNOWS)
        call MimeticdDamage(DamageSource,DamagedUnit,d)
        call SaveReal(DSHT,GetHandleId(DamagedUnit),6,d)    
    elseif (b0 == true) then
        set d = 0.0
    endif   
    if (( UnitTypeConditions_A(DamagedUnit) == false )) then
        call SetUnitState( DamageSource, UNIT_STATE_LIFE, (GetUnitState(DamageSource, UNIT_STATE_LIFE) + d * c) )
    endif
    if ((a != 0.0) and (B1 == true)) then
        call MimeticdDamage(DamagedUnit,DamageSource,a * d)
        call SaveReal(DSHT,GetHandleId(DamageSource),6,a * d)
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamageSource,GetUnitMimeticdDamage(DamageSource),20.0,11.0,rgb_R[6],rgb_G[6],rgb_B[6],rgb_A[6])
        endif
    endif
    if ((b != 0.0) and (B2 == true)) then
        call SetUnitState( DamagedUnit, UNIT_STATE_LIFE, (GetUnitState(DamagedUnit, UNIT_STATE_LIFE) + b * d) )
        if (DisplayDamageBool == true) then
            call DisplayDamage(DamagedUnit,b*d,20.0,11.0,rgb_R[5],rgb_G[5],rgb_B[5],rgb_A[5])
        endif
    endif
endfunction

function DisplayPreinstallUnitPredicable takes unit whichunit, real timeout returns nothing
    local integer whichunitID
    set whichunitID = GetUnitTypeId(whichunit)
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+"|r")
    call Print(timeout,color_str[1]+TypeId2S(11)+":"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,11))+"|r")
    call Print(timeout,color_str[2]+"攻击力:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, GetType(whichunitID,11)))+"|r")
    call Print(timeout,color_str[3]+TypeId2S(12)+":"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,12))+"|r") 
    call Print(timeout,color_str[4]+"防御:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, GetType(whichunitID,12)))+"|r")
    call Print(timeout,color_str[5]+TypeId2S(14)+":"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,14))+"|r")     
    call Print(timeout,color_str[6]+"技能防御:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, GetType(whichunitID,14)))+"|r")     
    call Print(timeout,color_str[7]+TypeId2S(16)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 16))+"|r")     
    call Print(timeout,color_str[8]+TypeId2S(17)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 17))+"|r")     
    call Print(timeout,color_str[9]+TypeId2S(18)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 18))+"|r")     
    call Print(timeout,color_str[10]+TypeId2S(19)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 19))+"|r")  
    call Print(timeout,color_str[11]+TypeId2S(20)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 20))+"|r")     
    call Print(timeout,color_str[12]+TypeId2S(21)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 21))+"|r") 
endfunction

function DisplayPreinstallUnitSpecialPredicable takes unit whichunit, real timeout returns nothing
    local integer whichunitID
    set whichunitID = GetUnitTypeId(whichunit) 
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+"|r")    
    call Print(timeout,color_str[13]+TypeId2S(54)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 54))+"|r")     
    call Print(timeout,color_str[14]+TypeId2S(55)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 55))+"|r")  
    call Print(timeout,color_str[15]+TypeId2S(56)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 56))+"|r")     
    call Print(timeout,color_str[16]+TypeId2S(57)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 57))+"|r") 
    call Print(timeout,color_str[17]+TypeId2S(22)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, GetHandleId(whichunit), 22))+"|r") 
    call Print(timeout,color_str[18]+TypeId2S(23)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, GetHandleId(whichunit), 23))+"|r") 
    call Print(timeout,color_str[19]+TypeId2S(24)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, GetHandleId(whichunit), 24))+"|r") 
endfunction

function DisplayPreinstallItemPredicable takes player whichplayer, integer itemid, real timeout returns nothing
    call Print(timeout,color_str[20]+GetObjectName(itemid)+"|r")
    call Print(timeout,color_str[21]+"物品攻击值加成:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 11))+"|r")
    call Print(timeout,color_str[22]+"物品防御值加成:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 12))+"|r")
    call Print(timeout,color_str[23]+"物品技能防御值加成:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 14))+"|r")
    call Print(timeout,color_str[24]+"物品——单位暴击概率(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 17))+"|r")
    call Print(timeout,color_str[25]+"物品——单位暴击倍数:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 18))+"|r")
    call Print(timeout,color_str[26]+"物品——单位技能闪避力(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 19))+"|r")
    call Print(timeout,color_str[27]+"物品——技能暴击概率(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 20))+"|r")
    call Print(timeout,color_str[28]+"物品——技能暴击倍数:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 21))+"|r")
    call Print(timeout,color_str[29]+TypeId2S(25)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 25))+"|r")
    call Print(timeout,color_str[30]+TypeId2S(26)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 26))+"|r")  
endfunction

function DisplayPreinstallItemSpecialPredicable takes player whichplayer, integer itemid, real timeout returns nothing
    call Print(timeout,color_str[20]+GetObjectName(itemid)+"|r")
    call Print(timeout,color_str[31]+TypeId2S(73)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 73))+"|r")
    call Print(timeout,color_str[32]+TypeId2S(74)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 74))+"|r")
    call Print(timeout,color_str[33]+TypeId2S(75)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 75))+"|r")
    call Print(timeout,color_str[34]+TypeId2S(76)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 76))+"|r")
    call Print(timeout,color_str[35]+TypeId2S(85)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 85))+"|r")
    call Print(timeout,color_str[36]+TypeId2S(86)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 86))+"|r")
    call Print(timeout,color_str[37]+TypeId2S(87)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 87))+"|r")
    call Print(timeout,color_str[38]+TypeId2S(88)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 88))+"|r")     
    call Print(timeout,color_str[39]+"物品——单位减伤（百分比）:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 22))+"|r")
    call Print(timeout,color_str[40]+"物品——单位增伤（百分比）:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 23))+"|r")
    call Print(timeout,color_str[41]+"物品——单位伤害修改（数值）:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 24))+"|r")    
endfunction

function DisplayPreinstallSkillPredicable takes player whichplayer, integer skillid, real timeout returns nothing
    call Print(timeout,color_str[42]+GetObjectName(skillid)+"|r")
    call Print(timeout,color_str[43]+TypeId2S(13)+":"+"|r"+color_str[100]+TypeId2S(GetType(skillid,13))+"|r")
    call Print(timeout,color_str[44]+TypeId2S(20)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, skillid, 20))+"|r")
    call Print(timeout,color_str[45]+TypeId2S(21)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, skillid, 21))+"|r")
    call Print(timeout,color_str[46]+"技能伤害:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, skillid, GetType(skillid,13)))+"|r")
endfunction

function DisplayUnitPredicable takes unit whichunit, real timeout returns nothing
    local integer whichunitID
    local real Thump
    local real ThumpMultiple
    local real AttackValue
    local real DefenseValue
    local real SkillThump
    local real SkillThumpMultiple
    local real SkillDamage
    local real SkillDefenseValue
    local real SkillDodge
    set whichunitID = GetUnitTypeId(whichunit)
    call UnitItemPredicable(whichunit) 
    set Thump = LoadReal(DSHT, whichunitID, 17) + LoadReal(DSHT, GetHandleId(whichunit), 30) + LoadReal(DSHT,GetHandleId(whichunit),62)
    if Thump <= 0.0 then
       set Thump = 0.0
    endif
    set ThumpMultiple = LoadReal(DSHT, whichunitID, 18) + LoadReal(DSHT, GetHandleId(whichunit), 31) + LoadReal(DSHT,GetHandleId(whichunit),63)
    if ThumpMultiple <= 1.0 then
       set ThumpMultiple = 1.0
    endif
    set AttackValue = LoadReal(DSHT, whichunitID, GetType(whichunitID,11)) + LoadReal(DSHT, GetHandleId(whichunit), 27) + LoadReal(DSHT,GetHandleId(whichunit),42) + LoadReal(DSHT,GetHandleId(whichunit),58)
    set DefenseValue = LoadReal(DSHT, whichunitID, GetType(whichunitID,12)) + LoadReal(DSHT, GetHandleId(whichunit), 28) + LoadReal(DSHT,GetHandleId(whichunit),43) + LoadReal(DSHT,GetHandleId(whichunit),59)
    set SkillThump = LoadReal(DSHT, whichunitID, 20) + LoadReal(DSHT, GetHandleId(whichunit), 33) + LoadReal(DSHT,GetHandleId(whichunit),64)
    if SkillThump <= 0.0 then
       set SkillThump = 0.0
    endif   
    set SkillThumpMultiple = LoadReal(DSHT, whichunitID, 21) + LoadReal(DSHT, GetHandleId(whichunit), 34) + LoadReal(DSHT,GetHandleId(whichunit),65)
    if SkillThumpMultiple <= 1.0 then
       set SkillThumpMultiple = 1.0
    endif   
    set SkillDamage = LoadReal(DSHT,GetHandleId(whichunit),44) + LoadReal(DSHT,whichunitID,53) + LoadReal(DSHT,GetHandleId(whichunit),60)
    set SkillDefenseValue = LoadReal(DSHT, whichunitID, GetType(whichunitID,14)) + LoadReal(DSHT, GetHandleId(whichunit), 29) + LoadReal(DSHT,GetHandleId(whichunit),45) + LoadReal(DSHT,GetHandleId(whichunit),61)
    set SkillDodge = LoadReal(DSHT, whichunitID, 19) + LoadReal(DSHT, GetHandleId(whichunit), 32) + LoadReal(DSHT,GetHandleId(whichunit),66)
    if ( Thump >= 100.0 ) then
        set Thump = 100.0
    endif
    if ( SkillThump >= 100.0 ) then
        set SkillThump = 100.0
    endif
    if ( SkillDodge >= 100.0 ) then
        set SkillDodge = 100.0
    endif
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[1]+TypeId2S(11)+":"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,11))+"|r")
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[2]+"攻击力:"+"|r"+color_str[100]+R2S(AttackValue)+"|r")
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[3]+TypeId2S(12)+":"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,12))+"|r")  
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[4]+"防御:"+"|r"+color_str[100]+R2S(DefenseValue)+"|r")
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[47]+"附加技能伤害:"+"|r"+color_str[100]+R2S(SkillDamage)+"|r")  
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[5]+TypeId2S(14)+":"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,14))+"|r")       
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[6]+"技能防御:"+"|r"+color_str[100]+R2S(SkillDefenseValue)+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[7]+TypeId2S(16)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, whichunitID, 16))+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[8]+TypeId2S(17)+"(百分比):"+"|r"+color_str[100]+R2S(Thump)+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[9]+TypeId2S(18)+":"+"|r"+color_str[100]+R2S(ThumpMultiple)+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[10]+TypeId2S(19)+"(百分比):"+"|r"+color_str[100]+R2S(SkillDodge)+"|r")  
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[11]+TypeId2S(20)+"(百分比):"+"|r"+color_str[100]+R2S(SkillThump)+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[12]+TypeId2S(21)+":"+"|r"+color_str[100]+R2S(SkillThumpMultiple)+"|r")    
endfunction

function DisplayUnitSpecialPredicable takes unit whichunit, real timeout returns nothing
    local integer whichunitID
    local real a = 0.0
    local real b = 0.0
    local real c = 0.0
    local real d = 0.0  
    local real e = 0.0  
    local real f = 0.0  
    local real g = 0.0  
    local real h = 0.0  
    local real I = 0.0
    local real R1 = 0.0
    local real R2 = 0.0
    set whichunitID = GetUnitTypeId(whichunit)
    call UnitItemPredicable(whichunit)  
    set a = LoadReal(DSHT, whichunitID, 54) + LoadReal(DSHT, GetHandleId(whichunit), 69) + LoadReal(DSHT, GetHandleId(whichunit), 77)
    set b = LoadReal(DSHT, whichunitID, 55) + LoadReal(DSHT, GetHandleId(whichunit), 70) + LoadReal(DSHT, GetHandleId(whichunit), 78)
    set c = LoadReal(DSHT, whichunitID, 56) + LoadReal(DSHT, GetHandleId(whichunit), 71) + LoadReal(DSHT, GetHandleId(whichunit), 79)
    set d = LoadReal(DSHT, whichunitID, 57) + LoadReal(DSHT, GetHandleId(whichunit), 72) + LoadReal(DSHT, GetHandleId(whichunit), 80)
    set e = LoadReal(DSHT, GetHandleId(whichunit), 81) + LoadReal(DSHT, GetHandleId(whichunit), 89)
    if ( e >= 1.0 ) then 
        set e = 1.0
    elseif ( e <= 0.0 ) then 
        set e = 0.0
    endif           
    set f = LoadReal(DSHT, GetHandleId(whichunit), 82) + LoadReal(DSHT, GetHandleId(whichunit), 90)
    if ( f >= 1.0 ) then 
        set f = 1.0
    elseif ( f <= 0.0 ) then 
        set f = 0.0
    endif   
    set g = LoadReal(DSHT, GetHandleId(whichunit), 83) + LoadReal(DSHT, GetHandleId(whichunit), 91)
    if ( g >= 1.0 ) then 
        set g = 1.0
    elseif ( g <= 0.0 ) then 
        set g = 0.0
    endif           
    set h = LoadReal(DSHT, GetHandleId(whichunit), 84) + LoadReal(DSHT, GetHandleId(whichunit), 92)
    if ( h >= 1.0 ) then 
        set h = 1.0
    elseif ( h <= 0.0 ) then 
        set h = 0.0
    endif               
    set I = LoadReal(DSHT, GetHandleId(whichunit), 23) + LoadReal(DSHT, GetHandleId(whichunit), 39) 
    set R1 = LoadReal(DSHT, GetHandleId(whichunit), 22) + LoadReal(DSHT, GetHandleId(whichunit), 37) 
    set R2 = LoadReal(DSHT, GetHandleId(whichunit), 24) + LoadReal(DSHT, GetHandleId(whichunit), 38) 
    if ( I <= 0.0 ) then
        set I = 1.0
    endif
    if ( R1 <= 0.0 ) then
        set R1 = 0.0
    elseif ( R1 >= 1.0 ) then
        set R1 = 1.0
    endif   
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[13]+TypeId2S(54)+":"+"|r"+color_str[100]+R2S(a)+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[14]+TypeId2S(55)+":"+"|r"+color_str[100]+R2S(b)+"|r")  
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[15]+TypeId2S(56)+"(百分比):"+"|r"+color_str[100]+R2S(c)+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[16]+TypeId2S(57)+"(百分比):"+"|r"+color_str[100]+R2S(d)+"|r")
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[48]+"透甲率:"+"|r"+color_str[100]+R2S(e)+"|r") 
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[49]+"技能透甲率:"+"|r"+color_str[100]+R2S(f)+"|r") 
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[50]+"吸血率:"+"|r"+color_str[100]+R2S(g)+"|r") 
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[51]+"技能吸血率:"+"|r"+color_str[100]+R2S(h)+"|r")     
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[17]+TypeId2S(22)+":"+"|r"+color_str[100]+R2S(R1)+"|r")  
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[18]+TypeId2S(23)+":"+"|r"+color_str[100]+R2S(I)+"|r") 
    call Print(timeout,color_str[0]+GetUnitName(whichunit)+":"+"|r"+color_str[19]+TypeId2S(24)+":"+"|r"+color_str[100]+R2S(R2)+"|r")    
endfunction

function TriggerRegisterAnyUnitDamagedEvent takes trigger t,integer tp returns nothing
    if (tp == 0) then //Melee Damage
        set MeleeListEnd = MeleeListEnd + 1
        set MeleeNextIndex[MeleeListEnd - 1] = MeleeListEnd
        set MeleeLastIndex[MeleeListEnd] = MeleeListEnd - 1
        set MeleeTriggerList[MeleeListEnd] = t
    elseif (tp == 1) then // Magic Damage
        set MagicListEnd = MagicListEnd + 1
        set MagicNextIndex[MagicListEnd - 1] = MagicListEnd
        set MagicLastIndex[MagicListEnd] = MagicListEnd - 1
        set MagicTriggerList[MagicListEnd] = t
    endif
endfunction

function DestroyAnyUnitDamagedEvent takes trigger t,integer tp returns nothing
    local integer index 
    if (tp == 0) then
         set index = MeleeNextIndex[0]
        loop
             exitwhen (index == 0)
             exitwhen (MeleeTriggerList[index] == t)
             set index = MeleeNextIndex[index]
        endloop
        call DestroyTrigger(t)
        if (index > 0) then
            set MeleeNextIndex[MeleeLastIndex[index]] = MeleeNextIndex[index]
            set MeleeLastIndex[MeleeNextIndex[index]] = MeleeLastIndex[index]
        endif
    elseif (tp == 1) then
        set index = MagicNextIndex[0]
        loop
             exitwhen (index == 0)
             exitwhen (MagicTriggerList[index] == t)
             set index = MagicNextIndex[index]
        endloop
        call DestroyTrigger(t)
        if (index > 0) then
            set MagicNextIndex[MagicLastIndex[index]] = MagicNextIndex[index]
            set MagicLastIndex[MagicNextIndex[index]] = MagicLastIndex[index]
        endif
    endif
endfunction

function AnyUnitDamagedRegisterCheck takes nothing returns boolean
    return (IsUnitInGroup(GetTriggerUnit(),DamagedGroup) == false) and (IsUnitType(GetFilterUnit(),UNIT_TYPE_SAPPER) == false)
endfunction

function AnyAOEDamagedEventRun takes nothing returns nothing
    local timer tm = GetExpiredTimer()
    local unit caster = LoadUnitHandle(DSHT,GetHandleId(tm),2)
    local unit target = LoadUnitHandle(DSHT,GetHandleId(tm),3)
    local real damage = LoadReal(DSHT,GetHandleId(tm),4)
    local integer index
    local trigger t
    if (GetUnitAbilityLevel(target,MIMETIC_BUFF_2) > 0) then
        call UnitRemoveAbility(target,MIMETIC_BUFF_2)
        set index = MeleeNextIndex[0]
        loop
            exitwhen (index == 0)
            exitwhen (index > MeleeListEnd)
            set t = MeleeTriggerList[index]
            if (IsTriggerEnabled(t)) then
                call SaveUnitHandle(DSHT,GetHandleId(t),3,target)
                call SaveUnitHandle(DSHT,GetHandleId(t),2,caster)
                call SaveReal(DSHT,GetHandleId(t),4,damage)
                if (TriggerEvaluate(t)) then
                    call TriggerExecute(t)
                endif
                set index = MeleeNextIndex[index]
            endif
        endloop
    else
        set index = MagicNextIndex[0]
        loop
            exitwhen (index == 0)
            exitwhen (index > MagicListEnd)
            set t = MagicTriggerList[index]
            if (IsTriggerEnabled(t)) then
                call SaveUnitHandle(DSHT,GetHandleId(t),3,target)
                call SaveUnitHandle(DSHT,GetHandleId(t),2,caster)
                call SaveReal(DSHT,GetHandleId(t),4,GetEventDamage())
                if (TriggerEvaluate(t)) then
                    call TriggerExecute(t)
                endif
                set index = MagicNextIndex[index]
            endif
        endloop
    endif
    call DestroyTimer(tm)    
    set tm = null
    set caster = null
    set target = null
    set t = null
endfunction

function AnyAOEDamagedEvent takes nothing returns nothing
    local timer tm = CreateTimer()
    call SaveUnitHandle(DSHT,GetHandleId(tm),2,GetEventDamageSource())
    call SaveUnitHandle(DSHT,GetHandleId(tm),3,GetTriggerUnit())
    call SaveReal(DSHT,GetHandleId(tm),4,GetEventDamage())
    call TimerStart(tm,0.0,false,function AnyAOEDamagedEventRun)
    set tm = null
endfunction

function AnySingleDamagedEvent takes nothing returns nothing
    local unit caster = GetEventDamageSource()
    local unit target = GetTriggerUnit()
    local integer index
    if ((GetUnitAbilityLevel(target,MIMETIC_BUFF_1) > 0)) then
        call UnitRemoveAbility(target,MIMETIC_BUFF_1)
        set index = MeleeNextIndex[0]
        loop
            exitwhen (index == 0)
            exitwhen (index > MeleeListEnd)
            if (IsTriggerEnabled(MeleeTriggerList[index])) and (TriggerEvaluate(MeleeTriggerList[index])) then
                call TriggerExecute(MeleeTriggerList[index])
            endif
            set index = MeleeNextIndex[index]
        endloop
    else
        set index = MagicNextIndex[0]
            loop
            exitwhen (index == 0)
            exitwhen (index > MagicListEnd)
            if (IsTriggerEnabled(MagicTriggerList[index])) and (TriggerEvaluate(MagicTriggerList[index])) then
                call TriggerExecute(MagicTriggerList[index])
            endif
            set index = MagicNextIndex[index]
        endloop
    endif
    set caster = null
    set target = null
endfunction

function AnyUnitDamagedEventFunc takes nothing returns nothing
    local unit caster = GetEventDamageSource()
    local unit target = GetTriggerUnit()
    if (GetTriggerEventId() == EVENT_UNIT_DAMAGED) then
        if (GetEventDamage() > 0) then
            if ((GetUnitAbilityLevel(caster,MIMETIC_SKILL_1) > 0)) then
                call AnySingleDamagedEvent()
            elseif ((GetUnitAbilityLevel(caster,MIMETIC_SKILL_2) > 0)) then
                call AnyAOEDamagedEvent()
            endif
        endif
    elseif (GetTriggerEventId() == EVENT_UNIT_DEATH) then
        if (IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == false) then
            call GroupRemoveUnit(DamagedGroup,GetTriggerUnit())
            call DestroyTrigger(GetTriggeringTrigger())
        endif
    endif
    set caster = null
    set target = null
endfunction

function AnyUnitDamagedEventRegister takes unit u returns nothing
    local trigger t = CreateTrigger()
    call GroupAddUnit(DamagedGroup,u)
    call TriggerRegisterUnitEvent(t,u,EVENT_UNIT_DAMAGED)
    call TriggerRegisterUnitEvent(t,u,EVENT_UNIT_DEATH)
    call TriggerAddAction(t,function AnyUnitDamagedEventFunc)
    set t = null
endfunction

function AnyUnitDamagedRegisterActionA takes nothing returns nothing
    local group g = CreateGroup()
    local unit pick
    call GroupEnumUnitsInRect(g,bj_mapInitialPlayableArea,null)
    loop
        set pick = FirstOfGroup(g)
        exitwhen (pick == null)
        call GroupRemoveUnit(g,pick)
        if (IsUnitInGroup(GetFilterUnit(),DamagedGroup) == false) and (IsUnitType(GetFilterUnit(),UNIT_TYPE_SAPPER) == false) then
            call AnyUnitDamagedEventRegister(pick)
        endif
    endloop
    call DestroyGroup(g)
    set g = null
    set pick = null
endfunction

function AnyUnitDamagedRegisterActionB takes nothing returns nothing
    if (IsUnitInGroup(GetTriggerUnit(),DamagedGroup) == false) and (IsUnitType(GetFilterUnit(),UNIT_TYPE_SAPPER) == false) then
        call AnyUnitDamagedEventRegister(GetTriggerUnit())
    endif
endfunction

function AnyUnit_Damaged_Event takes nothing returns nothing
    local region rectRegion = CreateRegion()
    local trigger tr1 = CreateTrigger()
    local trigger tr2 = CreateTrigger()
    call TriggerRegisterTimerEvent(tr1,0.0,false)
    call TriggerAddAction(tr1,function AnyUnitDamagedRegisterActionA)
    call RegionAddRect(rectRegion, bj_mapInitialPlayableArea)
    call TriggerRegisterEnterRegion(tr2, rectRegion, null)
    call TriggerAddAction(tr2, function AnyUnitDamagedRegisterActionB)
    set tr1 = null
    set tr2 = null
    set rectRegion = null
endfunction

function AnyUnitEnterRegionAddDataActionA takes nothing returns nothing
    local group g = CreateGroup()
    local unit pick
    call GroupEnumUnitsInRect(g,bj_mapInitialPlayableArea,null)
    loop
        set pick = FirstOfGroup(g)
        exitwhen (pick == null)
        call GroupRemoveUnit(g,pick)
        call SaveBoolean(DSHT,GetHandleId(pick),5,false)
        call InitIndex(S2I(I2S(10)+I2S(GetHandleId(pick))+I2S(1)))
        call SetReduceDamagePercent(GetUnitTypeId(pick),0.0)
        call SetReduceDamage(GetUnitTypeId(pick),0.0)
        call SetIncreaseDamagePercent(GetUnitTypeId(pick),0.0)
    endloop
    call DestroyGroup(g)
    set g = null
    set pick = null
endfunction

function AnyUnitEnterRegionAddDataActionB takes nothing returns nothing
    call SaveBoolean(DSHT,GetHandleId(GetTriggerUnit()),5,false)
    call InitIndex(S2I(I2S(10)+I2S(GetHandleId(GetTriggerUnit()))+I2S(1)))
    call SetReduceDamagePercent(GetUnitTypeId(GetTriggerUnit()),0.0)
    call SetReduceDamage(GetUnitTypeId(GetTriggerUnit()),0.0)
    call SetIncreaseDamagePercent(GetUnitTypeId(GetTriggerUnit()),0.0)
endfunction

function AnyUnitEnterRegionAddData takes nothing returns nothing
    local region rectRegion = CreateRegion()
    local trigger tr1 = CreateTrigger()
    local trigger tr2 = CreateTrigger()
    call TriggerRegisterTimerEvent(tr1,0.01,false)
    call TriggerAddAction(tr1,function AnyUnitEnterRegionAddDataActionA)
    call RegionAddRect(rectRegion, bj_mapInitialPlayableArea)
    call TriggerRegisterEnterRegion(tr2, rectRegion, null)
    call TriggerAddAction(tr2, function AnyUnitEnterRegionAddDataActionB)
    set tr1 = null
    set tr2 = null
    set rectRegion = null
endfunction

function Melee_Damage_Event_Actions takes nothing returns nothing
    call MimeticdMeleeDamage(GetEventDamageSourceZJ(),GetEventDamagedUnitZJ())
    call SaveReal(DSHT,GetHandleId(GetEventDamagedUnitZJ()),6,0.0)
endfunction

function Melee_Damage_Event takes nothing returns nothing
    local trigger Melee_Damage = CreateTrigger()
    call TriggerRegisterAnyUnitDamagedEvent(Melee_Damage,0)//第2参数为0表示注册单位受普通攻击伤害事件
    call TriggerAddAction(Melee_Damage, function Melee_Damage_Event_Actions)
    set Melee_Damage = null
endfunction

function TimerRun_Func001 takes nothing returns nothing
    call UnitRemoveAbility( LoadUnitHandle(DSHT,GetHandleId(GetExpiredTimer()),7), ImmuneDamageID )
    call FlushChildHashtable(DSHT,GetHandleId(GetExpiredTimer()))
    call DestroyTimer(GetExpiredTimer())
endfunction

function Magic_Damage_Event_Actions takes nothing returns nothing
    local boolean B = LoadBoolean(DSHT,GetHandleId(GetEventDamagedUnitZJ()),5)
    local boolean B0 = UnitImmuneConditions(GetEventDamagedUnitZJ(),46)
    local boolean b1 = UnitReboundConditions(GetEventDamagedUnitZJ(),46)
    local boolean b2 = UnitAbsorptionConditions(GetEventDamagedUnitZJ(),46)        
    local timer t
    local real a = LoadReal(DSHT, GetHandleId(GetEventDamagedUnitZJ()), 94)
    local real b = LoadReal(DSHT, GetHandleId(GetEventDamagedUnitZJ()), 96)
    local real c = LoadReal(DSHT, GetHandleId(GetEventDamageSourceZJ()), 84) + LoadReal(DSHT, GetHandleId(GetEventDamageSourceZJ()), 92)
    if (a >= 1.0) then
        set a = 1.0
    elseif (a <= 0.0) then
        set a = 0.0
    endif
    if ( b <= 0.0 ) then
        set b = 0.0
    endif
    if ( c >= 1.0 ) then 
        set c = 1.0
    elseif ( c <= 0.0 ) then 
        set c = 0.0
    endif       
    if ((B0 == false) and (GetEventDamageZJ() != 0.01)) then
        if (B == false) then
            if (( UnitTypeConditions_A(GetEventDamagedUnitZJ()) == false )) then
                call SetUnitState( GetEventDamageSourceZJ(), UNIT_STATE_LIFE, (GetUnitState(GetEventDamageSourceZJ(), UNIT_STATE_LIFE) + GetEventDamageZJ() * c) )
            endif
            if ((a != 0.0) and (b1 == true))  then
                call MimeticdDamage(GetEventDamagedUnitZJ(),GetEventDamageSourceZJ(),a * GetEventDamageZJ())
                if (DisplayDamageBool == true) then
                    call DisplayDamage(GetEventDamageSourceZJ(),GetUnitMimeticdDamage(GetEventDamageSourceZJ()),20.0,11.0,rgb_R[6],rgb_G[6],rgb_B[6],rgb_A[6])
                endif
            endif
            if ((b != 0.0) and (b2 == true))  then
                call SetUnitState( GetEventDamagedUnitZJ(), UNIT_STATE_LIFE, (GetUnitState(GetEventDamagedUnitZJ(), UNIT_STATE_LIFE) + b * GetEventDamageZJ()) )
                if (DisplayDamageBool == true) then
                    call DisplayDamage(GetEventDamagedUnitZJ(),b*GetEventDamageZJ(),20.0,11.0,rgb_R[5],rgb_G[5],rgb_B[5],rgb_A[5])
                endif
            endif
            call SaveReal(DSHT,GetHandleId(GetEventDamagedUnitZJ()),6,GetEventDamageZJ())
            if ((IsUnitType(GetEventDamagedUnitZJ(), UNIT_TYPE_HERO) == true)) then
                if (DisplayDamageBool == true) then
                   call DisplayDamage(GetEventDamagedUnitZJ(),GetEventDamageZJ(),20.0,11.0,rgb_R[3],rgb_G[3],rgb_B[3],rgb_A[3])
                endif
            elseif ((IsUnitType(GetEventDamagedUnitZJ(), UNIT_TYPE_HERO) == false)) then
                if (DisplayDamageBool == true) then
                   call DisplayDamage(GetEventDamagedUnitZJ(),GetEventDamageZJ(),20.0,11.0,rgb_R[4],rgb_G[4],rgb_B[4],rgb_A[4])
                endif
            endif  
        endif   
    elseif (B0 == true) then
        call SaveReal(DSHT,GetHandleId(GetEventDamagedUnitZJ()),50,GetEventDamageZJ())
        set t = CreateTimer()
        call UnitAddAbility( GetEventDamagedUnitZJ(), ImmuneDamageID )
        call SaveUnitHandle(DSHT,GetHandleId(t),7,GetEventDamagedUnitZJ())
        call TimerStart(t,0.0, false, function TimerRun_Func001)
        set t = null
        if ((IsUnitType(GetEventDamagedUnitZJ(), UNIT_TYPE_HERO) == true) and (GetEventDamageZJ() != 0.01)) then
            if (DisplayDamageBool == true) then
                call DisplayDamage(GetEventDamagedUnitZJ(),0.0,20.0,11.0,128,128,255,0.0)
            endif
        elseif ((IsUnitType(GetEventDamagedUnitZJ(), UNIT_TYPE_HERO) == false) and (GetEventDamageZJ() != 0.01)) then
            if (DisplayDamageBool == true) then
               call DisplayDamage(GetEventDamagedUnitZJ(),0.0,20.0,11.0,163,70,255,0.0)
            endif
        endif  
    endif       
    call SaveReal(DSHT,GetHandleId(GetEventDamagedUnitZJ()),6,0.0)
endfunction

function Magic_Damage_Event takes nothing returns nothing
    local trigger Magic_Damage = CreateTrigger()
    call TriggerRegisterAnyUnitDamagedEvent(Magic_Damage,1)//第2参数为1表示注册单位受非普通攻击伤害事件
    call TriggerAddAction(Magic_Damage, function Magic_Damage_Event_Actions)
    set Magic_Damage = null
endfunction

function Unit_Death_Run takes nothing returns nothing
    call FlushChildHashtable(DSHT,GetHandleId(LoadUnitHandle(DSHT,GetHandleId(GetExpiredTimer()),7)))
    call FlushChildHashtable(DSHT,GetHandleId(GetExpiredTimer()))
    call DestroyTimer(GetExpiredTimer())
endfunction

function Unit_Death_Event_Actions takes nothing returns nothing
    local timer tm = CreateTimer()
    call FlushChildHashtable(DSHT,GetHandleId(GetTriggerUnit()))
    call SaveUnitHandle(DSHT,GetHandleId(tm),7,GetTriggerUnit())
    call TimerStart(tm,2.0,false,function Unit_Death_Run)
    set tm = null
endfunction

function Unit_Death_Event takes nothing returns nothing
    local trigger Unit_Death = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(Unit_Death, EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(Unit_Death, function Unit_Death_Event_Actions)
    set Unit_Death = null
endfunction

function PackageMimeticdSkillDispose takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen( i > 15 )
        call SetPlayerAbilityAvailable( Player(i), MIMETIC_SKILL_0, false )
        set i = i + 1
    endloop
endfunction

function UNIT_PICKUP_ITEM_Actions takes nothing returns nothing
    local unit u = null
    local integer i = 0
    local integer n = 0
    local integer k = 1
    local integer UnitHandleId = S2I(I2S(10)+I2S(GetHandleId(GetTriggerUnit()))+I2S(1))
    local boolean b = false
    local boolean b0 = false
    if (GetUnitTypeId(GetTriggerUnit()) != ITEM_SLOT_UNIT_TYPE) and (GetItemTypeId(GetManipulatedItem()) != 'stpg') then
        set i = 1
        loop
            exitwhen i > GetMaxIndex(UnitHandleId)
            if ((LoadInteger(DSITHT, GetHandleId(GetTriggerUnit()), i) == GetHandleId(GetManipulatedItem()))) then
                set b = true
                exitwhen true
            else
                set b = false
            endif
            set i = i + 1
        endloop
        if (b == false) then  
            set n = 1
            loop
                exitwhen n > GetMaxIndex(UnitHandleId)
                if (GetItemTypeName((GetItemTypeId(LoadItemHandle(DSITHT, LoadInteger(DSITHT,GetHandleId(GetTriggerUnit()),n),0x100001)))) == GetItemTypeName(GetItemTypeId(GetManipulatedItem()))) then
                    if (GetItemTypeNumberMax(GetItemTypeName(GetItemTypeId(GetManipulatedItem()))) > 0) then
                        set k = k + 1
                        if (k > GetItemTypeNumberMax(GetItemTypeName(GetItemTypeId(GetManipulatedItem())))) then
                            call UnitRemoveItem(GetTriggerUnit(),GetManipulatedItem())
                            call DestroyIndex( UnitHandleId, i )
                            call FlushChildHashtable(DSITHT,GetHandleId(GetManipulatedItem()))
                            call DisplayTextToPlayer( GetOwningPlayer(GetTriggerUnit()),0,0,str1)
                            set b0 = true
                            exitwhen true
                        else
                            set b0 = false
                        endif
                    endif
                else
                    set b0 = false
                endif
                set n = n + 1
            endloop 
            if (b0 == false) then      
                call SaveInteger(DSITHT, GetHandleId(GetTriggerUnit()), CreateIndex(UnitHandleId), GetHandleId(GetManipulatedItem()) )
                call SaveItemHandle(DSITHT, GetHandleId(GetManipulatedItem()),0x100001, GetManipulatedItem() )
                if ((GetItemCharges(GetManipulatedItem()) >= 1)) then
                    call SaveBoolean(DSITHT, GetItemTypeId(GetManipulatedItem()),0, true )
                else
                    call SaveBoolean(DSITHT, GetItemTypeId(GetManipulatedItem()),0, false )
                endif
            endif
        endif
    else
        set u = LoadUnitHandle(DSITHT,GetHandleId(GetManipulatedItem()),0x100002)
        call SaveInteger(DSITHT, GetHandleId(u), CreateIndex(S2I(I2S(10)+I2S(GetHandleId(u))+I2S(1))), GetHandleId(GetManipulatedItem()) )
        call SaveItemHandle(DSITHT, GetHandleId(GetManipulatedItem()),0x100001, GetManipulatedItem() )
        if ((GetItemCharges(GetManipulatedItem()) >= 1)) then
            call SaveBoolean(DSITHT, GetItemTypeId(GetManipulatedItem()),0, true )
        else
            call SaveBoolean(DSITHT, GetItemTypeId(GetManipulatedItem()),0, false )
        endif
    endif
    call UnitItemPredicable(GetTriggerUnit())
    set u = null
endfunction

function UNIT_PICKUP_ITEM takes nothing returns nothing
    local trigger tr
    set tr = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( tr, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddAction(tr, function UNIT_PICKUP_ITEM_Actions)
    set tr = null
endfunction

function UNIT_USE_ITEM_Actions takes nothing returns nothing
    local integer i
    local integer UnitHandleId = S2I(I2S(10)+I2S(GetHandleId(GetTriggerUnit()))+I2S(1))
    if ((LoadBoolean(DSITHT, GetItemTypeId(GetManipulatedItem()), 0) == true) and (GetItemCharges(GetManipulatedItem()) == 0)) then
        set i = 1
        loop
            exitwhen i > GetMaxIndex(UnitHandleId)
            if ((LoadInteger(DSITHT, GetHandleId(GetTriggerUnit()), i) == GetHandleId(GetManipulatedItem()))) then
                call SaveInteger(DSITHT, GetHandleId(GetTriggerUnit()), i, 0 )
                call DestroyIndex( UnitHandleId, i )
                call FlushChildHashtable(DSITHT,GetHandleId(GetManipulatedItem()))
            endif
            set i = i + 1
        endloop
    endif
    call UnitItemPredicable(GetTriggerUnit())   
endfunction

function UNIT_USE_ITEM takes nothing returns nothing
    local trigger tr
    set tr = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(tr, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddAction(tr, function UNIT_USE_ITEM_Actions)
    set tr = null
endfunction

function UNIT_DROP_ITEM_Actions takes nothing returns nothing
    local integer i
    local integer UnitHandleId = S2I(I2S(10)+I2S(GetHandleId(GetTriggerUnit()))+I2S(1))
    set i = 1
    loop
        exitwhen i > GetMaxIndex(UnitHandleId)
        if ((LoadInteger(DSITHT, GetHandleId(GetTriggerUnit()), i) == GetHandleId(GetManipulatedItem()))) then
            call SaveInteger(DSITHT, GetHandleId(GetTriggerUnit()), i, 0 )
            call DestroyIndex( UnitHandleId, i )
            if (GetUnitTypeId(GetTriggerUnit()) != ITEM_SLOT_UNIT_TYPE) and (GetItemTypeId(GetManipulatedItem()) != 'stpg') then
                call SaveUnitHandle(DSITHT,GetHandleId(GetManipulatedItem()),0x100002,GetTriggerUnit())
            endif
        endif
        set i = i + 1
    endloop
    call UnitItemPredicable(GetTriggerUnit())   
endfunction

function UNIT_DROP_ITEM takes nothing returns nothing
    local trigger tr
    set tr = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(tr, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddAction(tr, function UNIT_DROP_ITEM_Actions)
    set tr = null
endfunction

function UNIT_SELL_ITEM_Actions takes nothing returns nothing
    local integer i
    local integer UnitHandleId = S2I(I2S(10)+I2S(GetHandleId(GetTriggerUnit()))+I2S(1))
    set i = 1
    loop
        exitwhen i > GetMaxIndex(UnitHandleId)
        if ((LoadInteger(DSITHT, GetHandleId(GetTriggerUnit()), i) == GetHandleId(GetManipulatedItem()))) then
            call SaveInteger(DSITHT, GetHandleId(GetTriggerUnit()), i, 0 )
            call DestroyIndex( UnitHandleId, i )
            call FlushChildHashtable(DSITHT,GetHandleId(GetManipulatedItem()))
        endif
        set i = i + 1
    endloop
    call UnitItemPredicable(GetTriggerUnit())   
endfunction

function UNIT_SELL_ITEM takes nothing returns nothing
    local trigger tr
    set tr = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(tr, EVENT_PLAYER_UNIT_SELL_ITEM )
    call TriggerRegisterAnyUnitEventBJ(tr, EVENT_PLAYER_UNIT_PAWN_ITEM )
    call TriggerAddAction(tr, function UNIT_DROP_ITEM_Actions)
    set tr = null
endfunction

function HERO_LEVELActions takes nothing returns nothing
    local integer unitid = GetUnitTypeId(GetTriggerUnit())
    local real a = LoadReal(DSHT,unitid,42)
    local real b = LoadReal(DSHT,unitid,43)
    local real c = LoadReal(DSHT,unitid,44)
    local real d = LoadReal(DSHT,unitid,45)
    call SaveReal(DSHT,GetHandleId(GetTriggerUnit()),42,LoadReal(DSHT,GetHandleId(GetTriggerUnit()),42) + a )
    call SaveReal(DSHT,GetHandleId(GetTriggerUnit()),43,LoadReal(DSHT,GetHandleId(GetTriggerUnit()),43) + b )
    call SaveReal(DSHT,GetHandleId(GetTriggerUnit()),44,LoadReal(DSHT,GetHandleId(GetTriggerUnit()),44) + c )
    call SaveReal(DSHT,GetHandleId(GetTriggerUnit()),45,LoadReal(DSHT,GetHandleId(GetTriggerUnit()),45) + d )
endfunction

function HeroLevelUpTrigger takes nothing returns nothing
    local trigger tr
    set tr = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(tr, EVENT_PLAYER_HERO_LEVEL)
    call TriggerAddAction(tr, function HERO_LEVELActions)
    set tr = null
endfunction

function HeroLevelUp takes integer unitid,real a,real b,real c,real d returns nothing
    call SaveReal(DSHT,unitid,42,a)
    call SaveReal(DSHT,unitid,43,b)
    call SaveReal(DSHT,unitid,44,c)
    call SaveReal(DSHT,unitid,45,d)
endfunction

function SetDisplayDamage takes boolean b returns nothing
    set DisplayDamageBool = b
endfunction

function SetItemSlotUnitType takes integer unitid returns nothing
    set ITEM_SLOT_UNIT_TYPE = unitid
endfunction

function ImmuneDamageAbilityID takes integer id returns nothing
    set ImmuneDamageID = id
endfunction

function DamageSystemInitialization takes integer MimeticSkill0, integer MimeticSkill1, integer MimeticSkill2, integer MimeticBuff1, integer MimeticBuff2 returns nothing
    set DSHT = InitHashtable()
    set DamagedGroup = CreateGroup()
    set RANDOM_Factor = 1.5
    set MIMETIC_SKILL_0 = MimeticSkill0    //捕获单体普攻技能的封装技能//
    set MIMETIC_SKILL_1 = MimeticSkill1    //捕获单体普攻技能//
    set MIMETIC_SKILL_2 = MimeticSkill2    //捕获群体普攻技能//
    set MIMETIC_BUFF_1 = MimeticBuff1      //捕获单体普攻buff//
    set MIMETIC_BUFF_2 = MimeticBuff2      //捕获群体普攻buff//
    set MagicListEnd = 0
    set MeleeListEnd = 0
    call AnyUnit_Damaged_Event()
    call PackageMimeticdSkillDispose() 
    call Unit_Death_Event() 
    call EXPSet()
endfunction    

function SetSystemStringColor takes nothing returns nothing
    local integer i = 1
    call SetDisplayDamageColor(1,0.0,255,0,0)
    call SetDisplayDamageColor(2,0.0,228,61,12) 
    call SetDisplayDamageColor(3,0.0,128,128,255)   
    call SetDisplayDamageColor(4,0.0,163,70,255) 
    call SetDisplayDamageColor(5,0.0,0,255,0)
    call SetDisplayDamageColor(6,0.0,0,255,255)
    call SetDisplayPredicableColor(0,255,253,168,91)
    call SetDisplayPredicableColor(20,255,255,87,0)
    call SetDisplayPredicableColor(42,255,128,0,255)
    loop
        exitwhen i > 51
        if ((i != 20) and (i != 42)) then
            call SetDisplayPredicableColor(i,255,0,255,0)
        endif
        set i = i + 1
    endloop
    call SetDisplayPredicableColor(100,255,0,255,255)
endfunction

function OpenDamageEventPreinstall takes nothing returns nothing
    call SetDisplayDamageColor(1,0.0,255,0,0)
    call SetDisplayDamageColor(2,0.0,228,61,12) 
    call SetDisplayDamageColor(3,0.0,128,128,255)   
    call SetDisplayDamageColor(4,0.0,163,70,255) 
    call SetDisplayDamageColor(5,0.0,0,255,0)
    call SetDisplayDamageColor(6,0.0,0,255,255)
    call Melee_Damage_Event()
    call Magic_Damage_Event()
endfunction

function OpenSystemPreinstallDATA takes nothing returns nothing
    // 系统基本数据初始化
    local integer i = 0
    call FlushParentHashtable(DSHT)
    call FlushParentHashtable(DSITHT)   
    set DSHT = InitHashtable()
    set DSITHT = InitHashtable()    
    call SetType_System()
    call SetTypeNamePreinstall()
    call AttackDefensePreinstallDATA()
    call AnyUnitEnterRegionAddData()    
    call UNIT_PICKUP_ITEM()
    call UNIT_USE_ITEM()
    call UNIT_DROP_ITEM()
    call UNIT_SELL_ITEM()       
    call HeroLevelUpTrigger()
    call SetItemTypeNumberMax("null",0)
    set str1 = "|cFFFF0000同|r|cFFFF1300类|r|cFFFF2500物|r|cFFFF3800品|r|cFFFF4A00携|r|cFFFF5D00带|r|cFFFF6F00数|r|cFFFF8200超|r|cFFFF9400过|r|cFFFFA700上|r|cFFFFB900限|r|cFFFFCC00！|r"
    loop
        exitwhen i > 51
        call SetDisplayPredicableColor(i,255,255,255,255)
        set i = i + 1
    endloop
    call SetDisplayPredicableColor(100,255,255,255,255)
endfunction

function DialogButtonA takes nothing returns nothing
    local integer PlayerIndex
    set PlayerIndex = GetPlayerId(GetTriggerPlayer())
    call EnableTrigger(trA[PlayerIndex])
endfunction

function DialogButtonB takes nothing returns nothing
    local integer PlayerIndex
    set PlayerIndex = GetPlayerId(GetTriggerPlayer())
    call EnableTrigger(trB[PlayerIndex])
endfunction

function DialogButtonC takes nothing returns nothing
    local integer PlayerIndex
    set PlayerIndex = GetPlayerId(GetTriggerPlayer())
    call EnableTrigger(trC[PlayerIndex])
endfunction

function DisplayUnitPredicableBuyButton takes boolean b, player whichplayer, unit whichunit returns nothing
    local integer PlayerIndex
    local integer whichunitID
    local real Thump
    local real ThumpMultiple
    local real AttackValue
    local real DefenseValue
    local real SkillThump
    local real SkillThumpMultiple
    local real SkillDamage
    local real SkillDefenseValue
    local real SkillDodge
    if ( b == true ) then
        set whichunitID = GetUnitTypeId(whichunit)
    else
        set whichunitID = GetHandleId(whichunit)
    endif
    call UnitItemPredicable(whichunit)        
    set Thump = LoadReal(DSHT, whichunitID, 17) + LoadReal(DSHT, GetHandleId(whichunit), 30) + LoadReal(DSHT,GetHandleId(whichunit),62)
    if Thump <= 0.0 then
       set Thump = 0.0
    endif
    set ThumpMultiple = LoadReal(DSHT, whichunitID, 18) + LoadReal(DSHT, GetHandleId(whichunit), 31) + LoadReal(DSHT,GetHandleId(whichunit),63)
    if ThumpMultiple <= 1.0 then
       set ThumpMultiple = 1.0
    endif
    set AttackValue = LoadReal(DSHT, whichunitID, GetType(whichunitID,11)) + LoadReal(DSHT, GetHandleId(whichunit), 27) + LoadReal(DSHT,GetHandleId(whichunit),42) + LoadReal(DSHT,GetHandleId(whichunit),58)
    set DefenseValue = LoadReal(DSHT, whichunitID, GetType(whichunitID,12)) + LoadReal(DSHT, GetHandleId(whichunit), 28) + LoadReal(DSHT,GetHandleId(whichunit),43) + LoadReal(DSHT,GetHandleId(whichunit),59)
    set SkillThump = LoadReal(DSHT, whichunitID, 20) + LoadReal(DSHT, GetHandleId(whichunit), 33) + LoadReal(DSHT,GetHandleId(whichunit),64)
    if SkillThump <= 0.0 then
       set SkillThump = 0.0
    endif   
    set SkillThumpMultiple = LoadReal(DSHT, whichunitID, 21) + LoadReal(DSHT, GetHandleId(whichunit), 34) + LoadReal(DSHT,GetHandleId(whichunit),65)
    if SkillThumpMultiple <= 1.0 then
       set SkillThumpMultiple = 1.0
    endif   
    set SkillDamage = LoadReal(DSHT,GetHandleId(whichunit),44) + LoadReal(DSHT,whichunitID,53) + LoadReal(DSHT,GetHandleId(whichunit),60)
    set SkillDefenseValue = LoadReal(DSHT, whichunitID, GetType(whichunitID,14)) + LoadReal(DSHT, GetHandleId(whichunit), 29) + LoadReal(DSHT,GetHandleId(whichunit),45) + LoadReal(DSHT,GetHandleId(whichunit),61)
    set SkillDodge = LoadReal(DSHT, whichunitID, 19) + LoadReal(DSHT, GetHandleId(whichunit), 32) + LoadReal(DSHT,GetHandleId(whichunit),66)
    if ( Thump >= 100.0 ) then
        set Thump = 100.0
    endif
    if ( SkillThump >= 100.0 ) then
        set SkillThump = 100.0
    endif
    if ( SkillDodge >= 100.0 ) then
        set SkillDodge = 100.0
    endif
    set PlayerIndex = GetPlayerId(whichplayer)
    call DialogClear(DialogB[PlayerIndex])
    call DialogAddButton(DialogB[PlayerIndex],"|cFFFFFF00"+"单位名字:"+"|r"+color_str[0]+GetUnitName(whichunit)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[2]+"攻击:"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,11))+":"+R2S(AttackValue)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[4]+"防御:"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,12))+":"+R2S(DefenseValue)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[47]+"技能伤害附加:"+"|r"+color_str[100]+R2S(SkillDamage)+"|r",0)  
    call DialogAddButton(DialogB[PlayerIndex],color_str[6]+"技能防御:"+"|r"+color_str[100]+TypeId2S(GetType(whichunitID,14))+":"+R2S(SkillDefenseValue)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[8]+TypeId2S(17)+"(百分比):"+"|r"+color_str[100]+R2S(Thump)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[9]+TypeId2S(18)+":"+"|r"+color_str[100]+R2S(ThumpMultiple)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[10]+TypeId2S(19)+"(百分比):"+"|r"+color_str[100]+R2S(SkillDodge)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[11]+TypeId2S(20)+"(百分比):"+"|r"+color_str[100]+R2S(SkillThump)+"|r",0)
    call DialogAddButton(DialogB[PlayerIndex],color_str[12]+TypeId2S(21)+":"+"|r"+color_str[100]+R2S(SkillThumpMultiple)+"|r",0)
    call DialogDisplay(whichplayer,DialogB[PlayerIndex],true)
    call DisableTrigger(trA[PlayerIndex])
endfunction

function DisplayUnitSpecialPredicableBuyButton takes boolean B, player whichplayer, unit whichunit returns nothing
    local integer PlayerIndex
    local integer whichunitID
    local real a = 0.0
    local real b = 0.0
    local real c = 0.0
    local real d = 0.0  
    local real e = 0.0  
    local real f = 0.0  
    local real g = 0.0  
    local real h = 0.0      
    local real I = 0.0
    local real R1 = 0.0
    local real R2 = 0.0
    if ( B == true ) then
        set whichunitID = GetUnitTypeId(whichunit)
    else
        set whichunitID = GetHandleId(whichunit)
    endif
    call UnitItemPredicable(whichunit)        
    set a = LoadReal(DSHT, whichunitID, 54) + LoadReal(DSHT, GetHandleId(whichunit), 69) + LoadReal(DSHT, GetHandleId(whichunit), 77)
    set b = LoadReal(DSHT, whichunitID, 55) + LoadReal(DSHT, GetHandleId(whichunit), 70) + LoadReal(DSHT, GetHandleId(whichunit), 78)
    set c = LoadReal(DSHT, whichunitID, 56) + LoadReal(DSHT, GetHandleId(whichunit), 71) + LoadReal(DSHT, GetHandleId(whichunit), 79)
    set d = LoadReal(DSHT, whichunitID, 57) + LoadReal(DSHT, GetHandleId(whichunit), 72) + LoadReal(DSHT, GetHandleId(whichunit), 80)
    set e = LoadReal(DSHT, GetHandleId(whichunit), 81) + LoadReal(DSHT, GetHandleId(whichunit), 89)
    if ( e >= 1.0 ) then 
        set e = 1.0
    elseif ( e <= 0.0 ) then 
        set e = 0.0
    endif           
    set f = LoadReal(DSHT, GetHandleId(whichunit), 82) + LoadReal(DSHT, GetHandleId(whichunit), 90)
    if ( f >= 1.0 ) then 
        set f = 1.0
    elseif ( f <= 0.0 ) then 
        set f = 0.0
    endif   
    set g = LoadReal(DSHT, GetHandleId(whichunit), 83) + LoadReal(DSHT, GetHandleId(whichunit), 91)
    if ( g >= 1.0 ) then 
        set g = 1.0
    elseif ( g <= 0.0 ) then 
        set g = 0.0
    endif           
    set h = LoadReal(DSHT, GetHandleId(whichunit), 84) + LoadReal(DSHT, GetHandleId(whichunit), 92)
    if ( h >= 1.0 ) then 
        set h = 1.0
    elseif ( h <= 0.0 ) then 
        set h = 0.0
    endif                   
    set I = LoadReal(DSHT, GetHandleId(whichunit), 23) + LoadReal(DSHT, GetHandleId(whichunit), 39) 
    set R1 = LoadReal(DSHT, GetHandleId(whichunit), 22) + LoadReal(DSHT, GetHandleId(whichunit), 37) 
    set R2 = LoadReal(DSHT, GetHandleId(whichunit), 24) + LoadReal(DSHT, GetHandleId(whichunit), 38) 
    if ( I <= 0.0 ) then
        set I = 1.0
    endif
    if ( R1 <= 0.0 ) then
        set R1 = 0.0
    elseif ( R1 >= 1.0 ) then
        set R1 = 1.0
    endif
    set PlayerIndex = GetPlayerId(whichplayer)
    call DialogClear(DialogF[PlayerIndex])
    call DialogAddButton(DialogF[PlayerIndex],"|cFFFFFF00"+"单位名字:"+"|r"+color_str[0]+GetUnitName(whichunit)+"|r",0)   
    call DialogAddButton(DialogF[PlayerIndex],color_str[13]+TypeId2S(54)+":"+"|r"+color_str[100]+R2S(a)+"|r",0)
    call DialogAddButton(DialogF[PlayerIndex],color_str[14]+TypeId2S(55)+":"+"|r"+color_str[100]+R2S(b)+"|r",0)
    call DialogAddButton(DialogF[PlayerIndex],color_str[15]+TypeId2S(56)+"(百分比):"+"|r"+color_str[100]+R2S(c)+"|r",0)
    call DialogAddButton(DialogF[PlayerIndex],color_str[16]+TypeId2S(57)+"(百分比):"+"|r"+color_str[100]+R2S(d)+"|r",0)
    call DialogAddButton(DialogF[PlayerIndex],color_str[48]+"透甲率:"+"|r"+color_str[100]+R2S(e)+"|r",0) 
    call DialogAddButton(DialogF[PlayerIndex],color_str[49]+"技能透甲率:"+"|r"+color_str[100]+R2S(f)+"|r",0) 
    call DialogAddButton(DialogF[PlayerIndex],color_str[50]+"吸血率:"+"|r"+color_str[100]+R2S(g)+"|r",0) 
    call DialogAddButton(DialogF[PlayerIndex],color_str[51]+"技能吸血率:"+"|r"+color_str[100]+R2S(h)+"|r",0)         
    call DialogAddButton(DialogF[PlayerIndex],color_str[17]+TypeId2S(22)+":"+"|r"+color_str[100]+R2S(R1)+"|r",0)
    call DialogAddButton(DialogF[PlayerIndex],color_str[18]+TypeId2S(23)+":"+"|r"+color_str[100]+R2S(I)+"|r",0)
    call DialogAddButton(DialogF[PlayerIndex],color_str[19]+TypeId2S(24)+":"+"|r"+color_str[100]+R2S(R2)+"|r",0)
    call DialogDisplay(whichplayer,DialogF[PlayerIndex],true)
    call DisableTrigger(trB[PlayerIndex])
endfunction

function DisplayItemPredicable takes nothing returns nothing
    local integer itemid
    local integer index
    local integer PlayerIndex
    set PlayerIndex = GetPlayerId(GetTriggerPlayer())
    set index = LoadInteger(DSHT,StringHash("玩家"+I2S(PlayerIndex)+"选择的单位物品栏序号"),0)
    set itemid = GetItemTypeId(LoadItemHandle(DSHT,StringHash("玩家"+I2S(PlayerIndex)+"选择的单位的物品"),index))
    call DialogClear(DialogD[PlayerIndex])
    call DialogAddButton(DialogD[PlayerIndex],"|cFFFFFF00"+"物品名字:"+"|r"+color_str[20]+GetObjectName(itemid)+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[21]+"物品攻击值加成:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 11))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[22]+"物品防御值加成:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 12))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[23]+"物品技能防御值加成:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 14))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[24]+"物品——单位暴击概率(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 17))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[25]+"物品——单位暴击倍数:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 18)),0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[26]+"物品——单位技能闪避力(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 19))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[27]+"物品——技能暴击概率(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 20))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[28]+"物品——技能暴击倍数:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 21))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[29]+TypeId2S(25)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 25))+"|r",0)
    call DialogAddButton(DialogD[PlayerIndex],color_str[30]+TypeId2S(26)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 26))+"|r",0)
    call DialogDisplay(GetTriggerPlayer(),DialogD[PlayerIndex],true)
    call DisableTrigger(trC[PlayerIndex])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function DisplayItemSpecialPredicable takes nothing returns nothing
    local integer itemid
    local integer index
    local integer PlayerIndex
    set PlayerIndex = GetPlayerId(GetTriggerPlayer())
    set index = LoadInteger(DSHT,StringHash("玩家"+I2S(PlayerIndex)+"选择的单位物品栏序号"),0)
    set itemid = GetItemTypeId(LoadItemHandle(DSHT,StringHash("玩家"+I2S(PlayerIndex)+"选择的单位的物品"),index))
    call DialogClear(DialogE[PlayerIndex])
    call DialogAddButton(DialogE[PlayerIndex],"|cFFFFFF00"+"物品名字:"+"|r"+color_str[20]+GetObjectName(itemid)+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[31]+TypeId2S(73)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 73))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[32]+TypeId2S(74)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 74))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[33]+TypeId2S(75)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 75))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[34]+TypeId2S(76)+"(百分比):"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 76))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[35]+TypeId2S(85)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 85))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[36]+TypeId2S(86)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 86))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[37]+TypeId2S(87)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 87))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[38]+TypeId2S(88)+":"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 88))+"|r",0)        
    call DialogAddButton(DialogE[PlayerIndex],color_str[39]+"物品——单位减伤（百分比）:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 22))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[40]+"物品——单位增伤（百分比）:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 23))+"|r",0)
    call DialogAddButton(DialogE[PlayerIndex],color_str[41]+"物品——单位伤害修改（数值）:"+"|r"+color_str[100]+R2S(LoadReal(DSHT, itemid, 24))+"|r",0)  
    call DialogDisplay(GetTriggerPlayer(),DialogE[PlayerIndex],true)
    call DisableTrigger(trC[PlayerIndex])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function PlayerUnitSelectedSetButtonA takes nothing returns nothing
    call DisplayUnitPredicableBuyButton(true,GetTriggerPlayer(),GetTriggerUnit())
endfunction

function PlayerUnitSelectedSetButtonB takes nothing returns nothing
    call DisplayUnitSpecialPredicableBuyButton(true,GetTriggerPlayer(),GetTriggerUnit())
endfunction

function PlayerUnitSelectedSetButtonC takes nothing returns nothing
    local integer i
    local integer PlayerIndex
    local boolean array b
    local trigger tr
    local trigger tr0   
    set PlayerIndex = GetPlayerId(GetTriggerPlayer())
    call DialogClear(DialogC[PlayerIndex])
    set i = 0
    loop
        exitwhen i > 5
        set b[i] = false
        if (UnitItemInSlot(GetTriggerUnit(),i) != null) then
            set b[i] = true
        endif
        set i = i + 1
    endloop
    if (b[0] or b[1] or b[2] or b[3] or b[4] or b[5]) then
        set tr = CreateTrigger()  
        set tr0 = CreateTrigger()       
        set i = 0
        loop
            exitwhen i > 5
            if (UnitItemInSlot(GetTriggerUnit(),i) != null) then
                call SaveInteger(DSHT,StringHash("玩家"+I2S(PlayerIndex)+"选择的单位物品栏序号"),0,i)
                call SaveItemHandle(DSHT,StringHash("玩家"+I2S(PlayerIndex)+"选择的单位的物品"),i,UnitItemInSlot(GetTriggerUnit(),i))
                call TriggerRegisterDialogButtonEvent(tr,DialogAddButton(DialogC[PlayerIndex],"物品栏第"+I2S(i+1)+"格物品属性",0))
                call TriggerRegisterDialogButtonEvent(tr0,DialogAddButton(DialogC[PlayerIndex],"物品栏第"+I2S(i+1)+"格物品特殊属性",0))                
                call TriggerAddAction(tr,function DisplayItemPredicable)
                call TriggerAddAction(tr0,function DisplayItemSpecialPredicable)                
                call DialogDisplay(GetTriggerPlayer(),DialogC[PlayerIndex],true)                
            endif
            set i = i + 1
        endloop
    endif
    call DisableTrigger(GetTriggeringTrigger())
    set tr = null
    set tr0 = null  
endfunction

function OpenDisplayDialog takes boolean b returns nothing
    if ( b == false ) then
        call DisableTrigger(trig)
    else
        call EnableTrigger(trig)
    endif
endfunction

function DisplayDialogActions takes nothing returns nothing
    local integer PlayerIndex
    set PlayerIndex = GetPlayerId(GetTriggerPlayer())
    call DialogDisplay(GetTriggerPlayer(),DialogA[PlayerIndex],true)
endfunction

function DisplayDialogInitialization takes nothing returns nothing
    local integer i
    set trig = CreateTrigger()
    set i = 0
    loop 
        exitwhen i > MaxPlayerNumber - 1
        call TriggerRegisterPlayerEvent(trig,Player(i),EVENT_PLAYER_END_CINEMATIC)
        call TriggerAddAction(trig, function DisplayDialogActions)
        set i = i + 1
    endloop
endfunction

function DialogSystemInitialization takes integer PlayerNumber returns nothing
    local integer i
    local trigger array tr
    set MaxPlayerNumber = PlayerNumber
    set i = 1
    loop
        exitwhen i > 4
        set tr[i] = CreateTrigger()
        set i = i + 1
    endloop
    set i = 0
    loop
        exitwhen i > MaxPlayerNumber - 1
        set DialogA[i] = DialogCreate()
        set DialogB[i] = DialogCreate()
        set DialogC[i] = DialogCreate()
        set DialogD[i] = DialogCreate()
        set DialogE[i] = DialogCreate()
        set DialogF[i] = DialogCreate()             
        set ButtonA[i] = DialogAddButton(DialogA[i],"|cFFFFFF00"+"选择查看单位属性"+"|r",'Q')
        set ButtonB[i] = DialogAddButton(DialogA[i],"|cFFFFFF00"+"选择查看单位特殊属性"+"|r",'E')       
        set ButtonC[i] = DialogAddButton(DialogA[i],"|cFFFFFF00"+"选择查看单位拥有的物品属性"+"|r",'W')
        call TriggerRegisterDialogButtonEvent(tr[1],ButtonA[i])
        call TriggerRegisterDialogButtonEvent(tr[2],ButtonB[i])
        call TriggerRegisterDialogButtonEvent(tr[3],ButtonC[i])     
        set trA[i] = CreateTrigger()
        call TriggerRegisterPlayerUnitEvent(trA[i],Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
        call TriggerAddAction(trA[i],function PlayerUnitSelectedSetButtonA)
        call DisableTrigger(trA[i])
        set trB[i] = CreateTrigger()
        call TriggerRegisterPlayerUnitEvent(trB[i],Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
        call TriggerAddAction(trB[i],function PlayerUnitSelectedSetButtonB)
        call DisableTrigger(trB[i])     
        set trC[i] = CreateTrigger()
        call TriggerRegisterPlayerUnitEvent(trC[i],Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
        call TriggerAddAction(trC[i],function PlayerUnitSelectedSetButtonC)
        call DisableTrigger(trC[i])
        set i = i + 1
    endloop
    call TriggerAddAction(tr[1],function DialogButtonA)
    call TriggerAddAction(tr[2],function DialogButtonB)
    call TriggerAddAction(tr[3],function DialogButtonC) 
    set i = 1
    loop
        exitwhen i > 5
        set tr[i] = null
        set i = i + 1
    endloop
    call DisplayDialogInitialization()
endfunction

endlibrary

#endif
