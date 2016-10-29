#ifndef Luas
#define Luas
library LuaSystem initializer LuaExec
    globals
    //Event
        trigger event_temp
        string event_custom
    //Damage
        integer damage_obj
        integer damage_id
        unit damage_unit
        string damage_situation
        string damage_math
        real damage_number
        damagetype damage_damagetype
        boolean damage_choose=true
        boolean damage_key=false
    endglobals
//===================Damage=====================
function LuaInDamage takes integer a,integer b,string c,string d,real e,boolean f,damagetype g returns nothing
    set damage_obj=a
    set damage_id=b
    set damage_situation=c
    set damage_math=d
    set damage_number=e
    set damage_choose=f
    set damage_damagetype=g
    call Cheat("exec-lua:InDamage.lua")
endfunction
function LuaInCritOdd takes integer a,integer b,string c,real d,boolean e returns nothing
    set damage_obj=a
    set damage_id=b
    set damage_math=c
    set damage_number=d
    set damage_choose=e
    call Cheat("exec-lua:InCritOdd.lua")
endfunction
function LuaInCritValue takes integer a,integer b,string c,real d,boolean e returns nothing
    set damage_obj=a
    set damage_id=b
    set damage_math=c
    set damage_number=d
    set damage_choose=e
    call Cheat("exec-lua:InCritValue.lua")
endfunction
function LuaInDamageUnit takes unit a,string b,real c,boolean d returns nothing
    set damage_unit=a
    set damage_math=b
    set damage_number=c
    set damage_choose=d
    call Cheat("exec-lua:InDamageUnit.lua")
endfunction
function LuaInCritOddUnit takes unit a,string b,real c,boolean d returns nothing
    set damage_unit=a
    set damage_math=b
    set damage_number=c
    set damage_choose=d
    call Cheat("exec-lua:InCritOddUnit.lua")
endfunction
function LuaInCritValueUnit takes unit a,string b,real c,boolean d returns nothing
    set damage_unit=a
    set damage_math=b
    set damage_number=c
    set damage_choose=d
    call Cheat("exec-lua:InCritValueUnit.lua")
endfunction
function LuaDamageKey takes boolean b returns nothing
    set damage_key=b
endfunction
//===============Event=========================
function LuaInEvent takes trigger tri,string custom returns nothing
    set event_temp=tri
    set event_custom=custom
    call Cheat("exec-lua:InEvent.lua")
    set event_temp=null
    set event_custom=null
endfunction
function LuaToEvent takes string custom returns nothing
    set event_custom=custom
    call Cheat("exec-lua:ToEvent.lua")
    set event_custom=null
endfunction
function LuaRemoveEventAction takes trigger tri,string custom returns nothing
    set event_temp=tri
    set event_custom=custom
    call Cheat("exec-lua:RemoveEventAction.lua")
    set event_temp=null
    set event_custom=null
endfunction
//========================================
function LuaExec takes nothing returns nothing
    debug call Cheat("exec-lua:Console.lua")
    call Cheat("exec-lua:Main.lua")
    call Cheat("exec-lua:Exec.lua")
