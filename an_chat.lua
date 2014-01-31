local chat_log = {}
local chat_log_index = 1
local num_log_lines = 7
local max_width=1

function add_chat_line (line)
	chat_log[chat_log_index] = line

	chat_log_index = chat_log_index + 1
	if chat_log_index > num_log_lines then
		chat_log_index = 1
	end

	max_width = math.max (max_width, WindowTextWidth (chat_win, font_id, line))
	show_chat_log()
end -- add_chat_line

function chat_log_clear ()
	for i=1, num_log_lines do
		chat_log[i] = " "
	end

	show_chat_log ()
end

function show_chat_log ()

	-- do nothing if nothing in the log
	if #chat_log == 0 then
		return
	end -- if

	local winwidth = max_width + 10
	local winheight = (#chat_log)   * font_height + 10

	-- recreate the window the correct size
	check (WindowCreate (chat_win, 
	0, vit_winheight+WIN_GAP,   -- left, top (auto-positions)
	winwidth,
	winheight,
	4,       -- auto-position: top left
	2,  -- flags
	BACKGROUND_COLOUR) )

	check (WindowRectOp (chat_win,1,0,0,winwidth,winheight,BORDER_COLOUR))
	add_drag_properties(chat_win)

	for i=1, #chat_log do
		Display_Line (chat_win, i, chat_log[1+(chat_log_index+i-2)%(num_log_lines)], font_id, FONT_COLOUR)
	end

	WindowShow (chat_win, true)  
end

function tell_line (name, line, wildcards)
	add_chat_line("\27[0;35m" .. line)
end

function say_line (name, line, wildcards)
	add_chat_line("\27[0;33m" .. line)
end

function shriek_line (name, line, wildcards)
	add_chat_line("\27[0;33m" .. line)
end

function hero_line (name, line, wildcards, styles)
	local st = GetStyle(styles,1)
	if st.textcolour ==  0xC0C0C0 then
		add_chat_line("\27[0;37m" .. line)
	end
end

function gtell_line (name, line, wildcards)
	add_chat_line("\27[0;36m" .. line)
end

function ooc_line (name, line, wildcards)
	add_chat_line("\27[0;36m" .. line)
end

function init_chat()
	for i=1, num_log_lines do
		chat_log[i] = " "
	end
end
