util.require_natives("1663599433")
util.create_tick_handler(function()
    HUD.MP_TEXT_CHAT_DISABLE(true)
end)

local all_visible_chats = {}
function new_chat_obj(pid, player_name, player_color, tag, text)
    return {
        pid = pid,
        player_name = player_name,
        player_color = player_color,
        tag = tag,
        text = text,
        timestamp = os.time()
    }
end

-- some code from https://github.com/cummodore69/uwuifier/blob/main/uwuifier/uwuifier.lua
local function uwu(text)
    text = string.lower(text):gsub("l", "w"):gsub("r", "w"):gsub("v", "f"):gsub("i", "i-i"):gsub("d", "d-d"):gsub("n", "n-n")
    local ran = math.random(5)
    pluto_switch ran do 
        case 2:
            text = text .. " uwu"
            break 
        case 3:
            text = text .. " nya.."
            break
        case 4:
            text = text .. " ><"
            break
    end
    return text
end


local main_root = menu.my_root()
local regular_coloring_root = main_root:list("Colors", {}, "Spice things up")
local conditional_coloring_root = regular_coloring_root:list("Conditional coloring", {}, "Conditionally color player names based on criteria. In hierarchy. Me > Modders > Friends > Strangers")
local tags_root = main_root:list("Tags", {}, "Give everyone tags based off certain criteria")
local general_settings = main_root:list("General settings", {}, "Max chat length, etc")

local max_chat_len = 254
general_settings:slider("Max chat length", {"chatmaxlength"}, "Anything over this will automatically be trimmed down. Does not apply to your chats.", 1, 254, 254, 1, function(value)
    max_chat_len = value
end)

local max_chats = 5
general_settings:slider("Max chats", {"chatmaxchats"}, "The max chats that can be displayed/in history. Anything over this value will not be shown.", 1, 5, 5, 1, function(value)
    max_chats = value
end)

local display_time = 5
general_settings:slider("Display for x seconds", {"chatdisptime"}, "The amount of time, in seconds, the chat box will be visible after the chat box is woken through a new message or typing.", 1, 300, 5, 1, function(value)
    display_time = 5
end)

local chat_cooldown_ms = 1000
general_settings:slider("Chat cooldown", {"chatcooldown"}, "The cooldown between each chat, in milliseconds. Chats exceeding this will not be shown.", 0, 10000, 1000, 1, function(value)
    chat_cooldown_ms = value
end)

local pos_x = 0.68
local pos_x_slider_focused = false
local pos_x_slider = general_settings:slider_float("Position X", {"chatposx"}, ".", 0, 1000, 68, 1, function(value)
    pos_x = value*0.01
end)

menu.on_focus(pos_x_slider, function()
    pos_x_slider_focused = true 
end)

menu.on_blur(pos_x_slider, function()
    pos_x_slider_focused = false
end)

local pos_y = 0.35
local pos_y_slider_focused = false
pos_y_slider = general_settings:slider_float("Position Y", {"chatposy"}, ".", 0, 1000, 35, 1, function(value)
    pos_y = value*0.01
end)

menu.on_focus(pos_y_slider, function()
    pos_y_slider_focused = true 
end)

menu.on_blur(pos_y_slider, function()
    pos_y_slider_focused = false
end)

local text_scale = 0.5
local text_scale_slider_focused = false
text_scale_slider = general_settings:slider_float("Message text scale", {"chatmsgtxtscale"}, "", 0, 1000, 50, 1, function(value)
    text_scale = value*0.01
end)

menu.on_focus(text_scale_slider, function()
    text_scale_slider_focused = true 
end)

menu.on_blur(text_scale_slider, function()
    text_scale_slider_focused = false
end)

local tag_scale = 0.4
local tag_scale_slider_focused = false
tag_scale_slider = general_settings:slider_float("Tag scale", {"chatmsgtagscale"}, ".", 0, 1000, 40, 1, function(value)
    tag_scale = value*0.01
end)

menu.on_focus(tag_scale_slider, function()
    tag_scale_slider_focused = true 
end)

