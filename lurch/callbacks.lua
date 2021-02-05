local mirc      = require('mirc')
local config    = require('config')
local irc       = require('irc')
local tui       = require('tui')
local util      = require('util')
local lurchconn = require('lurchconn')
local utf8utils = require('utf8utils')
local termbox   = require('termbox')
local format = string.format

local M = {}

-- This is called at lurch's startup, just after the TUI and readline
-- have been setup.
function M.on_startup()
end

-- This is called at the beginning of lurch, and its purpose
-- it to print some nice text and ascii art on the main buffer.
-- Of course, you could just stuff this into on_startup().
--
-- This function should assume that the current buffer already
-- is the main buffer, and should not switch buffers.
function M.print_banner(version)
    -- the text to be printed. Note that completely blank lines
    -- won't get printed, so add a trailing space to empty lines.
    local text = "\n\
|     ._ _ |_    o ._  _    _ | o  _  ._ _|_\n\
| |_| | (_ | |   | |  (_   (_ | | (/_ | | |_\n\
 \n\
lurch %s (https://github.com/lptstr/lurch)\n\
(c) Kiëd Llaentenn. Lurch is GPLv3 software.\n\
 \n\
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --\n\
 \n\
"
    text = format(text, version)

    -- print each line, one by one.
    for textline in text:gmatch("([^\n]+)\n?") do
        prin_cmd(buf_cur(), "--", "%s", textline)
    end
end

-- This is a sample prompt function. It's extremely barebones,
-- and does nothing beyond printing what the user has entered
-- and making the cursor visible. See fancy_promptf for a more
-- complex example.
--
-- See: callbacks.prompt
function M.simple_promptf(inp, cursor)
    -- strip off stuff from input that can't be shown on the
    -- screen, and show IRC formatting escape sequences nicely.
    inp = mirc.show(inp:sub(-(tui.tty_width -1)))

    -- draw the input buffer and move the cursor to the appropriate
    -- position.
    termbox.writeline(tui.tty_height-1, inp)
    termbox.setcursor(cursor, tui.tty_height-1)
end

