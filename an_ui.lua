BACKGROUND_COLOUR = ColourNameToRGB "rosybrown"
FONT_COLOUR = ColourNameToRGB "darkred"
BORDER_COLOUR = ColourNameToRGB "#553333"

function Display_Line (window, i, text, id, colour)

  local left = 5
  local top =  (i * font_height) - font_height

  WindowText (window, id, text, left, top, 0, 0, colour)

end -- Display_Line

function setup_ui()
	stat_win = "stats" .. GetPluginID ()
	vit_win = "vitals" .. GetPluginID ()
	affects_win = "affects" .. GetPluginID ()
	font_id = "fn"
	font_name = "Fixedsys"    -- the actual font

	local x, y, mode, flags = 
	tonumber (GetVariable ("windowx")) or 0,
	tonumber (GetVariable ("windowy")) or 0,
	tonumber (GetVariable ("windowmode")) or 8, -- bottom right
	tonumber (GetVariable ("windowflags")) or 0

	-- make miniwindow so I can grab the font info
	check (WindowCreate (stat_win, 
		0, 0, 1, 1,  
		1,   -- irrelevant
		0, 
		BACKGROUND_COLOUR) )

	check (WindowCreate (affects_win, 
		0, 0, 1, 1,  
		1,   -- irrelevant
		0, 
		BACKGROUND_COLOUR) )

	check (WindowCreate (vit_win, 
		x, y, WINDOW_WIDTH, WINDOW_HEIGHT,  
		mode,   
		flags,   
		BACKGROUND_COLOUR) )

	add_drag_properties(vit_win)
	--add_drag_properties(stat_win)

	check (WindowFont (stat_win, font_id, font_name, 9, false, false, false, false, 0, 0))  -- normal
	check (WindowFont (affects_win, font_id, font_name, 9, false, false, false, false, 0, 0))  -- normal

	stat_max_width = WindowTextWidth(stat_win, font_id, "HITROLL: 12345678")
	font_height = WindowFontInfo (stat_win, font_id, 1)  -- height
	WindowShow (vit_win, true)
end

function mousedown(flags, hotspot_id)
windr = hotspot_id
-- find where mouse is so we can adjust window relative to mouse
startx, starty = WindowInfo (windr, 14), WindowInfo (windr, 15)

-- find where window is in case we drag it offscreen
origx, origy = WindowInfo (windr, 10), WindowInfo (windr, 11)
end -- mousedown

function dragmove(flags, hotspot_id)
windr = hotspot_id
-- find where it is now
local posx, posy = WindowInfo (windr, 17), WindowInfo (windr, 18)

-- move the window to the new location
WindowPosition(windr, posx - startx, posy - starty, 0, 2);

-- change the mouse cursor shape appropriately
if posx < 0 or posx > GetInfo (281) or posy < 0 or posy > GetInfo (280) then
check (SetCursor ( 11))   -- X cursor
else
check (SetCursor ( 1))   -- hand cursor
end -- if

end -- dragmove

function dragrelease(flags, hotspot_id)
windr = hotspot_id
local newx, newy = WindowInfo (windr, 17), WindowInfo (windr, 18)

-- don't let them drag it out of view
if newx < 0 or newx > GetInfo (281) or newy < 0 or newy > GetInfo (280) then
-- put it back
WindowPosition(windr, origx, origy, 0, 2);
end -- if out of bounds
end -- dragrelease

function add_drag_properties(windows)
WindowAddHotspot(windows, windows,  
	0, 0, 0, 0,   -- whole window
	"",   -- MouseOver
	"",   -- CancelMouseOver
	"mousedown",
	"",   -- CancelMouseDown
	"",   -- MouseUp
	"Drag to move",  -- tooltip text
	1, 0)  -- hand cursor
	
	WindowDragHandler(windows, windows, "dragmove", "dragrelease", 0) 
	end -- function add_drag_properties(windows)
