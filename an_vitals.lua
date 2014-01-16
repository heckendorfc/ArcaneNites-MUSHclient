--latest
GAUGE_LEFT = 55
GAUGE_HEIGHT = 15

WINDOW_WIDTH = 200
WINDOW_HEIGHT = 65
NUMBER_OF_TICKS = 5


local using_msdp = false
local movement_window = "movement_image"  -- miniwindow ID
local health_window = "health_image"  -- miniwindow ID
local mana_window = "mana_image"  -- miniwindow ID
-- local msdp = {}
local border_colour = ColourNameToRGB ("gold") -- ("gold")
local colourBlack = ColourNameToRGB("black")
local hotkeys = {}
local hotkeys_name = {}
local hotkeys_action = {}

-- create the layout here, on getting the prompt, or window resize
function create_layout ()
left = 0
top = 0
right = GetInfo (281) 
bottom = GetInfo (280)
----------------------------------------------------------------------------
-- Create the health, mana and movements bars at the bottom.
----------------------------------------------------------------------------

health_width = math.floor((right+5) / 3)
mana_width = math.floor((right+5) / 3)
moves_width = math.floor((right+5) / 3)

-- HEALTH
pos = 0
local x = tonumber (GetVariable (health_window..'x')) or pos+1
local y = tonumber (GetVariable (health_window..'y')) or top+1

-- make a miniwindow under the text
check (WindowCreate (health_window,   -- window ID
	x,  y,  
	health_width-2, 13,-- width && depth 
	12,            -- center it (ignored anyway) 
	2,             -- draw underneath (1) + absolute location (2)
	colourBlack))  -- background colour
	add_drag_properties(health_window)
	
	-- MANA
	pos = left+health_width-2
	x =	tonumber (GetVariable (mana_window..'x')) or pos+1
	y =	tonumber (GetVariable (mana_window..'y')) or top+1
	-- make a miniwindow under the text
	check (WindowCreate (mana_window,   -- window ID
		x,  y,  
		mana_width-2,  13,  12,          
		2,             -- draw underneath (1) + absolute location (2)
		colourBlack))  -- background colour
	
		add_drag_properties(mana_window)
		
	  -- MOVES
	  pos = left+health_width+mana_width-2
	
	  x =	tonumber (GetVariable (movement_window..'x')) or pos+1
	  y =	tonumber (GetVariable (movement_window..'y')) or top+1
	  -- make a miniwindow under the text
	  check (WindowCreate (movement_window,   -- window ID
	  	x,  y,  
	  	moves_width-2,  13,  12,          
	  	2,             -- draw underneath (1) + absolute location (2)
	  	colourBlack))  -- background colour
	
	  	add_drag_properties(movement_window)
	  	-- draw the energy bars
	  	draw_energy_bars ()
	end -- create_layout
	
	-- fill the three energy bars
	function draw_energy_bars ()
	
	-- HEALTH
	current_health = msdpv["HEALTH"]
	max_health = msdpv["HEALTH_MAX"]
	if current_health == nil then
	current_health = 0
	max_health = 1
	end -- if
	if current_health ~= nil and max_health ~= nil then
	WindowShow (health_window, true) 
	draw_energy_bar("Health", health_width, 0x1111CC, 0x000033, health_window, current_health, max_health)
	end -- if
	
	-- MANA
	current_mana = msdpv["MANA"]
	max_mana = msdpv["MANA_MAX"]
	if current_mana == nil then
	current_mana = 0
	max_mana = 1
	end -- if
	
	if current_mana ~= nil and max_mana ~= nil then
	WindowShow (mana_window, true)
	draw_energy_bar("Mana  ", mana_width, 0xFF3366, 0x330000, mana_window, current_mana, max_mana)
	end -- if
	
	move = msdpv["MOVEMENT"]
	max_move = msdpv["MOVEMENT_MAX"]
	-- initialise with empty bars
	if move == nil then
	move = 0
	max_move = 1
	end -- if
	
	if move ~= nil and max_move ~= nil then
	WindowShow (movement_window, true)
	draw_energy_bar("Moves ", moves_width, 0xFF3366, 0x330000, movement_window, move, max_move)
	end -- if
	end -- draw_energy_bars
	
	
	-- fill the bar
	function draw_energy_bar (type, width, colour, colour2, window, current_value, max_value)
	-- convert the strings to numbers
	current = tonumber(current_value)
	max = tonumber(max_value)
	
	-- Calculate target's health
	if current < 0 then
	current = 0
elseif current > max then
current = max
end -- if

-- clear the bars
WindowGradient (window, 1, -1, width-3, 6, colourBlack, colour2, 2)
WindowLine     (window, 1, 6, width-3, 6, colour2, 0, 1)
WindowGradient (window, 1, 7, width-3, 14, colour2, colourBlack, 2)

-- calculate the filled part
filled = current * (width-4) / max

-- redraw the bars
if current > 0 then
WindowGradient (window, 1, -1, filled+1, 6, colourBlack, colour, 2)
WindowLine     (window, 1, 6, filled+1, 6, colour, 0, 1)
WindowGradient (window, 1, 7, filled+1, 14, colour, colourBlack, 2)
end -- if

-- write the information inside
if max > 0 then
outlined_text (ColourNameToRGB('gold'), window, type..': '..current_value..' / '..max_value, 9, 10, -1)
end -- if

end -- draw_energy_bar

function outlined_text (colour, window, text, size, x, y)
outlineColour = colourBlack
-- write the information inside
WindowFont(window,'f','Times New Roman',size,1,0,0,0)

-- smear black text around the location to create an outline, so that it's clearer to read
WindowText(window,'f',text,x+1,y+1,0,0,outlineColour,0)
WindowText(window,'f',text,x+1,y,0,0,outlineColour,0)
WindowText(window,'f',text,x+1,y-1,0,0,outlineColour,0)
WindowText(window,'f',text,x,y+1,y,0,outlineColour,0)
WindowText(window,'f',text,x,y-1,y,0,outlineColour,0)
WindowText(window,'f',text,x-1,y+1,0,0,outlineColour,0)
WindowText(window,'f',text,x-1,y,0,0,outlineColour,0)
WindowText(window,'f',text,x-1,y-1,0,0,outlineColour,0)

-- display the text
WindowText(window,'f',text,x,y,0,0,colour,0)

end -- outlined_text

function DoGauge (sPrompt, Percent, Colour)

-- show ticks
local ticks_at = (WINDOW_WIDTH - GAUGE_LEFT - 5) / (NUMBER_OF_TICKS + 1)

-- ticks
for i = 1, NUMBER_OF_TICKS do
WindowLine (win, GAUGE_LEFT + (i * ticks_at), vertical, GAUGE_LEFT + (i * ticks_at), vertical + GAUGE_HEIGHT, ColourNameToRGB ("silver"), 0, 1)
end -- for
-- draw a box around it
check (WindowRectOp (win, 1, GAUGE_LEFT, vertical, WINDOW_WIDTH - 5, vertical + GAUGE_HEIGHT, 
	ColourNameToRGB ("lightgrey")))  -- frame entire box
	
	vertical = vertical + font_height + 3
	end -- function
