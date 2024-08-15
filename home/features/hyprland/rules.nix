{...}: {
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "blur, ^(gtk-layer-shell)$"
      "blur, ^(launcher)$"
      "ignorezero, ^(gtk-layer-shell)$"
      "ignorezero, ^(launcher)$"
      "blur, notifications"
      "ignorezero, notifications"
      "blur, bar"
      "ignorezero, bar"
      "ignorezero, ^(gtk-layer-shell|anyrun)$"
      "blur, ^(gtk-layer-shell|anyrun)$"
      "noanim, launcher"
      "noanim, bar"
    ];
    windowrulev2 = [
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      ##########################################
      # FLOATING
      ##########################################
      "float,class:udiskie"
      "float, title:(Media viewer)"
      "float, class:^(imv)$"
      "float, class:^(mpv)$"
      "noshadow, floating:0" # only allow shadows for floating windows
      "float, class:Rofi"
      "stayfocused, class:Rofi"
      "float, class:feh"
      "float, class:wlogout"
      "float, class:file_progress"
      "float, class:confirm"
      "float, class:dialog"
      "float, class:download"
      "float, class:notification"
      "float, class:error"
      "float, class:splash"
      "float, class:confirmreset"
      "float, class:^(wdisplays)$"
      "size 1100 600, class:^(wdisplays)$"
      # float blueman-manager
      "float, class:^(.*blueman-.*)$"
      "center, class:^(.*blueman-.*)$"
      # float network-manager-editor
      "float, class:^(nm-connection-editor)$"
      "center, class:^(nm-connection-editor)$"
      # float pavucontrol
      "float, class:^(pavucontrol)$"
      "center, class:^(pavucontrol)$"
      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      # thunar file operation progress
      "float, class:^(thunar)$,title:^(File Operation Progress)$"
      "size 800 600, class:^(thunar)$,title:^(File Operation Progress)$"
      "move 78% 6%, class:^(thunar)$,title:^(File Operation Progress)$"
      "pin, class:^(thunar)$,title:^(File Operation Progress)$"
      # fix xwayland apps
      "rounding 0, xwayland:1, floating:1"
      "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
      "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
      # portal / polkit
      "float, class:^(xdg-desktop-portal-gtk)$"
      "center, class:^(xdg-desktop-portal-gtk)$"
      "size 900 500, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
      "float, class:^(polkit-gnome-authentication-agent-1)$"
      # hyprland share picker
      "float, title:^(MainPicker)$"
      "center, title:^(MainPicker)$"

      ##########################################
      # OPAQUE
      ##########################################
      "opaque, class:^(brave)$"
      "opaque, title:(Media viewer)"
      "opaque, title:(Firefox)"
      "opaque, title:(Slack)"
      "opaque, title:(telegram)"
      "opaque, class:^(imv)$"
      "opaque, class:^(mpv)$"
      "opaque, class:(swappy)"
      "center 1, class:(swappy)"
      "stayfocused, class:(swappy)"

      "tile, title:Spotify"

      ##########################################
      # IDLEINHIBIT
      ##########################################
      "idleinhibit focus, class:^(mpv)$"
      "idleinhibit focus,class:^(alacritty)$"
      "idleinhibit focus,class:^(wezterm)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      ##########################################
      # WORKSPACE CONFIG
      ##########################################
      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^.*(Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # IDE
      # "workspace 1, class:^(Code)$"

      # Browsing
      # "workspace 2, class:^(firefox)$"
      # "workspace 2, class:^(brave)$"

      # Terminal
      # "workspace 3, class:^(wezterm)$"
      # "workspace 3, class:^(alacritty)$"
      # "workspace 3, class:^(kitty)$"

      # Messaging
      # "workspace 5 silent, class:^(Slack)$"
      # "workspace 5 silent, class:^(org.telegram.desktop)$"
      # "workspace 5 silent, class:^(discord)$"
      # "workspace 5 silent, class:^(zoom)$"
      # "workspace 5 silent, class:^(teams-for-linux)$"

      # "workspace special silent,class:^(pavucontrol)$"
    ];
  };
}
