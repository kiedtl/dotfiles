local irc    = require('irc')
local mirc   = require('mirc')
local tui    = require('tui')
local tb     = require('tb')
local util   = require('util')
local format = string.format
local M = {}

-- Maximum number of times to try and reconnect to the server if
-- disconnected for any reason. Set to -1 for infinite reconnect.
--
-- NOTE: beware of this feature if you were K-lined for any reason;
-- lurch *might* try to reconnect even in those scenarios (though
-- this hasn't been confirmed, as the author of lurch has never
-- been K-lined before).
M.reconn = 25

M.servers = {
    ["tilde.chat"] = {
        tls  = true,
        host = "irc.tilde.chat",
        port = 6697,

        nick = "kiedtl|lurch",
        pass = util.capture("pash show kiedtl"),
        user = "kiedtl",
        name = "kiedtl",

        join = { "#bots", "#team", "#ctrl-c", "#rw.rs",
            "#coffee", "#tea", "#gemini", "#idlerpg" },
        mode = nil,

        no_ident = false,
        caps = { "server-time", "account-notify", "away-notify",
            "echo-message" }
    },

    ["freenode"] = {
        tls  = true,
        host = "irc.freenode.net",
        port = 6697,

        nick = "kiedtl|lurch",
        pass = util.capture("pash show kiedtl"),
        user = "kiedtl",
        name = "kiedtl",

        join = { "#kisslinux", "#lobsters", "##crustaceans",
            "##C", "#fennel", "#lua" },
        mode = "+wi",

        no_ident = false,
        caps = { "server-time", "account-notify", "echo-message" }
    },
}

-- This can be changed at runtime like so:
-- $ lurch -server freenode
M.server = "tilde.chat"

-- default kick/quit/part message. (defaults to an empty string)
M.quit_msg = function(channel)
    return "*thud*"
end
M.kick_msg = function(channel)
    return "your presence in this community is no longer desirable"
end
M.part_msg = function(channel)
    return "*confused shouting*"
end

-- Default replies for CTCP queries from users/server.
--
-- Return nil to not respond to CTCP messages. Note that doing so
-- may cause issues if the network you're connected to *requires* users
-- to respond to, say, VERSION requests from the server.
--
M.ctcp_source  = function(_event) return "https://github.com/lptstr/lurch" end
M.ctcp_version = function(_event) return "lurch (https://github.com/lptstr/lurch)" end
M.ctcp_ping    = function(_event)
    if _event.nick == "spammer" then
        return nil
    else
        return true
    end
end

-- if set to false, will simply filter out mirc colors.
M.mirc = true

-- Maximum widths for the various columns.
--
-- Columns:
--    time:  the column in which the time is shown.
--    left:  the column in which the nicknames, "NOTE", etc are shown.
--    right: the "main" column in which messages are shown.
--
-- By default, the right column width is:
--    $(terminal_width - left_column_width - time_column_width)
--
-- If the width of a column exceeds the maximum width for that column,
-- it will either be folded to the correct width (for the right column),
-- trimmed (for the left column in case of channel messages), or displayed
-- as-is (for the time column, and for the left column).
--
M.time_col_width = 5
M.right_col_width = nil
M.left_col_width = 12

-- This function is used to provide the terminal colors that lurch
-- will use to highlight nicknames and channels. By default, it gets
-- these colors from conf/colors.
M.colors = function()
    -- read a list of newline-separated colors from conf/colors.
    -- the colors are terminal 256-bit colors. e.g. 3, 65, 245, &c
    local data = util.read(__LURCH_EXEDIR .. "/conf/colors")

    local colors = {}
    for line in data:gmatch("([^\n]+)\n?") do
        colors[#colors + 1] = tonumber(line)
    end

    return colors
end

-- Time/date format. This is shown to the left of every message. See
-- the documentation for os.date() for info on the various format sequences.
--
-- When changing this, be sure to update config.time_col_width as appropriate.
-- To disable time altogether, set this to an empty string and set the
-- config.time_col_width variable to 0.
M.timefmt = "%H:%M"

--
-- Function used to format each line.
--
-- time_pad: number of spaces used to pad the time column.
-- left_pad: same as time_pad, but for the left column.
-- time:     the time string, formatted with config.timefmt.
-- left:     the contents of the left column.
-- right:    the contents of the right column, already folded.
--
M.linefmt = function(time_pad, left_pad, time, left, right)
    time_pad = (" "):rep(time_pad)
    left_pad = (" "):rep(left_pad)

    -- \x0f\x0314%s\x0f: set the color to grey, print the time, and reset
    --      the color.
    -- %s %s%s %s: print the left padding, the left column, and the right
    --      column.
    return format("\x0f\x0314%s\x0f%s%s%s %s", time, time_pad,
        left_pad, left, right)

    -- Uncommenting this will cause the left column to be aligned to the left
    -- instead of to the right.
    --return format("\x0f\x0314%s\x0f%s%s%s %s", time, time_pad,
        --left, left_pad, right)
end

-- Values used for the left column (excluding channel messages).
--
-- names:   used when listing nicknames in a channel.
-- topic:   used when displaying the current topic, or a topic change.
-- error:   value used for error messages (e.g. "Cannot join: invite-only channel")
-- normal:  value normally used for messages.
-- away:    value used for messages pertaining to a user's away status (e.g.:
--      "<nick> is now away" or "<nick> is back")
-- nick:    value used for messages pertaining to a nickname (e.g.: nick changes,
--      "That nickname is in use", etc)
-- action:  value used from CTCP ACTIONs (/me)
-- message: function that's called to format the sender of a message.
M.leftfmt = {
    error   = function(e) return "-!-"   end,
    normal  = function(e) return "--"    end,
    away    = function(e) return "-<>"   end,
    nick    = function(e) return "--@"   end,
    names   = function(e) return "NAMES" end,
    topic   = function(e) return "TOPIC" end,
    action  = function(e) return "*"     end,
    message = function(sender, pings)
        local sndfmt = sender

        -- Remove extra characters fromt the nickname that won't fit.
        --
        -- We can use "#sender" instead of utf8utils.dwidth, because
        -- nicknames may only contain ASCII characters.
        if #sender > (M.left_col_width - 2) then
            sndfmt = sndfmt:sub(1, M.left_col_width - 3)
            sndfmt = sndfmt .. format("\x0f\x0314+\x0f")
        end

        -- "Normalise" nicknames by remove trailing "|<client>",
        -- underscores, or the "matrix marker" (i.e. "[m]"). This
        -- ensures that "solanum|irssi", "solanum|weechat", "solanum_",
        -- "solanum[m]", and "solanum" appear the same.
        local nrm_sender = irc.normalise_nick(sender)

        sndfmt = tui.highlight(sndfmt, nrm_sender)
        if pings then sndfmt = "\x16" .. sndfmt .. "\x0f" end
        sndfmt = "<" .. sndfmt .. ">"

        return sndfmt
    end,
}

