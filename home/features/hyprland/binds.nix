{
  config,
  lib,
  pkgs,
  ...
}: let
  rofi = "${pkgs.rofi}/bin/rofi";
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

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10} (stolen from fufie)
  workspaces = builtins.concatLists (builtins.genList
    (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "${mainMod}, ${ws}, workspace, ${toString (x + 1)}"
        "${mainMod} SHIFT, ${ws}, hy3:movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        # "${mainMod}, SPACE, exec, run-as-service $(tofi-drun)"
        "${altMod}, SPACE, exec, run-as-service $(${rofi} -show drun)"
        "${mainMod}, RETURN, exec, ${wezterm}"
        "${modshift}, RETURN, exec, ${alacritty}"
        # "${mainMod}, B, exec, ${firefox}"
        # "${modshift}, B, exec, ${brave}"
        "${mainMod}, E, exec, ${thunar}"

        "${modshift}, Q, hy3:killactive,"
        "${mainMod}, P, pseudo"

        # # will switch to a submap called resize
        # bind=$mainMod,R,submap,resize
        #
        # # will start a submap called "resize"
        # submap=resize
        #
        # # sets repeatable binds for resizing the active window
        # binde=,j,resizeactive,-10 0
        # binde=,k,resizeactive,0 10
        # binde=,l,resizeactive,0 -10
        # binde=,SEMICOLON,resizeactive,10 0
        #
        # # use reset to go back to the global submap
        # bind=,escape,submap,reset
        #
        # # will reset the submap, meaning end the current one and return to the global one
        # submap=reset

        "${mainMod}, MINUS, togglespecialworkspace, magic"
        "${modshift}, MINUS, movetoworkspace, special:magic"

        # Not fully working with hy3 -> https://github.com/outfoxxed/hy3/issues/2
        # "${mainMod}, ${leftKey}, hy3:movefocus, l"
        # "${mainMod}, ${downKey}, hy3:movefocus, d"
        # "${mainMod}, ${upKey}, hy3:movefocus, u"
        # "${mainMod}, ${rightKey}, hy3:movefocus, r"

        # Using workaround script
        "${mainMod}, ${leftKey}, exec, hy3-movefocus l"
        "${mainMod}, ${downKey}, exec, hy3-movefocus d"
        "${mainMod}, ${upKey}, exec, hy3-movefocus u"
        "${mainMod}, ${rightKey}, exec, hy3-movefocus r"

        "${modshift}, ${leftKey}, hy3:movewindow, l"
        "${modshift}, ${downKey}, hy3:movewindow, d"
        "${modshift}, ${upKey}, hy3:movewindow, u"
        "${modshift}, ${rightKey}, hy3:movewindow, r"

        "${mainMod}, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))" # toggle no_gaps_when_only
        # "${mainMod}, W, togglegroup," # group focused window
        "${mainMod}, W, hy3:makegroup, tab, force_empheral"
        "${mainMod}, V, hy3:makegroup, v, force_empheral"
        "${mainMod}, B, hy3:makegroup, h, force_empheral"

        "${mainMod}, F, fullscreen," # fullscreen focused window
        "${mainMod}, P, pseudo,"
        # "${modshift}, G, hy3:changegroupactive," # switch within the active group
        "${modshift}, SPACE, togglefloating," # toggle floating for the focused window
        "${altMod}, C, exec, ${cliphist} list | ${rofi} -dmenu | ${cliphist} decode | ${wl-copy}"

        "${modshift}, M, exec, ${playerctl} play-pause"
        "${modshift}, N, exec, ${playerctl} next"
        "${modshift}, B, exec, ${playerctl} previous"

        # workspace controls
        "${modshift}, right, hy3:movetoworkspace, +1" # move focused window to the next ws
        "${modshift}, left, hy3:movetoworkspace, -1" # move focused window to the previous ws
        "${mainMod}, mouse_down, workspace, e+1" # move to the next ws
        "${mainMod}, mouse_up, workspace, e-1" # move to the previous ws

        "${mainMod},Print,exec, pauseshot"
        ",Print,exec, grim - | ${wl-copy}"

        # "${mainMod},Period,exec, tofi-emoji"

        "${ctrlAlt},L,exec,${hyprlock}"

        # ",XF86Bluetooth, exec, bcn"
      ]
      ++ workspaces;

    bindm = [
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
    ];

    binde = [
      ",XF86AudioRaiseVolume, exec, ${swayosd} --output-volume 5"
      ",XF86AudioLowerVolume, exec, ${swayosd} --output-volume -5"
      ",XF86AudioMute, exec, ${swayosd} --output-volume mute-toggle"
      ",XF86AudioMicMute, exec, ${swayosd} --input-volume mute-toggle"
      ",XF86MonBrightnessUp, exec, ${swayosd} --brightness 10"
      ",XF86MonBrightnessDown, exec, ${swayosd} --brightness -10"
      ",Caps_Lock, exec, ${swayosd} --caps-lock"

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
}
