print(arg[1])

return nil

package.path = package.path .. ';' .. arg[1] .. '/../Import/YDWE/Build/lua/luabuild/src/?.lua' .. ';' .. arg[1] .. '/../Import/YDWE/Build/lua/?.lua'
package.cpath = package.cpath .. ';' .. arg[1] .. '/../Import/YDWE/Build/lua/luabuild/bin/?.dll'

