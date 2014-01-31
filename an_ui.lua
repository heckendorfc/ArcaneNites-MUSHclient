BACKGROUND_COLOUR = ColourNameToRGB "black"
FONT_COLOUR = ColourNameToRGB "white"
ANSI_FONT_COLOR = string.char(27) .. "0;37m"
BORDER_COLOUR = ColourNameToRGB "#553333"
WIN_GAP = 5
MAX_WIDTH_CHARS = 20

local BLACK = 1
local RED = 2
local GREEN = 3  
local YELLOW = 4 
local BLUE = 5 
local MAGENTA = 6 
local CYAN = 7 
local WHITE = 8

local colortable = {
	["030"] =0x000000,
	["031"] = 0x000080,
	["032"] = 0x008000,
	["033"] = 0x008080,
	["034"] = 0x800000,
	["035"] = 0x800080,
	["036"] = 0x808000,
	["037"] = 0xC0C0C0,
	["130"] = 0x808080,
	["131"] = 0x0000FF,
	["132"] = 0x00FF00,
	["133"] = 0x00FFFF,
	["134"] = 0xFF0000,
	["135"] = 0xFF00FF,
	["136"] = 0xFFFF00,
	["137"] = 0xFFFFFF}

function getMushColor(c,default)
	if c == nil then
		return default
	end

	local single = c:match("^(%d+)m")

	if single == nil then
		for a,b in c:gmatch("(%d+);(%d+)m") do
			if colortable[a .. b] then
				return colortable[a .. b]
			end
		end
	elseif colortable[single] then
		return colortable[single]
	end

	return default
end

function Display_Line (window, i, text, id, colour)

	local left = 5
	local top =  5 + (i * font_height) - font_height

	if text:byte(1)~=27 then
		line = ANSI_FONT_COLOR .. text
	else
		line = text
	end

	for c,t in line:gmatch("\27.([%d;]+m)([^\27]+)") do
		textc = getMushColor(c,colour)
		left = left + WindowText (window, id, t, left, top, 0, 0, textc)
	end

end -- Display_Line

function setup_ui()
	chat_win = "chat" .. GetPluginID ()
	map_win = "map" .. GetPluginID ()
	stat_win = "stats" .. GetPluginID ()
	vit_win = "vitals" .. GetPluginID ()
	affects_win = "affects" .. GetPluginID ()
	font_id = "fn"
	-- font_name = "Fixedsys"    -- the actual font
	font_size = 9

	local x, y, mode, flags = 
	tonumber (GetVariable ("windowx")) or 0,
	tonumber (GetVariable ("windowy")) or 0,
	tonumber (GetVariable ("windowmode")) or 8, -- bottom right
	tonumber (GetVariable ("windowflags")) or 0

	aff_winwidth = 0
	aff_winheight = 0
	stat_winheight = 0
	stat_winwidth = 0
	map_winwidth = 0
	map_winheight = 0

	-- make miniwindow so I can grab the font info
	check (WindowCreate (chat_win, 
		0, 0, 1, 1,  
		1,   -- irrelevant
		0, 
		BACKGROUND_COLOUR) )

	check (WindowCreate (stat_win, 
		0, 0, 1, 1,  
		1,   -- irrelevant
		0, 
		BACKGROUND_COLOUR) )

	check (WindowCreate (map_win, 
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
	add_drag_properties(stat_win)
	add_drag_properties(map_win)
	add_drag_properties(affects_win)

	local fonts = utils.getfontfamilies ()
	if fonts.Dina then
		font_name = "Dina"    
	elseif fonts ["Lucida Sans Unicode"] then
		font_name = "Lucida Sans Unicode"
	else
		font_size = 10
		font_name = "Courier"
	end -- if

	check (WindowFont (stat_win, font_id, font_name, font_size, false, false, false, false, 0, 49))  -- normal
	check (WindowFont (affects_win, font_id, font_name, font_size, false, false, false, false, 0, 49))  -- normal
	check (WindowFont (map_win, font_id, font_name, font_size, false, false, false, false, 0, 49))  -- normal
	check (WindowFont (chat_win, font_id, font_name, font_size, false, false, false, false, 0, 49))  -- normal

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