endfunction
<?import("Console.lua")[==[
    require "jass.runtime".console=true
]==]?>
<?import("Exec.lua")[==[
    require "event.lua"
    require "NewEvent.lua"
    require "DamageSystem.lua"
    require "InitDo.lua"
]==]?>
<?import("Main.lua")[==[
    setmetatable(_ENV,{__index=getmetatable(jass).__index})
    japi=require "jass.japi"
    D2R=3.14159/180
    R2D=180/3.14159
    --<<<<<Trigger>>>>>
        TriggerAnyUnitEvent=function(tri,event)
            for i=0,7 do
                TriggerRegisterPlayerUnitEvent(tri,Player(i),event,null)
            end
        end
    --<<<<<japi>>>>>
        GetDamageData=japi.EXGetEventDamageData
        SetDamage=japi.EXSetEventDamage
    --<<<<<Unit>>>>>
        GetUnitPosition=function(u)
            return GetUnitX(u),GetUnitY(u)
        end
        SetUnitPosition=function(u,x,y)
            SetUnitX(u,x);SetUnitY(u,y)
        end
    --<<<<<Item>>>>>
        IsUnitHaveItem=function(u,id)
            if not id then
                return false
            end
            for i=0,5 do
                local item=UnitItemInSlot(u,i)
                if GetItemTypeId(item)==id then
                    return true
                end
            end
            return false
        end
        GetUnitItemNumber=function(u,id)
            if not id then
                return false
            end
            local n=0
            for i=0,5 do
                local item=UnitItemInSlot(u,i)
                if GetItemTypeId(item)==id then
                    n=n+1
                end
            end
            return n
        end
    --<<<<<Group>>>>>
        Group=function(x,y,r,func)
            local g,b,u=CreateGroup(),true
            GroupEnumUnitsInRange(g,x,y,r,null)
            while b do
                u=FirstOfGroup(g)
                if u then
                    func(u)
                    GroupRemoveUnit(g,u)
                else
                    b=false
                end
            end
            GroupClear(g)
            DestroyGroup(g)
        end
    --<<<<<Texttag>>>>>
        TextTag=function(t,texttag)
            local tag
            if not texttag then
                tag=CreateTextTag()
            else
                tag=texttag
            end
            if t.s then
                if not t.size then
                    t.size=0.03
                end
                SetTextTagText(tag,t.s,t.size*0.023/10) --size<=0.5
            end
            if t.red and t.greed and t.blue then
                if not t.alp then
                    t.alp=255
                end
                SetTextTagColor(tag,t.red,t.green,t.blue,t.alp)
            elseif t.alp then
                if not t.red then
                    t.red=255
                end
                if not t.green then
                    t.green=255
                end
                if not t.blue then
                    t.blue=255
                end
                SetTextTagColor(tag,t.red,t.green,t.blue,t.alp)
            end
            if not t.z then
                t.z=0
            end
            if t.u then
                t.loc,t.x,t.y=nil,nil,nil
                SetTextTagPosUnit(tag,t.u,t.z)
            elseif t.loc then
                t.u,t.x,t.y=nil,nil,nil
                SetTextTagPos(tag,t.loc[1],t.loc[2],t.z)
            elseif t.x and t.y then
                t.u,t.loc=nil,nil
                SetTextTagPos(tag,t.x,t.y,t.z)
            end
            if t.move then
                if not t.speed then
                    t.speed=64
                end
                if not t.angel then
                    t.angel=90
                end
                SetTextTagVelocity(tag,(t.speed*0.071/128)*Cos(D2R*t.angel),(t.speed*0.071/128)*Sin(D2R*t.angel))
            elseif t.speed then
                if not t.angel then
                    t.angel=90
                end
                SetTextTagVelocity(tag,(t.speed*0.071/128)*Cos(D2R*t.angel),(t.speed*0.071/128)*Sin(D2R*t.angel))
            end
            if t.vis then
                SetTextTagVisibility(tag,tag.vis)
            end
            if t.forever then
                SetTextTagPermanent(tag,t.forever)
            end
            if t.life then
                SetTextTagLifespan(tag,t.life)
            end
            if t.age then
                SetTextTagAge(tag,t.age)
            end
        end
--<<<<<DamageSystem>>>>>
    Dam={}
    Dams={}
    Dams2={}
    Dams.Attack={}
    Dams.Passive={}
    Dams.Magic={}
    Dams.PassiveMagic={}
    Dams.Normal={}
    Dams.PassiveNormal={}
    Dam.Save={}
    Dam.Save2={}
    Dam.Symbol={}
    Dam.DamageType={}
    Dam.Func={}
    Dam.Func["+"]=function(a,t,b) return a+b,t end
    Dam.Func["-"]=function(a,t,b) return a-b,t end
    Dam.Func["*"]=function(a,t,b) return a,t*b end
    Dam.Func["/"]=function(a,t,b) return a,t/b end
    Dam.Func2={}
    Dam.Func2["+"]=function(a,b) return a+b end
    Dam.Func2["-"]=function(a,b) return a-b end
    Dam.Tri=CreateTrigger()
]==]?>
<?import("event.lua")[==[
    Events={}
    local Event2=function(event, func)
        local b = true
        if string.sub(event, 1, 1) == "-" then
            event = string.sub(event, 2)
            b = false
        end
        if not Events[event] then --获取事件组,如果不存在就创建
            Events[event] = {}
        end
        local t = Events[event]
        if b then
            table.insert(t, func) --把函数添加到表
        else
            table.remove(t, func)
        end
    end
    Event=function(...)
        arg={...}
        count=#arg
        local func = arg[count]
        for i = 1, count-1 do
            Event2(arg[i], func)
        end
        return func
    end
    local toEvent2 = function(event, data)
        local t = Events[event]
        if t then
            data.event = event
            for _,func in ipairs(t) do
                if func(data) then
                    return true --被触发的函数如果返回true,则跳过之后的函数
                end
            end
        end
    end
    toEvent = function(...)
        local arg = {...}
        local count = #arg
        local data = arg[count]
        for i = 1, count-1 do
            if toEvent2(arg[i], data) then
                return true --触发的事件如果返回true,则跳过之后的触发
            end
        end
    end
--<<<<<<<<<<EnterMap>>>>>>>>>>
    do
        --[[CreateUnit = function(p, i, x, y, f)
            local u = jass.CreateUnit(p, i, x, y, f)
            if not u then
                Error(string.format("CreateUnit : Create failed :(%s,%s,%s,%s,%s)", p, i, x, y, f))
                return
            end
            toEvent("进入地图", {unit = u})
            return u
        end]]
        local tri=CreateTrigger()
        reg=CreateRegion()
        RegionAddRect(reg,GetWorldBounds())
        TriggerRegisterEnterRegion(tri,reg,null)
        TriggerAddCondition(tri, Condition(
            function()
                toEvent("进入地图", {unit = u})
            end
        ))
        RemoveRegion(reg)
--<<<<<<<<<<Spell>>>>>>>>>>
        tri=CreateTrigger()
        TriggerAnyUnitEvent(tri, EVENT_PLAYER_UNIT_SPELL_EFFECT)
        TriggerAddCondition(tri, Condition(
            function()
                toEvent("发动技能", {unit = GetTriggerUnit(), skill = GetSpellAbilityId() ,target = GetSpellTargetUnit() or GetSpellTargetLoc()} )
            end
        ))
        tri=CreateTrigger()
        TriggerAnyUnitEvent(tri, EVENT_PLAYER_HERO_LEVEL)
        TriggerAddCondition(tri, Condition(
            function()
                toEvent("提升等级", {unit = GetTriggerUnit()} )
            end
        ))
        tri=CreateTrigger()
        TriggerAnyUnitEvent(tri, EVENT_PLAYER_HERO_SKILL)
        TriggerAddCondition(tri, Condition(
            function()
                toEvent("学习技能", {unit = GetTriggerUnit(),skill=GetLearnedSkill() } )
            end
        ))
--<<<<<<<<<<Build>>>>>>>>>>
        tri=CreateTrigger()
        TriggerAnyUnitEvent(tri,EVENT_PLAYER_UNIT_CONSTRUCT_FINISH)
        TriggerAddCondition(tri,Condition(
            function()
                toEvent("完成建造",{u=GetConstructedStructure()})
            end
        ))
        tri=CreateTrigger()
        TriggerAnyUnitEvent(tri,EVENT_PLAYER_UNIT_UPGRADE_FINISH)
        TriggerAddCondition(tri,Condition(
            function()
                toEvent("建筑升级",{u=GetConstructedStructure()})
            end
        ))
        tri=CreateTrigger()
        TriggerAnyUnitEvent(tri,EVENT_PLAYER_UNIT_RESEARCH_FINISH)
        TriggerAddCondition(tri,Condition(
            function()
                toEvent("科技",{u=GetResearchingUnit(),research=GetResearched()})
            end
        ))

--<<<<<<<<<<Dead>>>>>>>>>>
        tri = CreateTrigger()
        TriggerAnyUnitEvent(tri, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(tri, Condition(
            function()
                toEvent("死亡", {unit = GetTriggerUnit(), killer = GetKillingUnit()})
            end
        ))
        local units = {}
        RemoveUnit = function(u)
            toEvent("删除单位", {unit = u})
            jass.RemoveUnit(u)
        end
        Event("死亡",
            function(data)
                --if IsHero(data.unit) then return end
                if GetUnitTypeId(data.unit) == 0 then return end
                local t=tonumber(slk.unit[GetID(GetUnitTypeId(data.unit))].death)
                if t > 1000 then return end
                units[data.unit] = CreateTimer()
                TimerStart(units[data.unit], t+5, false,
                    function()
                        RemoveUnit(data.unit)
                    end
                )
            end
        )
        Event("删除单位",
            function(data)
                local timer = units[data.unit]
                if timer then
                    DestroyTimer(timer)
                    units[data.unit] = nil
                end
            end
        )
--<<<<<<<<<<Order>>>>>>>>>>
    tri = CreateTrigger()
    TriggerAnyUnitEvent(tri, EVENT_PLAYER_UNIT_ISSUED_ORDER)
    TriggerAnyUnitEvent(tri, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    TriggerAnyUnitEvent(tri, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    TriggerAddCondition(tri, Condition(
        function()
            local u = GetTriggerUnit()
            local event = GetTriggerEventId()
            local id = GetIssuedOrderId()
            local sid=OrderId2String(id)
            if event == EVENT_PLAYER_UNIT_ISSUED_ORDER then
                toEvent("无目标指令", {unit = u, id = id , sid = sid})
            elseif event == EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER then
                toEvent("物体目标指令", {unit = u, id = id, sid = sid})
            elseif event == EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER then
                toEvent("点目标指令", {unit = u, id = id, sid = sid})
            end
        end
    ))
--<<<<<<<<<<Chat>>>>>>>>>>
        tri=CreateTrigger()
        for i=0,15 do
            TriggerRegisterPlayerChatEvent(tri,Player(i),"",false)
        end
        TriggerAddCondition(tri,Condition(
            function()
                toEvent("聊天",{player=GetTriggerPlayer(),string=GetEventPlayerChatString()})
            end
        ))
    end
]==]?>
<?import("NewEvent.lua")[==[
    NewEvents={}
    EventBack={}
    InitNewEvent=function(event)
        NewEvents[event]={}
        NewEvents[event][0]=CreateTrigger()
        TriggerAddAction(NewEvents[event][0],
            function()
                for i=1,#NewEvents[event] do
                    if NewEvents[event][i] and(TriggerEvaluate(NewEvents[event][i]))and(IsTriggerEnabled(NewEvents[event][i])) then
                        TriggerExecute(NewEvents[event][i])
                     end
                 end
             end
        )
    end
    InEvent=function(tri,event)
        if not NewEvents[event] then
            InitNewEvent(event)
        end
        EventBack[tri]=event
        table.insert(NewEvents[event],tri)
    end
    RemoveEventAction=function(tri,event)
        table.remove(NewEvents[event],tri)
    end
    ToEvent=function(event)
        if (not NewEvents[event])or(not NewEvents[event][1]) then
            InitNewEvent(event)
        else
            TriggerExecute(NewEvents[event][0])
        end
    end
    --注册事件
    InitNewEvent("伤害前")
    InitNewEvent("接受伤害")
]==]?>
<?import("InEvent.lua")[==[
    local j=require "jass.common"
    InEvent(j.event_temp,j.event_custom)
]==]?>
<?import("RemoveEventAction.lua")[==[
    local j=require "jass.common"
    RemoveEventAction(j.event_temp,j.event_custom)
]==]?>
<?import("ToEvent.lua")[==[
    local j=require "jass.common"
    ToEvent(j.event_custom)
]==]?>
<?import("DamageSystem.lua")[==[
    AddDamage=function(obj,id,s,math,number,b,dt)
        if not Dams[s][id] then
            Dams[s][id]=number
        else
            if b==true then
                Dams[s][id]=number
            else
                if (math==Dam.Symbol[id])or((math=="+" and Dam.Symbol[id]=="-")or(math=="-" and Dam.Symbol[id]=="+")or(math=="*" and Dam.Symbol[id]=="/")or(math=="/" and Dam.Symbol[id]=="*")) then
                    local a,b=Dam.Func[math](Dams[s][id],Dams[s][id],number)
                    if a~=number then Dams[s][id]=a elseif b~=number then Dams[s][id]=b end
                else
                    Dams[s][id]=number
                end
            end
        end
        Dam.Save[id]=obj
        Dam.Symbol[id]=math
        Dam.DamageType[id]=dt
    end
    AddCritOdd=function(obj,id,math,odd,b)
        if not Dams[id] then
            Dams[id]={}
        end
        Dam.Save2[id]=obj
        if not Dams[id].odd then
            Dams[id].odd=odd
        else
            if b==true then
                Dams[id].odd=odd
            else
                Dams[id].odd=Dam.Func2[math](Dams[id].odd,odd)
            end
        end
    end
    AddCritValue=function(obj,id,math,value,b)
        if not Dams[id] then
            Dams[id]={}
        end
        Dam.Save2[id]=obj
        if not Dams[id].value then
            Dams[id].value=value
        else
            if b==true then
                Dams[id].value=value
            else
                Dams[id].value=Dam.Func2[math](Dams[id].value,value)
            end
        end
    end
    AddUnitDamage=function(u,s,math,number,b,dt)
        if not Dams[s][u] then
            Dams[s][u]=number
        else
            if b==true then
                Dams[s][u]=number
            else
                if (math==Dam.Symbol[u])or((math=="+" and Dam.Symbol[u]=="-")or(math=="-" and Dam.Symbol[u]=="+")or(math=="*" and Dam.Symbol[u]=="/")or(math=="/" and Dam.Symbol[u]=="*")) then
                    local a,b=Dam.Func[math](Dams[s][u],Dams[s][u],number)
                    if a~=number then Dams[s][u]=a elseif b~=number then Dams[s][u]=b end
                else
                    Dams[s][u]=number
                end
            end
        end
        Dam.Save[u]=|au|
        Dam.Symbol[u]=math
        Dam.DamageType[u]=dt
    end
    AddCritOddUnit=function(u,math,odd,b)
        if not Dams[u] then
            Dams[u]={}
        end
        if not Dams[u].odd then
            Dams[u].odd=odd
        else
            if b==true then
                Dams[u ].odd=odd
            else
                Dams[u].odd=Dam.Func2[math](Dams[u].odd,odd)
            end
        end
    end
    AddCritValueUnit=function(u,math,value,b)
        if not Dams[u] then
            Dams[u]={}
        end
        if not Dams[u].value then
            Dams[u].value=value
        else
            if b==true then
                Dams[u].value=value
            else
                Dams[u].value=Dam.Func2[math](Dams[u].value,value)
            end
        end
    end
--
    TriggerAddCondition(Dam.Tri,Condition(function() return damage_key end))
    TriggerAddAction(Dam.Tri,function()
        local phy=GetDamageData(1)
        local attack=GetDamageData(2)
        local dt=GetDamageData(4)
        local du=GetEventDamageSource()
        local tu=GetTriggerUnit()
        local add=0
        local times=1
        ToEvent("伤害前")
        for big,k in pairs(Dams) do
            local u
            local newdamage=GetEventDamage()
            if type(big)=="number" then
                if attack==1 and k.odd~=nil and k.value~=nil then
                    if Dam.Save2[big]==|unit| then
                        if GetUnitTypeId(du)==big then
                            if GetRandomReal(0,100)<=k.odd then
                                TextTag({s=tostring(newdamage*(1+k.value)),u=tu,size=13,move=true,life=1,red=255,greed=80,blue=80})
                                UnitDamageTarget(du,tu,newdamage*(1+k.value),false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNKNOWN,WEAPON_TYPE_WHOKNOWS)
                            end
                        end
                    elseif Dam.Save2[big]==|abi| then
                        if GetUnitAbilityLevel(du,big)>0 then
                            if GetRandomReal(0,100)<=k.odd then
                                TextTag({s=tostring(newdamage*(1+k.value)),u=tu,size=13,move=true,life=1,red=255,greed=80,blue=80})
                                UnitDamageTarget(du,tu,newdamage*(1+k.value),false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNKNOWN,WEAPON_TYPE_WHOKNOWS)
                            end
                        end
                    elseif Dam.Save2[big]==|item| then
                        if IsUnitHaveItem(du,big)>0 then
                            if GetRandomReal(0,100)<=k.odd then
                                TextTag({s=tostring(newdamage*(1+k.value)),u=tu,size=13,move=true,life=1,red=255,greed=80,blue=80})
                                UnitDamageTarget(du,tu,newdamage*(1+k.value),false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNKNOWN,WEAPON_TYPE_WHOKNOWS)
                            end
                        end
                    end
                end
            elseif type(big)~="string" then
                if ((big=="Attack" or big=="PassiveAttack") and attack==1)or((big=="Magic" or big=="PassiveMagic") and (phy==0))or(big=="Normal")or(big=="PassiveNormal") then
                    if big=="Attack" or big=="Magic" or big=="Normal" then u=du end
                    if big=="Passive" or big=="PassiveMagic" or big=="PassiveNormal" then u=tu end
                    for i in pairs(k) do
                        if (dt==Dam.DamageType[i])or(not Dam.DamageType[i]) then
                            if Dam.Save[i]==|au| then
                                if u==i then
                                    add,times=Dam.Func[Dam.Symbol[i]](add,times,k[i])
                                end
                            elseif Dam.Save[i]==|unit| then
                                if GetUnitTypeId(u)==i then
                                    add,times=Dam.Func[Dam.Symbol[i]](add,times,k[i])
                                end
                            elseif Dam.Save[i]==|abi| then
                                if GetUnitAbilityLevel(u,i)>0 then
                                    add,times=Dam.Func[Dam.Symbol[i]](add,times,k[i])
                                end
                            elseif Dam.Save[i]==|item| then
                                if IsUnitHaveItem(u,i)>0 then
                                    add,times=Dam.Func[Dam.Symbol[i]](add,times,k[i])
                                end
                            end
                        end
                    end
                end
            else
                if attack==1 and k.odd~=nil and k.value~=nil and du==big then
                    if GetRandomReal(0,100)<=k.odd then
                        TextTag({s=tostring(newdamage*(1+k.value)),u=tu,size=13,move=true,life=1,red=255,greed=80,blue=80})
                        UnitDamageTarget(du,tu,newdamage*(1+k.value),false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNKNOWN,WEAPON_TYPE_WHOKNOWS)
                    end
                end
            end
        end
        SetDamage((GetEventDamage()*times)+add)
        ToEvent("接受伤害")
    end)
]==]?>
<?import("InitDo.lua")[==[
    Group(0,0,9999,function(u)
        TriggerRegisterUnitEvent(Dam.Tri,u,EVENT_UNIT_DAMAGED)
    end)
    EnterMapGroup=CreateGroup()
    Event("进入地图",
        function(t)
            if IsUnitInGroup(t.unit,EnterMapGroup) then
                return
            end
            local u=t.unit
            GroupAddUnit(EnterMapGroup,u)
            TriggerRegisterUnitEvent(Dam.Tri,u,EVENT_UNIT_DAMAGED)
        end
    )
]==]?>
<?import("InDamage.lua")[==[
    local j=require "jass.common"
    AddDamage(j.damage_obj,j.damage_id,j.damage_situation,j.damage_math,j.damage_number,j.damage_choose,j.damage_damagetype)
]==]?>
<?import("InDamageUnit.lua")[==[
    local j=require "jass.common"
    AddUnitDamage(j.damage_unit,j.damage_situation,j.damage_math,j.damage_number,j.damage_choose,j.damage_damagetype)
]==]?>
<?import("InCritOdd.lua")[==[
    local j=require "jass.common"
    AddCritOdd(j.damage_obj,j.damage_id,j.damage_math,j.damage_number,j.damage_choose)
]==]?>
<?import("InCritValue.lua")[==[
    local j=require "jass.common"
    AddCritValue(j.damage_obj,j.damage_id,j.damage_math,j.damage_number,j.damage_choose)
]==]?>
<?import("InCritOddUnit.lua")[==[
    local j=require "jass.common"
    AddCritOddUnit(j.damage_unit,j.damage_math,j.damage_number,j.damage_choose)
]==]?>
<?import("InCritValueUnit.lua")[==[
    local j=require "jass.common"
    AddCritValueUnit(j.damage_unit,j.damage_math,j.damage_number,j.damage_choose)
]==]?>
endlibrary
#endif
