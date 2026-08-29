{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  swayosd = "${pkgs.swayosd}/bin/swayosd-client";
  asusctl = "${pkgs.asusctl}/bin/asusctl";
  rog-control-center = "${pkgs.asusctl}/bin/rog-control-center";
  thunar = "thunar";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
in {
  # https://wiki.hypr.land/Configuring/Basics/Binds/
  # For uncommon syms/bindings, see https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h
  wayland.windowManager.hyprland.extraLuaFiles.binds = ''
    local mod = "SUPER"
    local mod2 = "ALT"
    local modShift = "SUPER + SHIFT"
    local modAlt = "SUPER + ALT"
    local left, down, up, right = "H", "J", "K", "L"

    local function moveCursor(dx, dy)
      return function()
        local pos = hl.get_cursor_pos()
        if pos then
          hl.dispatch(hl.dsp.cursor.move({ x = pos.x + dx, y = pos.y + dy }))
        end
      end
    end

    local function launch(cmd)
      return function()
        hl.dispatch(hl.dsp.exec_cmd(cmd))
        hl.dispatch(hl.dsp.submap("reset"))
      end
    end

    local function scratchpad(key, name)
      hl.bind(mod .. " + " .. key, hl.dsp.workspace.toggle_special(name))
      hl.bind(modShift .. " + " .. key, hl.dsp.window.move({ workspace = "special:" .. name }))
    end

    hl.bind(mod2 .. " + SPACE", hl.dsp.exec_cmd("walker"))
    hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("alacritty msg create-window || alacritty"))
    hl.bind(modShift .. " + RETURN", hl.dsp.exec_cmd("rio"))
    hl.bind(mod .. " + E", hl.dsp.exec_cmd("${thunar}"))

    hl.bind(modShift .. " + Q", hl.dsp.window.close())
    hl.bind(mod .. " + P", hl.dsp.window.pseudo())

    -- backtick = GRAVE
    scratchpad("GRAVE", "notes")
    scratchpad("MINUS", "scratchpad")
    scratchpad("EQUAL", "procs")
    scratchpad("BACKSPACE", "magic")

    for key, dir in pairs({ [left] = "l", [down] = "d", [up] = "u", [right] = "r" }) do
      hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
      hl.bind(modShift .. " + " .. key, hl.dsp.window.move({ direction = dir }))
    end

    -- Grouped (tabbed) windows
    hl.bind(mod .. " + G", hl.dsp.group.toggle())
    hl.bind(mod .. " + TAB", hl.dsp.group.next())
    hl.bind(modShift .. " + TAB", hl.dsp.group.prev())

    -- Set fullscreen mode without notifying the client that it has been fullscreened (Useful for brave/firefox hiding tabs on fullscreen)
    hl.bind(mod .. " + F", hl.dsp.window.fullscreen_state({ internal = 2, client = -1 }))
    -- Maintain the current fullscreen state and notify the client that it has been fullscreened
    hl.bind(modShift .. " + F", hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }))

    hl.bind(modShift .. " + R", hl.dsp.exec_cmd("hyprctl reload && notify-send 'Reloaded hyprland'"))
    hl.bind(modShift .. " + SPACE", hl.dsp.window.float())
    hl.bind(mod2 .. " + C", hl.dsp.exec_cmd("walker -m clipboard"))
    hl.bind(mod2 .. " + V", hl.dsp.exec_cmd("walker -m clipboard"))
    hl.bind(mod2 .. " + W", hl.dsp.exec_cmd("wallpaper-chooser"))

    -- https://github.com/altdesktop/playerctl?tab=readme-ov-file#selecting-players-to-control
    hl.bind(modShift .. " + M", hl.dsp.exec_cmd("${playerctl} play-pause"))
    hl.bind(modShift .. " + N", hl.dsp.exec_cmd("${playerctl} next"))
    hl.bind(modShift .. " + B", hl.dsp.exec_cmd("${playerctl} previous"))

    -- Toggles headphones on/off (See scripts/bluetooth.nix)
    hl.bind(mod2 .. " + B", hl.dsp.exec_cmd("bt-toggle"))

    -- workspace controls
    hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

    for i = 1, 10 do
      local key = i % 10 -- 10 maps to key 0
      hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
      hl.bind(modShift .. " + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    -- screenshot
    hl.bind("F6", hl.dsp.exec_cmd("screenshot"))
    hl.bind("Print", hl.dsp.exec_cmd("screenshot"))
    -- android device screenshot -> clipboard
    hl.bind(modShift .. " + P", hl.dsp.exec_cmd("adb exec-out screencap -p | wl-copy && notify-send 'Android screenshot copied to clipboard'"))

    hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("sleep 0.1 && hyprlock"))

    -- capture current hyprctl clients for debugging
    hl.bind(mod .. " + Z", hl.dsp.exec_cmd("hyprctl clients -j | jq > /tmp/hypr-clients.json && notify-send 'Saved current clients to /tmp/hypr-clients.json'"))

    hl.bind("Caps_Lock", hl.dsp.exec_cmd("sleep 0.1 && ${swayosd} --caps-lock"))
    hl.bind("Num_Lock", hl.dsp.exec_cmd("sleep 0.1 && ${swayosd} --num-lock"))

    -- Move/resize windows with mod + LMB/RMB and dragging
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${swayosd} --output-volume +5 && play-vol-change-sound"), { repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${swayosd} --output-volume -5 && play-vol-change-sound"), { repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${swayosd} --output-volume mute-toggle"), { repeating = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${swayosd} --input-volume mute-toggle"), { repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${swayosd} --brightness +5"), { repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${swayosd} --brightness -5"), { repeating = true })

    hl.bind("XF86Launch1", hl.dsp.exec_cmd("${rog-control-center}"), { repeating = true })
    hl.bind("XF86Launch3", hl.dsp.exec_cmd("${asusctl} led-mode -n"), { repeating = true })
    hl.bind("XF86Launch4", hl.dsp.exec_cmd("${asusctl} profile -n"), { repeating = true })

    hl.bind(modAlt .. " + " .. right, hl.dsp.window.resize({ x = 80, y = 0, relative = true }), { repeating = true })
    hl.bind(modAlt .. " + " .. left, hl.dsp.window.resize({ x = -80, y = 0, relative = true }), { repeating = true })

    for key, delta in pairs({ right = { 1, 0 }, left = { -1, 0 }, down = { 0, 1 }, up = { 0, -1 } }) do
      hl.bind(modShift .. " + " .. key, moveCursor(delta[1] * 10, delta[2] * 10), { repeating = true })
      hl.bind(modAlt .. " + SHIFT + " .. key, moveCursor(delta[1], delta[2]), { repeating = true })
    end

    -- binds that are locked, a.k.a will activate even while an input inhibitor is active
    -- https://wiki.hypr.land/Configuring/Basics/Binds/#switches
    hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("hyprlock"), { locked = true })
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${playerctl} play-pause"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${playerctl} previous"), { locked = true })
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${playerctl} next"), { locked = true })

    -- Resize Mode
    hl.bind(mod .. " + R", hl.dsp.submap("resize"))
    hl.define_submap("resize", function()
      hl.bind(left, hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
      hl.bind(right, hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
      hl.bind(up, hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
      hl.bind(down, hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
      hl.bind("escape", hl.dsp.submap("reset"))
      hl.bind("catchall", hl.dsp.submap("reset")) -- https://wiki.hypr.land/Configuring/Basics/Binds/#catch-all
    end)

    -- Mouse Move Mode
    hl.bind(mod .. " + M", hl.dsp.submap("mouse"))
    hl.define_submap("mouse", function()
      hl.bind(left, moveCursor(-16, 0), { repeating = true })
      hl.bind(right, moveCursor(16, 0), { repeating = true })
      hl.bind(up, moveCursor(0, -16), { repeating = true })
      hl.bind(down, moveCursor(0, 16), { repeating = true })

      -- clicks
      hl.bind("a", hl.dsp.exec_cmd("hyprctl dispatch mouse 1")) -- left click
      hl.bind("s", hl.dsp.exec_cmd("hyprctl dispatch mouse 2")) -- right click
      hl.bind("d", hl.dsp.exec_cmd("hyprctl dispatch mouse 3")) -- middle click

      hl.bind("escape", hl.dsp.submap("reset"))
      hl.bind("catchall", hl.dsp.submap("reset"))
    end)

    -- Launch Mode
    hl.bind(mod .. " + O", hl.dsp.submap("launch"))
    hl.define_submap("launch", function()
      hl.bind("F", launch("firefox"))
      hl.bind("G", launch("google-chrome-stable"))
      hl.bind("B", launch("brave"))
      hl.bind("S", launch("slack"))
      hl.bind("D", launch("${thunar}"))
      hl.bind("escape", hl.dsp.submap("reset"))
      hl.bind("catchall", hl.dsp.submap("reset"))
    end)
  '';
}