menu.on_blur(tag_scale_slider, function()
    tag_scale_slider_focused = false
end)


local uwuify = false
general_settings:toggle("UwU", {}, "OK I ADMIT IT I LOVE YOU OK i fucking love you and it breaks my heart when i see you play with someone else or anyone commenting in your profile i just want to be your girlfriend and put a heart in my profile linking to your profile and have a walltext of you commenting cute things i want to play video games talk in discord all night and watch a movie together but you just seem so uninsterested in me it fucking kills me and i cant take it anymore i want to remove you but i care too much about you so please i’m begging you to eaither love me back or remove me and never contact me again it hurts so much to say this because i need you by my side but if you dont love me then i want you to leave because seeing your icon in my friendlist would kill me everyday of my pathetic life.", function(on)
    uwuify = on
end)

local show_typing = true
general_settings:toggle("Show typing", {}, "", function(on)
    show_typing = on
end, true)


local wake_typing = true
general_settings:toggle("Wake with typing", {}, "Wake chatbox when someone types", function(on)
    wake_typing = on
end, true)


general_settings:action("Send long test message", {}, "", function()
    chat.send_message(random_string(254), false, true, false)
    util.toast("No, it's not networked.")
end)



msg_text_color = {r = 1, g = 1, b = 1, a = 1}
regular_coloring_root:colour("Message text color", {"chatmsgtxtcolor"}, "", msg_text_color, true, function(rgb)
    msg_text_color = rgb 
end)

tag_color = {r = 1, g = 1, b = 1, a = 1}
regular_coloring_root:colour("Tag color", {"chatmsgtagcolor"}, "", tag_color, true, function(rgb)
    tag_color = rgb 
end)

typing_color = {r = 1, g = 1, b = 1, a = 0.8}
regular_coloring_root:colour("Typing color", {"chatmsgtypingcolor"}, "", tag_color, true, function(rgb)
    typing_color = rgb 
end)

bg_color = {r = 0, g = 0, b = 0, a = 0.7}
regular_coloring_root:colour("BG color", {"chatmsgtagcolor"}, "", bg_color, true, function(rgb)
    bg_color = rgb 
end)


local conditional_coloring = true
conditional_coloring_root:toggle("Conditional coloring", {}, "", function(on)
    conditional_coloring = on
end, true)

me_color = {r = 1, g = 0, b = 1, a = 1}
conditional_coloring_root:colour("Me", {"chatmecolor"}, "", me_color, true, function(rgb)
    me_color = rgb 
end)

friends_color = {r = 0, g = 1, b = 0, a = 1}
conditional_coloring_root:colour("Friends", {"chatfriendcolor"}, "", friends_color, true, function(rgb)
    friends_color = rgb
end)

strangers_color = {r = 1, g = 1, b = 1, a = 1}
conditional_coloring_root:colour("Strangers", {"chatstrangercolor"}, "", strangers_color, true, function(rgb)
    strangers_color = rgb
end)

modders_color = {r = 1, g = 0, b = 0, a = 1}
conditional_coloring_root:colour("Modders", {"chatmoddercolor"}, "", modders_color, true, function(rgb)
    modders_color = rgb
end)

custom_tag = "SEX"
tag_mode = 1
tags_root:list_select("Tag mode", {"chattagmode"}, "Select what tags should be applied", {"GTA V Default", "Stand tags", "Custom text", "No tags"}, 1, function(index)
    tag_mode = index
end)

tags_root:text_input("Custom tag text", {"chatcustomtag"}, "This must be configured under tag mode to be used", function(input)
    custom_tag = input
end, "SEX")

async_http.init("pastebin.com", "/raw/nrMdhHwE", function(result)
    main_root:hyperlink("Join Discord", result, "")
end)
async_http.dispatch()

-- player options

