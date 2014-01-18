local text_colour = 0x000000

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
		line = string.format ("%s: %s", aff[i][1], aff[i][2])
		lwidth = WindowTextWidth (affects_win, font_id, line)
		aff_max_width = math.max (aff_max_width, lwidth)
	end

	-- recreate the window the correct size
	check (WindowCreate (affects_win, 
		0, 0,   -- left, top (auto-positions)
		aff_max_width + 10,     -- width
		(#aff)   * font_height + 5,  -- height
		7,       -- auto-position: top middle
		0,  -- flags
		0xE7FFFF) )

	line = string.format("%s: %s",aff[1][1],aff[1][2])
	Display_Line (affects_win, 1, line, font_id, text_colour)

	for i=2,#aff do
		line = string.format ("%s: %s", aff[i][1], aff[i][2])
		Display_Line (affects_win, i, line, font_id, text_colour)
	end

	WindowShow (affects_win, true)  
end