-- words that will generate a notification if they appear in a message
M.pingwords = { "kiedtl", "spacehare" }

-- user-defined commands. These take the place of aliases; the alias_to()
-- function below is a convenience function that can be used to quickly
-- alias commands.
local alias_to = function(text)
    return {
        help = { format("An alias to '%s'", text) },
        fn = function(a, args, _)
            if not a then
                parsecmd(text)
            else
                parsecmd(format("%s %s %s", text, a, args))
            end
        end,
    }
end

M.commands = {
    ["/wc"]      = alias_to("/close"),

    ["/shr"]     = alias_to("/shrug"),
    ["/j"]       = alias_to("/join"),
    ["/p"]       = alias_to("/part"),
    ["/l"]       = alias_to("/leave"),
    ["/afk"]     = alias_to("/away Away"),
    ["/back"]    = alias_to("/away"),
    ["/ns"]      = alias_to("/msg NickServ"),
    ["/cs"]      = alias_to("/msg ChanServ"),

    ["/op"]      = alias_to("/mode +o"),
    ["/deop"]    = alias_to("/mode -o"),
    ["/hop"]     = alias_to("/mode +h"),
    ["/dehop"]   = alias_to("/mode -h"),
    ["/voice"]   = alias_to("/mode +v"),
    ["/devoice"] = alias_to("/mode -v"),
    ["/ban"]     = alias_to("/mode +b"),
    ["/unban"]   = alias_to("/mode -b"),

    ["/invex"]   = alias_to("/mode +I"),
    ["/deinvex"] = alias_to("/mode -I"),

    ["/kickban"] = {
        REQUIRE_ARG = true,
        help = { "Kick and ban a user." },
        usage = "<user> [reason...]",
        fn = function(a, args, _)
            parsecmd(format("/kick %s %s", a, args))
            parsecmd(format("/ban %s", a))
        end,
    },
}

-- user-bound keys. See tb.fnl (or tb.lua) for a list of key constants.
M.keyseqs = {
    keys = {
        -- A simple example that runs the command '/read all' when Ctrl+Z
        -- is pressed.
        --
        --[tb.TB_KEY_CTRL_Z] = function() parsecmd("/read all") end,
    },

    mods = {
        -- Another example: bind Alt+b to '/msg NickServ logout'
        --
        --[tb.TB_MOD_ALT] = {
        --    [98] = function() parsecmd("/msg NickServ logout") end,
        --}
    }
}

-- user-defined handlers for IRC commands (not to be confused with lurch's
-- commands); usage of this feature requires knowledge of the IRC protocol
-- and all its quirks.
--
-- If the handler returns CFGHND_CONTINUE or nil, the normal handler will
-- be run; if it returns CFGHND_RETURN, then the default handler will not
-- be executed.
--
-- These handlers can be disabled by setting
-- config.handlers[<CMD>][<NAME>].disabled = true, or by using the /disable
-- command (e.g. /disable PRIVMSG quotes).
--
-- This can be used to implement triggers, as in Weechat.
M.handlers = {
    ["PRIVMSG"] = {
        -- if the message is a quote, display it in light yellow.
        ["quotes"] = {
            fn = function(e)
                if (e.msg):match("^>") then
                    e.msg = mirc.COLOR .. "08" .. e.msg .. mirc.RESET
                end
                return CFGHND_CONTINUE
            end
        }
    },
}

M.tz = "UTC-5:00"

M.ignores = {
    ["S3xyL1nux"]        = "D",
    ["joaquinito0[1-9]"] = "D",
    [".-!Bearfield.-@"]  = "D",
    [".-!MrMoney.-@"]    = "D",
    [".-!rareman.-@"]    = "D",
    [".-!MrETH1.-@"]     = "D",
    ["brendo"]           = "D",
    ["xfnw!.-@"]         = "D",
}

return M
