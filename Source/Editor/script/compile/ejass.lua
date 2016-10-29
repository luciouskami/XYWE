starttime=os.clock()
kk={['']=true,[' ']=true,['/']=true,['\n']=true,['+']=true,['-']=true,['*']=true,['(']=true,[')']=true,[',']=true,['>']=true,['=']=true,['\r']=true}
function string.gsub2(str,s1,s2)
    _,n=string.gsub(str,s1,"")
    if i1==0 then
        return str
    end
    str=" "..str.." "
    for i=1,n do
        str=string.gsub(str,"([^%w_%.])"..s1.."([^%w_%.])","%1"..s2.."%2")
    end
    return string.sub(str,2,#str-1)
end
function string.find2(str,s)
    i1,i2=string.find(str,s)
    if i1==nil then
        return false
    end
    if kk[string.sub(str,i1-1,i1-1)] and kk[string.sub(str,i2+1,i2+1)]then
        return true
    end
    return false
end
function Globals(b,s)
    ENDNUM=ENDNUM+1
    END[ENDNUM]=s
    if global then
        global=false
        table.insert(a,'globals')
        table.insert(a,Global..'endglobals')
        Global=''
    end
end
function ejass_compile(code)
f=assert(io.open(fs.ydwe_path() / "logs" / "jass.txt","w"))
f:write(code)
f:close()
f=io.open(fs.ydwe_path() / "logs" / "jass.txt","r+")--第一次遍历。获取piece，为了防止piece里有不符合语法的情况并且能保证编译通过。还是任意位置，所以遍历三次代码
    a={}
    piece=false;Piece={};piecename="";Apiece=false;zinc=false;noejass=false;khzs=false
    for b in f:lines() do
        if string.find(b,"//") then
            if string.find(b,"//! endzinc") then--避开zinc
                zinc=false
        	elseif string.find(b,"//! zinc") then
            	zinc=true
        	elseif string.find(b,"//! noejass") then--noejass尽可能兼容其它代码
            	noejass=true
            elseif string.find(b,"//! endnoejass") then
            	noejass=false
        	elseif not string.find(b,"//!") then
            	_,_,b=string.find(b,"(.*)%/%/")
        	end
   		end
        if string.find(b,"%/%*") then
            _,_,b=string.find(b,"(.*)%/%*")
            if not string.find(b,"%*%/") then
            	khzs=true
        	end
    	elseif string.find(b,"%*%/") then
        	_,_,b=string.find(b,"%*%/(.*)")
        	khzs=false
        end
        if khzs then
            --如果是跨行注释则什么都不管
        elseif zinc or noejass or string.find(b,"//!") or string.find(b,'native ') then--如果是zinc 或其他预处理
            table.insert(a,b)
        else
            b=string.gsub2(b,"func","function")
            b=string.gsub2(b,"for","loop")
            b=string.gsub2(b,"int","integer")
            b=string.gsub2(b,"float","real")
            b=string.gsub2(b,"bool","boolean")
            b=string.gsub2(b,"nil","null")
            b=string.gsub2(b,"void","nothing")
            i1,i2=string.find(b,"\'%s+\'")
            if i1 then
                b=string.gsub(b,"\'%s+\'",string.sub(Last,i1,i2))
            else
                Last=b
            end
            if string.find(b,"endpiece") then--块
                Piece[piecename]=table.concat(Piece[piecename],'\n')
                piece=false
                Apiece=false
            elseif string.find(b,"!piece ") then
                _,_,piecename=string.find(b,"!piece%s+([^\r\n]+)")
                Piece[piecename]={}
                Apiece=true
            elseif string.find(b,"piece ") then
                _,_,piecename=string.find(b,"piece%s+([^\r\n]+)")
                Piece[piecename]={}
                piece=true
            elseif (not piece) or Apiece then
                _,_,b=string.find(b,"([^\r\n]+)")
                table.insert(a,b)
            end
            if (piece or Apiece) and not string.find(b,"piece ") then
                _,_,b=string.find(b,"([^\r\n]+)")
                table.insert(Piece[piecename],b)
            end
        end
    end
    a=table.concat(a,"\n")
f:close()
f=assert(io.open(fs.ydwe_path() / "logs" / "jass.txt","w+"))
f:write(a)
f:close()
f=assert(io.open(fs.ydwe_path() / "logs" / "jass.txt","r"))--第二次遍历，insert pieces
a={}
    for b in f:lines() do
        b=string.gsub(b,"^%s*(.-)%s*$","%1")
        if string.find(b,"insert ") then
            if string.find(b,")") then
                _,_,piecename,repalce=string.find(b,"^insert%s+([%w_]+)%s*%((.+)%)$")
                Apiece=Piece[piecename]
                _,n=string.gsub(b,"@@","@@")
                for i=1,n+1 do
                    if i==n+1 then
                        V=repalce
                    else
                        _,_,V,repalce=string.find(repalce,"^(.-)@@(.+)$")
                    end
                    Apiece=string.gsub(Apiece,"@"..i.."@",V)
                end
                table.insert(a,Apiece)
            else
                _,_,piecename=string.find(b,"insert%s+([%w_]+)")
                table.insert(a,Piece[piecename])
            end
        else
            table.insert(a,b)
        end
    end
    a=table.concat(a,"\n")
f:close()
f=assert(io.open(fs.ydwe_path() / "logs" / "jass.txt","w+"))
f:write(a)
f:close()
f=io.open(fs.ydwe_path() / "logs" / "jass.txt","r")
    a={}
    func=nil
    zinc=false
    END={}
    ENDNUM=0
    InFor=0
    vFor={}
    global=false--仅为特殊的
    Inglobals=false--通常的全局变量
    Global=""
    Func={}--method function 公用
    locals={["location"]=true,["unit"]=true,["timer"]=true,["destructable"]=true,["item"]=true,["force"]=true,["group"]=true,["trigger"]=true,["region"]=true,["rect"]=true,["effect"]=true,["multiboarditem"]=true}--常见需要set null 的变量类型，排除法会导致结构体误排
    leaklocals={}
    locs=""
    locn=0
    Inloc=false
    struct=false--是否在结构、方法等内，避免全局在结构内加上globals
    method=false
    module=false
    interface=false--是否在接口内，避免method在接口内需要end
    noejass=false
    for b in f:lines() do--第三次遍历，编译ejass
        if string.find(b,"//! endzinc") then--避开zinc
            zinc=false
    	elseif string.find(b,"//! zinc") then
        	zinc=true
    	elseif string.find(b,"//! noejass") then
        	noejass=true
        elseif string.find(b,"//! endnoejass") then
        	noejass=false
        end
        if zinc or noejass or string.find(b,"//!") or string.find(b,'native ') then--如果是zinc 或其他预处理
            table.insert(a,b)
        else
            local dh=string.find(b,"=")
            local len=string.len(b)
            local khz=string.find(b,"%(")--不要只写了")"不写"("
            local _,_,End=string.find(b,"(.)end")
            if not (func or method) and (string.find(b,"function ") or (string.find(b,"method") and not interface))then--是函数或方法，且不在接口、方法、函数内。
                local ej=false
                local boo=string.find(b,"function ")
                if boo then--是函数
                	func=true
                    Globals(b,'function')
                	if not khz then--普通的函数开始
                		table.insert(a,b)
        			else--ej函数开始
                        ej=true
                    end
                else--是方法
                    Globals(b,"method")
                    method=true
                    if not khz or string.find(b,"operator") then--普通的方法开始,不含左括号或含operator
                		table.insert(a,b)
                	else--ej的方法
                    	ej=true
            		end
                end
                if ej then--ej的方法或函数
               		local ta="";re=""
               		if string.find(string.sub(b,khz+1,string.find(b,")")-1),"%a") then--括号之间
                    	ta=string.sub(b,khz+1,string.find(b,")")-1)
                	else
                		ta='nothing'
                	end
                	if string.find(b,">") then--之外，判断无">"时
                 	    re=string.sub(b,string.find(b,">")+1,len)
               		else
                	   	re='nothing'
                	end
                	table.insert(a,string.sub(b,1,khz-1).." takes "..ta.." returns "..re)
            	end
            	Inloc=true
           	elseif string.find(b,"end") and (End or " ")==" " then--end类
           		local _,_,endstr=string.find(b,"end(%a+)")
           		if interface then
                    interface=false
               	end
           		if not endstr then--不为正常的结尾
                	if END[ENDNUM]=='function' then
                    	func=false
                    	b=locs..table.concat(Func,'\n')..'\n'..b--loc部分+其他部分+end部分
                    	locs=''
                    	Func={}
                    	leaklocals={}
                    	locn=0
                    	vFor={}
                	elseif END[ENDNUM]=='struct' then
                    	struct=false
                    elseif END[ENDNUM]=='method'then
                        method=false
                 	    b=locs..table.concat(Func,'\n')..'\n'..b
                   	 	locs=''
                  		Func={}
                   		leaklocals={}
                   		locn=0
                    	vFor={}
                    elseif END[ENDNUM]=='module'then
                        module=false
                    elseif END[ENDNUM]=='interface'then
                    	interface=false
                    elseif END[ENDNUM]=='globals'then
                        Inglobals=false
                    end
            		if func or method then--在函数、方法内
                		if END[ENDNUM]=='for' then
                    		table.insert(Func,'endloop')
                            InFor=InFor-1
                    	else
                    		table.insert(Func,b..END[ENDNUM])
                        end
                    else
                        if END[ENDNUM]~=nil then
                            b=b..END[ENDNUM]
                        else
                            b=b..'错误的end结尾'
                        end
            		end
            	elseif (func or method) and (endstr=='loop'or endstr=='if'or endstr=='for') then--函数或方法内
            		if endstr=='for' then
                		InFor=InFor-1
                		table.insert(Func,'endloop')
                	else
                		table.insert(Func,b)
                    end
                elseif endstr=='function' then--正常function结尾
                    func=false
                    b=locs..table.concat(Func,'\n')..'\n'..b
                    locs=''
                    Func={}
                    leaklocals={}
                    locn=0
                   	vFor={}
                elseif endstr=='struct' then
                    struct=false
                elseif endstr=='module' then
                    module=false
                elseif endstr=='method' then
                    method=false
                    b=locs..table.concat(Func,'\n')..'\n'..b
                    locs=''
                    Func={}
                    leaklocals={}
                    locn=0
                   	vFor={}
                elseif endstr=='interface'then
                    interface=false
                elseif endstr=='globals' then--正常globals结尾
                    Inglobals=false
                end
                ENDNUM=ENDNUM-1
            elseif func or method then--函数、方法内
                local loc=nil
                if string.find2(b,"return")
                or string.find2(b,"exitwhen")
                or string.find2(b,"set")
                or string.find2(b,"call") then--正常语句排除
                Inloc=false
                elseif string.find(b,'flush locals') then
                    loc=true
                    Inloc=false
                    for _,s in pairs(leaklocals) do
                        table.insert(Func,'set '..s..'=null')
                    end
                    leaklocals={}
                elseif string.find2(b,"if") or string.find(b,'elseif') then--避免字符串之类
                    if not string.find(b,"then") then
                        b=b..' then'
                    end
                    Inloc=false
                    if not string.find(b,"elseif") then--非elseif
                        ENDNUM=ENDNUM+1
                        END[ENDNUM]="if"
                    end
                elseif string.find(b,'local') then
                    local _,_,t,v=string.find(b,"local%s+(%a+)%s+([%w_]+)")--local integer x_2
                    if Inloc then--顶上直接写
                        loc=true
                        locs=locs..b..'\n'
                    elseif dh then
                        local _,_,v,f=string.find(b,"([%w_]+)%s*=(.+)")
                        b="set "..v..'='..f
                        locs=locs..'local '..t..' '..v..'\n'
                    else--没等号
                        loc=true
                        locs=locs..b..'\n'
                    end
                   	if locals[t] and not string.find(b," array ") then--数组
                       	locn=locn+1
                    	leaklocals[locn]=v
                    end
                elseif string.find(b,"loop")then
                    ENDNUM=ENDNUM+1
                    Inloc=false
                    b=string.gsub2(b,'do','')
                    _,_,v,x,y,z=string.find(b,"loop%s+(.-)%s*=(.+),(.+),(.+)")
                    if not v then
                        z=1
                        _,_,v,x,y=string.find(b,"loop%s+(.-)%s*=(.+),(.+)")
                    end
                    if v then
                        END[ENDNUM]="for"
                        InFor=InFor+1
                        b='loop\nset ejv_'..v..'=ejv_'..v..'+'..z..'\nexitwhen ejv_'..v..'>'..y--loop exiwhen v>y v=v+z
                        if InFor>1 then
                            b='set ejv_'..v..'='..x..'-'..z..'\n'..b
                        end
                        if vFor[v] then
                            b='set ejv_'..v..'='..x..'-'..z..'\n'..b
                        else
                            locs=locs..'local integer ejv_'..v..'='..x..'-'..z..'\n'
                            vFor[InFor]=v
                            vFor[v]=true
                        end
                    else
                        END[ENDNUM]="loop"
                    end
                elseif khz and not dh then--没有"="且有"(",自动添加call
                    b='call '..b
                    Inloc=false
                elseif string.find((string.sub(b,1,dh or len)),"%a+%s+([%w_]+)")then--为两个字符串(等号前)
                    local _,_,t,v=string.find(b,"(%a+)%s+([%w_]+)")
                    if Inloc then
                        loc=true
                        locs=locs.."local "..b..'\n'
                    elseif dh then
                        local _,_,v,f=string.find(b,"([%w_]+)%s*=(.+)")
                        b="set "..v..'='..f
                        locs=locs.."local "..t..' '..v..'\n'
                    else
                        loc=true
                        locs=locs.."local "..b..'\n'
                    end
                    if locals[t] and not string.find(b," array ") then
                        locn=locn+1
                        leaklocals[locn]=v
                    end
                elseif dh then--有等号
                    if string.find(b,"%-%=")then--减等
                        local _,_,v,v2=string.find(b,"(.+)%-%=(.+)")
                        b=v.."="..v2.."-"..v
                        Inloc=false
                    elseif string.find(b,"%+%=")then--加等
                        local _,_,v,v2=string.find(b,"(.+)%+%=(.+)")
                        b=v.."="..v2.."+"..v
                        Inloc=false
                    elseif string.find(b,"%*%=")then--乘等
                        local _,_,v,v2=string.find(b,"(.+)%*%=(.+)")
                        b=v.."=("..v2..")*"..v
                        Inloc=false
                    elseif string.find(b,"%/%=")then--除等
                        local _,_,v,v2=string.find(b,"(.+)%/%=(.+)")
                        b=v.."=("..v2..")/"..v
                        Inloc=false
             	    end
                    b="set "..b
                    Inloc=false
                elseif string.find(b,"%+%+")then--自加
                    local _,_,v=string.find(b,"(.+)%+%+")
                    b="set "..v.."="..v.."+1"
                    Inloc=false
                elseif string.find(b,"%-%-")then--自减
                    local _,_,v=string.find(b,"(.+)%-%-")
                    b="set "..v.."="..v.."-1"
                    Inloc=false
                end
                if InFor>0 then
                    for _,v in ipairs(vFor) do
                    	b=string.gsub2(b,v,"ejv_"..v)
                	end
                end
                if not loc then
                	table.insert(Func,b)
        		end
            elseif string.find(b,"library")then--库
                Globals(b,"library")
                local _,_,IsInit=string.find(b,"library%s+(%a+)")
                if not string.find(b,"initializer") then--init,万一有library init init init的情况
                    if IsInit=="init" then
                        b=string.gsub(b,"init","libraryname",1)
                        b=string.gsub(b,"init","initializer",1)
                        b=string.gsub(b,"libraryname","init",1)
                    else
                        b=string.gsub(b,"init","initializer",1)
                    end
                end
            elseif string.find(b,"scope")then--域
                Globals(b,"scope")
            elseif string.find(b,"globals")then--全局变量
                Inglobals=true
                Globals(b,"globals")
            elseif string.find(b,"struct") and not string.find(b,"able")then--结构体
                struct=true
                Globals(b,"struct")
            elseif string.find(b,"module")then--模
                module=true
                Globals(b,"module")
            elseif string.find(b,"interface")then--接口
                interface=true
                Globals(b,"interface")
            elseif string.find((string.sub(b,1,dh or len)),"%a+%s+%a+") and not(struct or interface or module or Inglobals) then--省略globals
                Global=Global..b..'\n'
                global=true
        	end
        	if not (global or func or method) then--若非函数或是全局变量、方法则不立即写
            	table.insert(a,b)
        	end
   		end
    end
    a=table.concat(a,'\n')
    a=a.."\n"
f:close()
--a=a..tostring(os.clock()-starttime)--编译时间
return a
end