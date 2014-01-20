local text_colour = FONT_COLOUR

function parseAffects(afflist)
	-- return {{"barkskin","10"},{"combat","5"}}
	local pos=1
	local ind=1
	aff = {}

	aff[ind] = {}

	for i=1,string.len(afflist) do
		b=string.byte(afflist,i)
		if b == 2 then
			pos = 2
		elseif b == 1 then
			pos = 1
			ind = ind+1
			aff[ind] = {}
		elseif b>2 then
			if aff[ind][pos] == nil then
				aff[ind][pos] = string.char(b)
			else
				aff[ind][pos] = aff[ind][pos] .. string.char(b)
			end
		end
	end
end

function calcAffectsWidth(al)
	return locw
end

function show_affects()
	if msdpv["AFFECTS"] == nil then
		return
	end -- if

	parseAffects (msdpv["AFFECTS"])

	aff_max_width = 1
	for i=1,#aff do
		if aff[i][1] ~= nil then
			line = string.format ("%s: %s", aff[i][1], aff[i][2])
			lwidth = WindowTextWidth (affects_win, font_id, line)
			aff_max_width = math.max (aff_max_width, lwidth)
		end
	end

	aff_winwidth = aff_max_width + 10
	--aff_winheight = (#aff)   * font_height + 5
	aff_winheight = winpos.bottom-vit_winheight-1

	local x = winpos.right-aff_winwidth
	local y = vit_winheight+1 

	-- recreate the window the correct size
	check (WindowCreate (affects_win, 
		x, y,   -- left, top (auto-positions)
		aff_winwidth,
		aff_winheight,
		8,       -- auto-position: top middle
		2,  -- flags
		BACKGROUND_COLOUR) )

	check (WindowRectOp (affects_win,1,0,0,aff_winwidth,aff_winheight,BORDER_COLOUR))
	add_drag_properties(affects_win)

	-- line = string.format("%s: %s",aff[1][1],aff[1][2])
	-- Display_Line (affects_win, 1, line, font_id, text_colour)

	for i=1,#aff do
		if aff[i][1] ~= nil then
			line = string.format ("%s: %s", aff[i][1], aff[i][2])
			Display_Line (affects_win, i, line, font_id, text_colour)
		end
	end

	WindowShow (affects_win, true)  
end

