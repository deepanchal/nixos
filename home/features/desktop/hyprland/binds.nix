{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  swayosd = "${pkgs.swayosd}/bin/swayosd-client";
  swaylock = "${pkgs.swaylock}/bin/swaylock";
  cliphist = "${pkgs.cliphist}/bin/cliphist";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  wezterm = "${pkgs.wezterm}/bin/wezterm";
  alacritty = "${pkgs.alacritty}/bin/alacritty";
  asusctl = "${pkgs.asusctl}/bin/asusctl";
  rog-control-center = "${pkgs.asusctl}/bin/rog-control-center";
  firefox = "${pkgs.firefox}/bin/firefox";
  brave = "${pkgs.brave}/bin/brave";
  thunar = "thunar";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";

  mainMod = "SUPER";
  altMod = "ALT";
  ctrlMod = "CTRL";
  shiftMod = "SHIFT";
  modshift = "${mainMod}${shiftMod}";
  ctrlAlt = "${ctrlMod}${altMod}";

  leftKey = "H";
  rightKey = "L";
  upKey = "K";
  downKey = "J";

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
        "${mainMod}, ${ws}, workspace, ${toString (x + 1)}"
        "${modshift}, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "${altMod}, SPACE, exec, run-as-service $(anyrun)"
        "${mainMod}, RETURN, exec, alacritty msg create-window || alacritty"
        "${modshift}, RETURN, exec, ${wezterm}"
        # "${mainMod}, B, exec, ${firefox}"
        # "${modshift}, B, exec, ${brave}"
        "${mainMod}, E, exec, ${thunar}"

        "${modshift}, Q, killactive,"
        "${mainMod}, P, pseudo"

        # backtick = GRAVE
        "${mainMod}, GRAVE, togglespecialworkspace, procs"
        "${modshift}, GRAVE, movetoworkspace, special:procs"

        "${mainMod}, MINUS, togglespecialworkspace, scratchpad"
        "${modshift}, MINUS, movetoworkspace, special:scratchpad"

        "${mainMod}, EQUAL, togglespecialworkspace, notes"
        "${modshift}, EQUAL, movetoworkspace, special:notes"

        "${mainMod}, BACKSPACE, togglespecialworkspace, magic"
        "${modshift}, BACKSPACE, movetoworkspace, special:magic"

        # Using workaround script
        "${mainMod}, ${leftKey}, movefocus, l"
        "${mainMod}, ${downKey}, movefocus, d"
        "${mainMod}, ${upKey}, movefocus, u"
        "${mainMod}, ${rightKey}, movefocus, r"

        "${modshift}, ${leftKey}, movewindow, l"
        "${modshift}, ${downKey}, movewindow, d"
        "${modshift}, ${upKey}, movewindow, u"
        "${modshift}, ${rightKey}, movewindow, r"

        # "${modshift}, ${leftKey}, swapwindow, l"
        # "${modshift}, ${downKey}, swapwindow, d"
        # "${modshift}, ${upKey}, swapwindow, u"
        # "${modshift}, ${rightKey}, swapwindow, r"

        # Grouped (tabbed) windows
        "${mainMod}, G, togglegroup"
        "${mainMod}, TAB, changegroupactive, f"
        "${modshift}, TAB, changegroupactive, b"

        # "${mainMod}, W, togglegroup," # group focused window
        # "${mainMod}, W, makegroup, tab"
        # "${mainMod}, V, makegroup, v"
        # "${mainMod}, B, makegroup, h"

        "${mainMod}, F, fullscreen," # fullscreen focused window
        "${mainMod}, P, pseudo,"
        "${modshift}, R, exec, hyprctl reload && notify-send 'Reloaded hyprland'" # toggle floating for the focused window
        "${modshift}, SPACE, togglefloating," # toggle floating for the focused window
        "${altMod}, C, exec, ${cliphist} list | anyrun-dmenu | ${cliphist} decode | ${wl-copy}"
        "${altMod}, W, exec, wallpaper-chooser"
        "${mainMod}, PERIOD, exec, anyrun-symbols | ${wl-copy}" # not working atm, anyrun can't copy to clipboard

        # https://github.com/altdesktop/playerctl?tab=readme-ov-file#selecting-players-to-control
        "${modshift}, M, exec, ${playerctl} -p spotify play-pause"
        "${modshift}, N, exec, ${playerctl} -p spotify next"
        "${modshift}, B, exec, ${playerctl} -p spotify previous"

        # workspace controls
        "${modshift}, right, movetoworkspace, +1" # move focused window to the next ws
        "${modshift}, left, movetoworkspace, -1" # move focused window to the previous ws
        "${mainMod}, mouse_down, workspace, e+1" # move to the next ws
        "${mainMod}, mouse_up, workspace, e-1" # move to the previous ws

        # screenshot
        ", F6, exec, grimblast --notify save area - | satty -f -"
        "CTRL, F6, exec, grimblast --notify save output - | satty -f -"

        "${ctrlAlt}, L, exec, sleep 0.5s && swaylock"

        # capture current hyprctl clients for debugging
        "${mainMod}, Z, exec, hyprctl clients -j | jq > /tmp/hypr-clients.json && notify-send 'Saved current clients to /tmp/hypr-clients.json'"

        ",Caps_Lock, exec, sleep 0.1 && ${swayosd} --caps-lock"
        ",Num_Lock, exec, sleep 0.1 && ${swayosd} --num-lock"

        # ",XF86Bluetooth, exec, bcn"
      ]
      ++ workspaces;

    bindm = [
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
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

      "SUPERALT, ${rightKey}, resizeactive, 80 0"
      "SUPERALT, ${leftKey}, resizeactive, -80 0"
    ];
    # binds that are locked, a.k.a will activate even while an input inhibitor is active
    bindl = [
      # media controls
      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioPrev, exec, ${playerctl} previous"
      ", XF86AudioNext, exec, ${playerctl} next"
    ];
  };
  wayland.windowManager.hyprland.extraConfig = ''
    # Resize Mode
    bind = ${mainMod}, R, submap, resize
    submap = resize
    binde = , ${leftKey}, resizeactive, 40 0
    binde = , ${rightKey}, resizeactive, -40 0
    binde = , ${upKey}, resizeactive, 0 -40
    binde = , ${downKey}, resizeactive, 0 40
    bind = , escape, submap, reset
    bind = , catchall, submap, reset # https://wiki.hyprland.org/Configuring/Binds/#catch-all
    submap = reset

    # Launch Mode
    bind = ${mainMod}, o, submap, launch
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
