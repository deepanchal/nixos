{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  swayosd = "${pkgs.swayosd}/bin/swayosd-client";
  cliphist = "${pkgs.cliphist}/bin/cliphist";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  wezterm = "${pkgs.wezterm}/bin/wezterm";
  asusctl = "${pkgs.asusctl}/bin/asusctl";
  rog-control-center = "${pkgs.asusctl}/bin/rog-control-center";
  thunar = "thunar";
  playerctl = "${pkgs.playerctl}/bin/playerctl";

  # From https://github.com/fufexan/dotfiles/blob/41612095fbebb01a0f2fe0980ec507cf02196392/home/programs/wayland/hyprland/binds.nix
  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (builtins.genList
    (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$modShift, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  wayland.windowManager.hyprland.settings = {
    # https://wiki.hyprland.org/Configuring/Binds
    # For uncommon syms/bindings, see https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h
    bind =
      [
        "$mod2, SPACE, exec, run-as-service $(anyrun)"
        "$mod, RETURN, exec, alacritty msg create-window || alacritty"
        "$modShift, RETURN, exec, ${wezterm}"
        # "$mod, B, exec, ${firefox}"
        # "$modShift, B, exec, ${brave}"
        "$mod, E, exec, ${thunar}"

        "$modShift, Q, killactive,"
        "$mod, P, pseudo"

        # backtick = GRAVE
        "$mod, GRAVE, togglespecialworkspace, notes"
        "$modShift, GRAVE, movetoworkspace, special:notes"

        "$mod, MINUS, togglespecialworkspace, scratchpad"
        "$modShift, MINUS, movetoworkspace, special:scratchpad"

        "$mod, EQUAL, togglespecialworkspace, procs"
        "$modShift, EQUAL, movetoworkspace, special:procs"

        "$mod, BACKSPACE, togglespecialworkspace, magic"
        "$modShift, BACKSPACE, movetoworkspace, special:magic"

        # Using workaround script
        "$mod, $left, movefocus, l"
        "$mod, $down, movefocus, d"
        "$mod, $up, movefocus, u"
        "$mod, $right, movefocus, r"

        "$modShift, $left, movewindow, l"
        "$modShift, $down, movewindow, d"
        "$modShift, $up, movewindow, u"
        "$modShift, $right, movewindow, r"

        # "$modShift, $left, swapwindow, l"
        # "$modShift, $down, swapwindow, d"
        # "$modShift, $up, swapwindow, u"
        # "$modShift, $right, swapwindow, r"

        # Grouped (tabbed) windows
        "$mod, G, togglegroup"
        "$mod, TAB, changegroupactive, f"
        "$modShift, TAB, changegroupactive, b"

        # "$mod, W, togglegroup," # group focused window
        # "$mod, W, makegroup, tab"
        # "$mod, V, makegroup, v"
        # "$mod, B, makegroup, h"

        # Set fullscreen mode without notifying the client that it has been fullscreened (Useful for brave/firefox hiding tabs on fullscreen)
        "$mod, F, fullscreenstate, 2 -1"
        # Maintain the current fullscreen state and notify the client that it has been fullscreened
        "$modShift, F, fullscreenstate, -1 2"

        "$mod, P, pseudo,"
        "$modShift, R, exec, hyprctl reload && notify-send 'Reloaded hyprland'" # toggle floating for the focused window
        "$modShift, SPACE, togglefloating," # toggle floating for the focused window
        "$mod2, C, exec, ${cliphist} list | anyrun-dmenu | ${cliphist} decode | ${wl-copy}"
        "$mod2, W, exec, wallpaper-chooser"
        "$mod, PERIOD, exec, anyrun-symbols | ${wl-copy}" # not working atm, anyrun can't copy to clipboard

        # https://github.com/altdesktop/playerctl?tab=readme-ov-file#selecting-players-to-control
        "$modShift, M, exec, ${playerctl} -p cider play-pause"
        "$modShift, N, exec, ${playerctl} -p cider next"
        "$modShift, B, exec, ${playerctl} -p cider previous"

        # workspace controls
        "$modShift, right, movetoworkspace, +1" # move focused window to the next ws
        "$modShift, left, movetoworkspace, -1" # move focused window to the previous ws
        "$mod, mouse_down, workspace, e+1" # move to the next ws
        "$mod, mouse_up, workspace, e-1" # move to the previous ws

        # screenshot
        ", F6, exec, grimblast --notify save area - | satty -f -"
        "CTRL, F6, exec, grimblast --notify save output - | satty -f -"

        "CTRL_ALT, L, exec, sleep 0.1 && hyprlock"

        # capture current hyprctl clients for debugging
        "$mod, Z, exec, hyprctl clients -j | jq > /tmp/hypr-clients.json && notify-send 'Saved current clients to /tmp/hypr-clients.json'"

        ",Caps_Lock, exec, sleep 0.1 && ${swayosd} --caps-lock"
        ",Num_Lock, exec, sleep 0.1 && ${swayosd} --num-lock"

        # ",XF86Bluetooth, exec, bcn"
      ]
      ++ workspaces;

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # https://wiki.hyprland.org/Configuring/Binds/#bind-flags
    binde = [
      ",XF86AudioRaiseVolume, exec, ${swayosd} --output-volume +5 && play-vol-change-sound"
      ",XF86AudioLowerVolume, exec, ${swayosd} --output-volume -5 && play-vol-change-sound"
      ",XF86AudioMute, exec, ${swayosd} --output-volume mute-toggle"
      ",XF86AudioMicMute, exec, ${swayosd} --input-volume mute-toggle"
      ",XF86MonBrightnessUp, exec, ${swayosd} --brightness +5"
      ",XF86MonBrightnessDown, exec, ${swayosd} --brightness -5"

      ",XF86Launch1, exec, ${rog-control-center}"
      ",XF86Launch3, exec, ${asusctl} led-mode -n"
      ",XF86Launch4, exec, ${asusctl} profile -n"

      "$mod_ALT, $right, resizeactive, 80 0"
      "$mod_ALT, $left, resizeactive, -80 0"
    ];
    # binds that are locked, a.k.a will activate even while an input inhibitor is active

    bindl = [
      # https://wiki.hyprland.org/Configuring/Binds/#switches
      ", switch:Lid Switch, exec, hyprlock"
      # media controls
      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioPrev, exec, ${playerctl} previous"
      ", XF86AudioNext, exec, ${playerctl} next"
    ];
  };
  wayland.windowManager.hyprland.extraConfig = ''
    # Resize Mode
    bind = $mod, R, submap, resize
    submap = resize
    binde = , $left, resizeactive, 40 0
    binde = , $right, resizeactive, -40 0
    binde = , $up, resizeactive, 0 -40
    binde = , $down, resizeactive, 0 40
    bind = , escape, submap, reset
    bind = , catchall, submap, reset # https://wiki.hyprland.org/Configuring/Binds/#catch-all
    submap = reset

    # Launch Mode
    bind = $mod, o, submap, launch
    submap = launch
    bind = , F, exec, firefox
    bind = , F, submap, reset

    bind = , G, exec, google-chrome-stable
    bind = , G, submap, reset

    bind = , B, exec, brave
    bind = , B, submap, reset

    bind = , S, exec, slack
    bind = , S, submap, reset

    bind = , D, exec, thunar
    bind = , D, submap, reset

    bind = , escape, submap, reset
    bind = , catchall, submap, reset # https://wiki.hyprland.org/Configuring/Binds/#catch-all
    submap = reset
  '';
}
