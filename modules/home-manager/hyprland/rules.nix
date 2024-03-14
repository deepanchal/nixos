{ ... }: {
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
      "opaque, class:^(brave)$"
      "opaque, title:(Media viewer)"
      "opaque, title:(Firefox)"
      "opaque, title:(Slack)"
      "opaque, title:(telegram)"
      
      # only allow shadows for floating windows
      "noshadow, floating:0"
      "tile, title:Spotify"

      "idleinhibit focus, class:^(mpv)$"
      "idleinhibit focus,class:^(alacritty)$"
      "idleinhibit focus,class:^(wezterm)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      "float,class:udiskie"
      "float, title:(Media viewer)"

      "workspace special silent,class:^(pavucontrol)$"

      "opaque, class:^(imv)$"
      "opaque, class:^(mpv)$"
      "float, class:^(imv)$"
      "float, class:^(mpv)$"
      
      "opaque, class:(swappy)"
      "center 1, class:(swappy)"
      "stayfocused, class:(swappy)"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      "workspace 4, title:^(.*(Disc|WebC)ord.*)$"
      "workspace 2, class:^(firefox)$"
    ];
  };
}
