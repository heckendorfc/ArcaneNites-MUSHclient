msdpv = {}
--msdpk = {}

local MSDP = 69

function OnPluginTelnetRequest (type, data)
	if type == MSDP and data == "WILL" then
		using_msdp = true
		return true
	elseif type == MSDP and data == "SENT_DO" then
		-- IAC SB MSDP response IAC SE 
		SendPkt ("\255\250\69\1REPORT\2HEALTH\2HEALTH_MAX\2MANA\2MANA_MAX\2MOVEMENT\2MOVEMENT_MAX\2HITROLL\2DAMROLL\2SAVES\2AC\2STR\2INT\2WIS\2CON\2DEX\2CHA\255\240")
		return true
	else -- another protocol
		return false
	end -- if
end -- function OnPluginTelnetRequest

function OnPluginTelnetSubnegotiation (type, data)
if type == MSDP then
endpos = string.len(data)
bName = false
bValue = false
bTable = false
bIgnore = false
variable = nil
value = nil

--Note('Raw data: ['..data..']')

for i=1,endpos,1 do
if string.byte(data,i) == 1 and bTable == false then
if variable ~= nil and value ~= nil then
StoreVariable(variable, value)
variable = nil
value = nil
end -- if
bName = true
bValue = false
elseif string.byte(data,i) == 2 and bTable == false then
if value ~= nil then
value = value.." "
end -- if
bName = false
bValue = true
elseif string.byte(data,i) == 3 then
bTable = true
bIgnore = true
elseif string.byte(data,i) == 4 then
bTable = false
elseif bIgnore == true then
bIgnore = false -- Just ignore one character.
elseif bName == true then
if variable == nil then
variable = ""
end -- if
variable = variable..string.sub(data,i,i)
elseif bValue == true then
if value == nil then
value = ""
end -- if
value = value..string.sub(data,i,i)
end -- if
end -- for

if variable ~= nil then
if value == nil then
value = ""
end -- if
StoreVariable(variable, value)
end -- if

-- redraw the energy bars
show_stats()

end -- if
end -- function OnPluginTelnetSubnegotiation

function findInd(MSDP_var)
	if #msdpv == 0 then
		return 1
	else
		for i=1,#msdpv do
			if msdpk[i] == MSDP_var then
				return i
			end
		end
	end

	return #msdpv+1
end

function StoreVariable (MSDP_var, MSDP_val)
	--Note('Variable: '..MSDP_var..' = '..MSDP_val)
	if MSDP_var == "SERVER_ID" then
		ui_update()
		SendPkt ("\255\250\69\1PLUGIN_ID\2GW2 MUSHclient plugin (version 1.14)\255\240")
	elseif MSDP_var == "HOTKEY" then
		msdpv[MSDP_var] = MSDP_val
		-- update_hotkeys ()
	else -- store the variable
		msdpv[MSDP_var] = MSDP_val
		ui_update()
	end -- if
end -- function StoreVariable


