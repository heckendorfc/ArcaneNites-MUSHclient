--local stat_keys = {"AC","CHA","CON","DAMROLL","DEX","HITROLL","INT","SAVES","STR","WIS"}
local pri_stat_keys = {"STR","DEX","CON","WIS","CHA","INT"}
local sec_stat_keys = {"DAMROLL","HITROLL","SAVES","AC"}
local ter_stat_keys = {"ALIGNMENT","SIZE","SEX","FIGHTING_STANCE"}
local ter_stat_key_title = {"ALIGN","SIZE","SEX","STANCE"}
local text_colour = FONT_COLOUR

function show_stats()
	-- if #msdpv == 0 then
		-- return
	-- end -- if

	longline = string.format("%" .. string.format("%d",MAX_WIDTH_CHARS) .. "s"," ")
	stat_winwidth = WindowTextWidth (stat_win, font_id, longline) + 10
	-- stat_winwidth = stat_max_width + 10
	stat_winheight = (#pri_stat_keys + #sec_stat_keys + #ter_stat_keys + 2)   * font_height + 10

	local x = winpos.right-aff_winwidth-stat_winwidth-WIN_GAP
	--local y = winpos.height-stat_winwidth
	local y = vit_winheight+WIN_GAP 

	-- recreate the window the correct size
	check (WindowCreate (stat_win, 
		x, y,   -- left, top (auto-positions)
		stat_winwidth,
		stat_winheight,
		7,       -- auto-position: top middle
		2,  -- flags
		BACKGROUND_COLOUR) )

	for i=1,#pri_stat_keys do
		if msdpv[pri_stat_keys[i]] then
			line = string.format("\27[1;36m%3s: \27[0m%s",pri_stat_keys[i]:sub(1,3),msdpv[pri_stat_keys[i]])
			Display_Line (stat_win, i, line, font_id, text_colour)
		end
	end
	for i=1,#sec_stat_keys do
		if msdpv[sec_stat_keys[i]] then
			line = string.format("\27[1;36m%3s: \27[0m%s",sec_stat_keys[i]:sub(1,3),msdpv[sec_stat_keys[i]])
			Display_Line (stat_win, #pri_stat_keys+i+1, line, font_id, text_colour)
		end
	end
	for i=1,#ter_stat_keys do
		if msdpv[ter_stat_keys[i]] then
			line = string.format("\27[1;36m%6s: \27[0m%s",ter_stat_key_title[i],msdpv[ter_stat_keys[i]])
			Display_Line (stat_win, #sec_stat_keys+#pri_stat_keys+i+2, line, font_id, text_colour)
		end
	end

	check (WindowRectOp (stat_win,1,0,0,stat_winwidth,stat_winheight,BORDER_COLOUR))
	add_drag_properties(stat_win)

	WindowShow (stat_win, true)  
end