local muted_players = {}
local function player(pid)
    menu.divider(menu.player_root(pid), "chit-chat") 
    menu.toggle(menu.player_root(pid), "Mute user", {}, "Mute this player.\nNo chats from them will be displayed, but the animation of a new chat will still play (unfortunately) due to limitations and everything else will work, such as typing notification and luas/features that affect chat.", function(on)
        if on then 
            muted_players[pid] = true
        else
            muted_players[pid] = nil
        end
    end)
end

players.on_leave(function(pid)
    muted_players[pid] = nil 
end)

players.on_join(player)
players.dispatch_on_join()

handle_ptr = memory.alloc(13*8)
local function pid_to_handle(pid)
    NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
    return handle_ptr
end
local last_chat_time = os.time()
local chat_cooldowns = {}
chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
    if muted_players[sender] ~= nil then
        return 
    end
    if chat_cooldowns[sender] ~= nil and sender ~= players.user() then
        util.toast("Chat cooldown exceeded from " .. players.get_name(sender) .. ". Message(s) not shown.")
        return
    end
    -- coloring player names
    local player_color = 1
    if conditional_coloring then
        local hdl = pid_to_handle(sender)
        if sender == players.user() then 
            player_color = me_color
        elseif NETWORK.NETWORK_IS_FRIEND(hdl) then
            player_color = friends_color
        elseif players.is_marked_as_modder(sender) then 
            player_color = modders_color
        else
            player_color = strangers_color
        end
    end

    -- custom tags, technically there is also CEO chat but whatever
    local tag = if team_chat then "TEAM" else "ALL"
    if tag_mode == 2 then 
        tag = players.get_tags_string(sender)
    elseif tag_mode == 3 then
        tag = custom_tag
    elseif tag_mode == 4 then
        tag = ""
    end

    if players.user() ~= sender then 
        text = text:sub(1, max_chat_len)
    end

    if uwuify then 
        text = uwu(text)
    end

    -- somehow chats > 254 get generated???
    all_visible_chats[#all_visible_chats+1] = new_chat_obj(sender, players.get_name(sender), player_color, tag, text:sub(1, 254))
    last_chat_time = os.time()
    chat_cooldowns[sender] = true 
    util.yield(chat_cooldown_ms)
    chat_cooldowns[sender] = nil

    if #all_visible_chats > max_chats then
        table.remove(all_visible_chats, 1)
    end
end)

