local stat_keys = {"AC","CHA","CON","DAMROLL","DEX","HITROLL","INT","SAVES","STR","WIS"}
local text_colour = 0x000000

function show_stats()
	-- if #msdpv == 0 then
		-- return
	-- end -- if

	-- recreate the window the correct size
	check (WindowCreate (stat_win, 
		0, 0,   -- left, top (auto-positions)
		stat_max_width + 10,     -- width
		(#stat_keys)   * font_height + 5,  -- height
		7,       -- auto-position: top middle
		0,  -- flags
		0xE7FFFF) )

	for i=1,#stat_keys do
		if msdpv[stat_keys[i]] then
			line = string.format("%s: %s",stat_keys[i],msdpv[stat_keys[i]])
			Display_Line (stat_win, i, line, font_id, text_colour)
		end
	end

	WindowShow (stat_win, true)  
end
