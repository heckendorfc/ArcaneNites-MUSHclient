local text_colour = FONT_COLOUR

function parseMinimap(maplist)
	-- return {{"barkskin","10"},{"combat","5"}}
	local nop=1;
	local ind=1
	minimap = {}

	local mapl=maplist

	for i=1,string.len(mapl) do
		b=string.byte(mapl,i)
		if b == 13 then
			nop = 1
		elseif b == 10 then
			ind = ind+1
		else
			if minimap[ind] == nil then
				minimap[ind] = string.char(b)
			else
				minimap[ind] = minimap[ind] .. string.char(b)
			end
		end
	end
end

function show_minimap()
	if msdpv["MINI_MAP"] == nil then
		return
	end -- if

	parseMinimap (msdpv["MINI_MAP"])

	map_max_width = 1
	for i=1,#minimap do
		lwidth = WindowTextWidth (map_win, font_id, minimap[i]:sub(1,15))
		map_max_width = math.max (map_max_width, lwidth)
	end

	map_winwidth = map_max_width + 10
	map_winheight = (#minimap)   * font_height + 5

	local x = winpos.right-aff_winwidth-map_winwidth
	--local y = winpos.height-stat_winwidth-map_winwidth
	local y = vit_winheight+1+stat_winheight 
 
	-- recreate the window the correct size
	check (WindowCreate (map_win, 
		x, y,   -- left, top (auto-positions)
		map_winwidth,
		map_winheight,
		7,       -- auto-position: top middle
		2,  -- flags
		BACKGROUND_COLOUR) )

	check (WindowRectOp (map_win,1,0,0,map_winwidth,map_winheight,BORDER_COLOUR))
	add_drag_properties(map_win)

	for i=1,#minimap do
		Display_Line (map_win, i, minimap[i], font_id, text_colour)
	end

	WindowShow (map_win, true)  
end