function get_all_typers_string()
    local typers = {}
    for _,pid in players.list(false, true, true) do 
        if players.is_typing(pid) then 
            typers[#typers+1] = players.get_name(pid)
        end
    end
    if #typers == 0 then 
        return ""
    end
    local type_string = ""
    if #typers > 1 then
        type_string = table.concat(typers, ', ')
        local p1, p2 = string.partition(type_string, ',', true)
        if #typers == 2 then
            type_string = p1 .. " and" .. p2 .. " are typing..."
        else
            type_string = p1 .. ", and" .. p2 .. " are typing..."
        end
    else
        type_string = table.concat(typers, '') .. " is typing..."
    end
    return type_string
end

-- credit to aaronlink127
local function split_string_chunks_respect_word(str, char_len)
    local t = {}
    local cur_str = ""
    local i = 1
    if string.contains(str, ' ') then 
        local t = {}
        while #str > char_len do
            t[#t + 1] = str:sub(1, char_len)
            str = str:sub(char_len + 1)
        end
        t[#t + 1] = str
        return t
    end

    for ln in str:gmatch("([^%s]*)") do
        if (#cur_str + #ln + 1) > char_len then
            t[i] = cur_str
            i += 1
            cur_str = ""
        else
            cur_str ..= " "
        end
        cur_str ..= ln
    end
    if #cur_str ~= 0 then
        t[i] = cur_str
    end
    return t
end

local teamsay = menu.action(menu.my_root(), "", {"teamsay"}, "", function()
end, function(input)
    chat.send_message(input, true, true, true)
end)    
menu.set_visible(teamsay, false)

local chat_box_y_scale = 0.0    
util.create_tick_handler(function()
    local min_rect_width = 0.3
    local chat_box_x = pos_x
    local chat_box_y = pos_y
    local max_chat_box_x = min_rect_width - 0.025
    if PAD.IS_CONTROL_JUST_RELEASED(245, 245) then 
        menu.show_command_box("say ")
    elseif PAD.IS_CONTROL_JUST_RELEASED(246, 246) then 
        menu.show_command_box("teamsay ")
    end
    if menu.command_box_is_open() or pos_x_slider_focused or pos_y_slider_focused or tag_scale_slider_focused or text_scale_slider_focused then 
        last_chat_time = os.time()
    end
    
    if show_typing then
        local typers = get_all_typers_string()
        if typers ~= "" then 
            if wake_typing then 
                last_chat_time = os.time()
            end
        end
        if #all_visible_chats > 0 then
            directx.draw_text(chat_box_x + (max_chat_box_x / 2), chat_box_y - 0.01, typers, 5, text_scale, typing_color, true)
        end
    end

    if #all_visible_chats > 0 then
        if os.time() - last_chat_time < display_time then
            directx.draw_rect(chat_box_x, chat_box_y, min_rect_width, chat_box_y_scale, bg_color)
            local y_offset = 0.0
            for index, c in all_visible_chats do
                local concat_text = ": " .. c.text:gsub('\n', '')
                local concat_tag = " [" .. c.tag .. "]"
                local concat_name = "" .. c.player_name
                local name_measure_x, name_measure_y = directx.get_text_size(concat_name, text_scale)
                local tag_measure_x, tag_measure_y = directx.get_text_size(concat_tag, tag_scale)
                local text_measure_x, text_measure_y = directx.get_text_size(concat_text, text_scale)
                local guesstimate_width = (name_measure_x + tag_measure_x + text_measure_x) -- for spaces between the name, tag, and then text
                if guesstimate_width > min_rect_width then 
                    min_rect_width = guesstimate_width
                end
                local segments = {}
                segments[1] = concat_text
                if guesstimate_width > max_chat_box_x then
                    -- get a good estimate of how many characters we need to hit until the string goes over the limit 
                    local string_limit = 65
                    for i=1, 254 do
                        local scale_x, _ = directx.get_text_size(concat_text:sub(1, i), text_scale)
                        guesstimate_width = (name_measure_x + tag_measure_x + scale_x)
                        if guesstimate_width <= max_chat_box_x then
                            string_limit = i 
                        else 
                            break
                        end
                    end
                    segments = split_string_chunks_respect_word(concat_text, string_limit)
                end
                    for i, line in pairs(segments) do
                        local _, guesstimate_height = directx.get_text_size(line, text_scale)
                        local x_offset = chat_box_x
                        if i == 1 then
                            directx.draw_text(x_offset, chat_box_y + y_offset, concat_name, 3, text_scale, c.player_color)
                            x_offset = chat_box_x + name_measure_x
                            if c.tag ~= "" then
                                directx.draw_text(x_offset, chat_box_y + y_offset + (tag_measure_y/10), concat_tag, 3, tag_scale, tag_color)
                                x_offset += name_measure_x
                                directx.draw_text(chat_box_x + name_measure_x + tag_measure_x, chat_box_y + y_offset, line, 3, text_scale, msg_text_color, true)
                            else 
                                directx.draw_text(chat_box_x + name_measure_x, chat_box_y + y_offset, line, 3, text_scale, msg_text_color, true)
                            end
                        else
                            directx.draw_text(x_offset, chat_box_y + y_offset, line, 3, text_scale, msg_text_color, true)
                        end
                        y_offset += guesstimate_height + 0.001
                        chat_box_y_scale = y_offset
                end
            end
        end
    end
end)

local alphabet = "abcdefghijklmnopqrstuvwxyzABCEDFGHIJKLMNOPQRSTUVWXYZ0123456789"

function random_string(length)
    local res = {}
    for i=1, length do 
        res[i] = alphabet[math.random(#alphabet)]
    end
    return table.concat(res)
end

util.on_stop(function()
    HUD.MP_TEXT_CHAT_DISABLE(false)
end)

util.keep_running()