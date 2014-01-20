--local stat_keys = {"AC","CHA","CON","DAMROLL","DEX","HITROLL","INT","SAVES","STR","WIS"}
local pri_stat_keys = {"STR","DEX","CON","WIS","CHA","INT"}
local sec_stat_keys = {"DAMROLL","HITROLL","SAVES","AC"}
local text_colour = FONT_COLOUR

function show_stats()
	-- if #msdpv == 0 then
		-- return
	-- end -- if

	stat_winwidth = stat_max_width + 10
	stat_winheight = (#pri_stat_keys + #sec_stat_keys + 1)   * font_height + 5

	local x = winpos.right-aff_winwidth-stat_winwidth
	--local y = winpos.height-stat_winwidth
	local y = vit_winheight+1 

	-- recreate the window the correct size
	check (WindowCreate (stat_win, 
		x, y,   -- left, top (auto-positions)
		stat_winwidth,
		stat_winheight,
		7,       -- auto-position: top middle
		2,  -- flags
		BACKGROUND_COLOUR) )

	check (WindowRectOp (stat_win,1,0,0,stat_winwidth,stat_winheight,BORDER_COLOUR))
	add_drag_properties(stat_win)

	for i=1,#pri_stat_keys do
		if msdpv[pri_stat_keys[i]] then
			line = string.format("%3s: %s",pri_stat_keys[i]:sub(1,3),msdpv[pri_stat_keys[i]])
			Display_Line (stat_win, i, line, font_id, text_colour)
		end
	end
	for i=1,#sec_stat_keys do
		if msdpv[sec_stat_keys[i]] then
			line = string.format("%3s: %s",sec_stat_keys[i]:sub(1,3),msdpv[sec_stat_keys[i]])
			Display_Line (stat_win, #pri_stat_keys+i+1, line, font_id, text_colour)
		end
	end

	WindowShow (stat_win, true)  
end
