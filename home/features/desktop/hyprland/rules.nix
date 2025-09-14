{...}: {
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "blur, ^(gtk-layer-shell)$"
      "blur, ^(launcher)$"
      "ignorezero, ^(gtk-layer-shell)$"
      "ignorezero, ^(launcher)$"
      "blur, notifications"
      "ignorezero, notifications"
      # "blur, bar"
      "ignorezero, bar"
      "ignorezero, ^(gtk-layer-shell)$"
      "blur, ^(gtk-layer-shell)$"
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
      "float, class:^(org.gnome.Loupe)$"
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
      "size 70% 70%, class:^(wdisplays)$"
      # float blueman-manager
      "float, class:^(.*blueman-.*)$"
      "center, class:^(.*blueman-.*)$"
      "size 50% 60%, class:^(.*blueman-.*)$"
      "dimaround, class:^(.*blueman-.*)$"
      # float network-manager-editor
      "float, class:^(nm-connection-editor)$"
      "center, class:^(nm-connection-editor)$"
      # float bitwarden
      "float, title:^(.*Bitwarden.*)$"
      "center, title:^(.*Bitwarden.*)$"
      # float pavucontrol
      "float, class:^(.*pavucontrol.*)$"
      "center, class:^(.*pavucontrol.*)$"
      "size 50% 60%, class:^(.*pavucontrol.*)$"
      "dimaround, class:^(.*pavucontrol.*)$"
      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      # thunar
      "opacity 0.8, class:^(thunar)$"
      "float, class:^(thunar)$,title:^(File Operation Progress)$"
      "center, class:^(thunar)$,title:^(File Operation Progress)$"
      "pin, class:^(thunar)$,title:^(File Operation Progress)$"
      "size 400 100, class:^(thunar)$,title:^(File Operation Progress)$"
      "move 100%-w-25 5%, class:^(thunar)$,title:^(File Operation Progress)$"
      "center, class:^(thunar)$,title:^(Attention|Error)$"
      # portal / polkit
      "float, class:^(xdg-desktop-portal-gtk)$"
      "center, class:^(xdg-desktop-portal-gtk)$"
      "size 50% 50%, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
      "float, class:^(polkit-gnome-authentication-agent-1)$"
      # hyprland share picker
      "float, title:^(MainPicker)$"
      "center, title:^(MainPicker)$"
      "size 50% 50%, class:^(MainPicker)$"
      # JetBrains IDEs w/ wayland support. See: jetbrains module
      "noanim, class:^(jetbrains-.*)$"
      "noblur, class:^(jetbrains-.*)$"
      "noshadow, class:^(jetbrains-.*)$"
      "noborder, class:^(jetbrains-.*)$"
      "norounding, class:^(jetbrains-.*)$"
      "opacity 1, class:^(jetbrains-.*)$"
      # spotify
      "opacity 0.8, initialTitle:^(Spotify.*)$"
      # clipse
      "float, class:(clipse)"
      "center, class:(clipse)"
      "size 40% 64%, class:(clipse)"
      "noanim, class:(clipse)"

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
      "opaque, class:^(org.gnome.Loupe)$"
      "opaque, class:^(com.gabm.satty)$"
      "center 1, class:^(com.gabm.satty)$"
      "size 80% 80%, class:^(com.gabm.satty)$"

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
      "workspace 1, class:^(Code)$"
      "workspace 1, class:^(jetbrains-studio)$" # android studio
      "workspace 1, class:^(jetbrains-studio), title:^(Conflicts)$" # android studio

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

      # "workspace special silent,class:^(.*pavucontrol.*)$"
    ];
  };
}