-- A more fully-featured prompt function. This prompt changes
-- dynamically as the user types and shows clearly how the input
-- will be interpreted: as a command, as a /note, as a /me, or
-- as a regular message. It was inspired by catgirl[0].
--
-- See: callbacks.prompt
-- [0]: https://git.causal.agency/catgirl
function M.fancy_promptf(inp, cursor)
    -- by default, the prompt is <NICK>, but if the user is
    -- typing a command, change to prompt to "/"; if the user
    -- has typed "/me", change the prompt to "* <NICK>"; if
    -- the user has type "/note", change to the prompt to
    -- "NOTE(<NICK>)".
    --
    -- In all these cases, redundant input is trimmed off (unless
    -- the cursor is on the redundant text, in which case the
    -- input is shown as-is).
    local prompt

    -- highlighted nickname.
    local hnick = tui.highlight(nick, irc.normalise_nick(nick))

    if inp:find("/me ") == 1 and cursor >= 4 then
        prompt = format("%s %s ", config.leftfmt.action(), hnick)
        inp = inp:sub(5, #inp)
        cursor = cursor - 4
    elseif inp:find("/note ") == 1 and cursor >= 6 then
        prompt = format("NOTE(%s) ", hnick)
        inp = inp:sub(7, #inp)
        cursor = cursor - 6
    elseif inp:sub(1, 1) == "/" then
        -- if there are two slashes at the beginning of the input,
        -- indicate that it will be treated as a message instead
        -- of a command.
        if inp:sub(2, 2) == "/" then
            prompt = format("%s \x0314/\x0f", hnick)
        else
            prompt = format("\x0314/\x0f")
        end

        inp = inp:sub(2, #inp)
        cursor = cursor - 1
    else
        prompt = format("<%s> ", hnick)
    end

    -- strip escape sequences so that we may accurately calculate
    -- the prompt's length.
    local rawprompt_len = utf8utils.dwidth(mirc.remove(prompt))

    -- strip off stuff from input that can't be shown on the
    -- screen
    local offset = (tui.tty_width - 1) - rawprompt_len
    inp = inp:sub(-offset)

    -- show IRC formatting escape sequences nicely.
    inp = mirc.show(inp)

    -- Clear the line, remove any bold/color, draw the input buffer
    -- and move the cursor to the appropriate position.
    termbox.writeline(tui.tty_height-1, format("\x0f%s%s", prompt, inp))
    termbox.setcursor(cursor + rawprompt_len, tui.tty_height-1)
end

-- The function that is called on every keypress. It should, at the
-- very least, draw the current input and make the cursor visible
-- in the correct location. By default, it is set to the fancy_promptf
-- function above, but feel free to set it to your own function and
-- delete the builtin ones if you so please.
M.prompt = M.fancy_promptf

-- Called when <Enter> is recieved. The input is changed to whatever this
-- function returns.
--
-- Be careful, returning nil will cause the input to be changed to nil no
-- matter what is entered, meaning that Ctrl+C will no longer work to exit
-- (pkill and friends would have to be used). (This is because pressing
-- Ctrl+C simply simulates the user typing "/quit" and pressing <Enter>).
function M.on_input(input)
    -- By default, don't modify the input.
    return input
end

-- A pretty barebones statusline function, inspired by icyrc's [0] statusline.
-- [0]: https://github.com/icyphox/icyrc
--
-- See: callbacks.statusline
function M.simple_statusline()
    local chl = ""
    local l = 0
    local fst = cbuf

    while fst > 1 and l < (M.tty_width / 2) do
        l = l + utf8utils.dwidth(bufs[fst].name) + 3
        fst = fst - 1
    end

    l = 0
    while fst <= #bufs and l < M.tty_width do
        local ch = bufs[fst]
        if fst == cbuf then chl = chl .. mirc.RESET end

        chl = chl .. "  "; l = l + 1

        if ch.unreadh > 0 then chl = chl .. mirc.UNDERLINE end
        if ch.pings > 0   then chl = chl .. mirc.BOLD end

        chl = chl .. ch.name
        l = l + utf8utils.dwidth(ch.name)

        if ch.pings > 0   then chl = chl .. mirc.BOLD end
        if ch.unreadh > 0 then chl = chl .. mirc.UNDERLINE end

        if l < (M.tty_width - 1) then
            chl = chl .. "  "; l = l + 2
        end

        if fst == cbuf then chl = chl .. mirc.INVERT end

        fst = fst + 1
    end

    local padding = M.tty_width - #(mirc.remove(chl))
    chl = format("\x16%s%s\x0f", chl, (" "):rep(padding))
    termbox.writeline(0, chl)
end

-- A more fully-featured statusline, heavily based on catgirl's [0] statusbar.
-- Unlike simple_statusline, which is just white on black, it makes heavy use
-- of color.
--
-- See: callbacks.statusline
-- [0]: https://git.causal.agency/catgirl
function M.fancy_statusline()
    local chanlist = ""
    for buf = 1, #bufs do
        local ch = bufs[buf].name
        local bold = false
        local unread_ind = ""

        if bufs[buf].unreadl > 0 or bufs[buf].unreadh > 0 or bufs[buf].pings > 0 then
            if bufs[buf].pings > 0 then
                bold = true
                if bufs[buf].unreadh > 0 then
                    unread_ind = format("+%d,%d", bufs[buf].pings, bufs[buf].unreadh)
                else
                    unread_ind = format("+%d", bufs[buf].pings)
                end
            elseif bufs[buf].unreadh > 0 then
                -- Uncomment the lines below if you want low-priority
                -- events (joins, quits, etc) to show in the statusline.
                --if bufs[buf].unreadl > 0 then
                --    unread_ind = format("+%d (%d)", bufs[buf].unreadh, bufs[buf].unreadl)
                --else
                --    unread_ind = format("+%d", bufs[buf].unreadh)
                --end

                unread_ind = format("+%d", bufs[buf].unreadh)
            elseif bufs[buf].unreadl > 0 then
                -- Uncomment this, too, if you want low-priority events
                -- to show in the statusline.
                --unread_ind = format("(%d)", bufs[buf].unreadl)
            end
        end

        local pnch
        if unread_ind ~= "" then
            pnch = tui.highlight(format(" %d %s %s ", buf, ch, unread_ind),
                ch, not bold)
        elseif unread_ind == "" and buf == cbuf then
            pnch = tui.highlight(format(" %d %s ", buf, ch), ch, true)
        end

        -- If there are no unread messages, don't display the buffer in the
        -- statusline (unless it's the current buffer)
        if buf == cbuf then
            chanlist = format("%s\x0f\x16%s\x0f ", chanlist, pnch)
        else
            if pnch then
                chanlist = format("%s%s ", chanlist, pnch)
            end
        end
    end

    termbox.writeline(0, "\x0f" .. chanlist)
end

-- The statusline function, the purpose of which is to print the list
-- of open channels on the top of the terminal window (aka the 'statusline').
-- This is called whenever a new buffer is opened, when a buffer is closed,
-- or when the screen is redrawn. By default, it is set the the fancy_statusline
-- example above.
M.statusline = M.fancy_statusline

-- called whenever there is a new unread message/event in a buffer.
--
-- type: the type of notification. A low-priority notification (e.g.
--      joins, quits, parts, etc) will be 0, a medium-priority notification
--      (e.g. messages, notices, actions) will be 1, and high-priority
--      notifications (messages that ping the user) will be 2.
-- buffer: the number of the buffer to which the unread message was sent.
-- left, right: value of the left and right columns, respectively. Don't use
--      the value of the left column to get the nickname of the user who sent
--      a message, it will be contaminated with escape sequences; use the
--      event parameter instead.
-- event: the parsed IRC message that led to the IRC event. (See irc.lua)
function M.on_unread(type, dest, time, left, right, event)
    if type == 2 then
        -- Disabled by default.
        --os.execute("notify-send All your pings are belong to us")
    end
end

-- called when the unread notifications are cleared for a buffer (e.g.
-- when the user switched to that buffer).
function M.on_cleared_unread(buffer)
end

return M
