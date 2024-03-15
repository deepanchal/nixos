{ config, lib, ... }:
let
  mainMod = "SUPER";
  altMod = "ALT";
  modshift = "${mainMod}SHIFT";

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10} (stolen from fufie)
  workspaces = builtins.concatLists (builtins.genList
    (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "${mainMod}, ${ws}, workspace, ${toString (x + 1)}"
        "${mainMod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in
{
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        # "${mainMod}, SPACE, exec, run-as-service $(tofi-drun)"
        "${altMod}, SPACE, exec, run-as-service $(rofi -show drun)"
        "${mainMod}, RETURN, exec, alacritty"
        "${modshift}, RETURN, exec, wezterm"
        "${mainMod}, B, exec, firefox"
        # "${modshift}, B, exec, brave"
        "${mainMod}, E, exec, thunar"

        "${mainMod}, MINUS, killactive"
        "${modshift}, Q, killactive,"
        "${mainMod}, P, pseudo"

        # "${mainMod},H,movefocus,l"
        # "${mainMod},L,movefocus,r"
        # "${mainMod},K,movefocus,u"
        # "${mainMod},J,movefocus,d"

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

        "${mainMod}, S, togglespecialworkspace, magic"
        "${modshift}, S, movetoworkspace, special:magic"

        "${mainMod}, J, movefocus, l"
        "${mainMod}, K, movefocus, d"
        "${mainMod}, L, movefocus, u"
        "${mainMod}, SEMICOLON, movefocus, r"

        "${modshift}, J, movewindow, l"
        "${modshift}, K, movewindow, d"
        "${modshift}, L, movewindow, u"
        "${modshift}, SEMICOLON, movewindow, r"

        "${mainMod}, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))" # toggle no_gaps_when_only
        "${mainMod}, T, togglegroup," # group focused window
        "${mainMod}, F, fullscreen," # fullscreen focused window
        "${mainMod}, P, pseudo,"
        "${modshift}, G, changegroupactive," # switch within the active group
        "${modshift}, SPACE, togglefloating," # toggle floating for the focused window
        "${mainMod}, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        "${modshift}, M, exec, playerctl play-pause"
        "${modshift}, N, exec, playerctl next"
        "${modshift}, B, exec, playerctl previous"

        # workspace controls
        "${modshift}, right, movetoworkspace, +1" # move focused window to the next ws
        "${modshift}, left, movetoworkspace, -1" # move focused window to the previous ws
        "${mainMod}, mouse_down, workspace, e+1" # move to the next ws
        "${mainMod}, mouse_up, workspace, e-1" # move to the previous ws

        "${mainMod},Print,exec, pauseshot"
        ",Print,exec, grim - | wl-copy"
        "${modshift},O,exec,wl-ocr"

        "${mainMod},Period,exec, tofi-emoji"

        "${modshift},L,exec,hyprlock"

        ",XF86Bluetooth, exec, bcn"
      ]
      ++ workspaces;

    bindm = [
      "${mainMod}, mouse:272, movewindow"
      "${mainMod}, mouse:273, resizewindow"
    ];

    binde = [
      ",XF86AudioRaiseVolume, exec, volumectl -u up"
      ",XF86AudioLowerVolume, exec, volumectl -u down"
      ",XF86AudioMute, exec, volumectl toggle-mute"
      ",XF86AudioMicMute, exec, volumectl -m toggle-mute"
      # ",XF86AudioMicMute, exec, micmute"
      ",XF86MonBrightnessUp, exec, lightctl up"
      ",XF86MonBrightnessDown, exec, lightctl down"

      "SUPERALT, SEMICOLON, resizeactive, 80 0"
      "SUPERALT, J, resizeactive, -80 0"
    ];
    # binds that are locked, a.k.a will activate even while an input inhibitor is active
    bindl = [
      # media controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
    ];
  };
}
