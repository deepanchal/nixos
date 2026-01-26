{...}: {
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "blur on, match:namespace ^(gtk-layer-shell)$"
      "ignore_alpha 0.5, match:namespace ^(gtk-layer-shell)$"
      "blur on, match:namespace ^(launcher)$"
      "ignore_alpha 0.5, match:namespace ^(launcher)$"
      "no_anim on, match:namespace launcher"
      "blur on, match:namespace notifications"
      "ignore_alpha 0.5, match:namespace notifications"
      # "blur on, match:namespace bar"
      "ignore_alpha 0.5, match:namespace bar"
      "no_anim on, match:namespace bar"
    ];
    windowrulev2 = [
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      ##########################################
      # FLOATING
      ##########################################
      "float on, match:class udiskie"
      "float on, match:title (Media viewer)"
      "float on, match:class ^(imv)$"
      "float on, match:class ^(mpv)$"
      "float on, match:class ^(org.gnome.Loupe)$"
      "no_shadow on, match:float false" # only allow shadows for floating windows
      "float on, match:class Rofi"
      "stay_focused on, match:class Rofi"
      "float on, match:class feh"
      "float on, match:class wlogout"
      "float on, match:class file_progress"
      "float on, match:class confirm"
      "float on, match:class dialog"
      "float on, match:class download"
      "float on, match:class notification"
      "float on, match:class error"
      "float on, match:class splash"
      "float on, match:class confirmreset"
      "float on, match:class ^(wdisplays)$"
      "size 70% 70%, match:class ^(wdisplays)$"
      # float blueman-manager
      "float on, match:class ^(.*blueman-.*)$"
      "center on, match:class ^(.*blueman-.*)$"
      "size 50% 60%, match:class ^(.*blueman-.*)$"
      "dim_around on, match:class ^(.*blueman-.*)$"
      # float network-manager-editor
      "float on, match:class ^(nm-connection-editor)$"
      "center on, match:class ^(nm-connection-editor)$"
      # float bitwarden
      "float on, match:title ^(.*Bitwarden.*)$"
      "center on, match:title ^(.*Bitwarden.*)$"
      # float pavucontrol
      "float on, match:class ^(.*pavucontrol.*)$"
      "center on, match:class ^(.*pavucontrol.*)$"
      "size 50% 60%, match:class ^(.*pavucontrol.*)$"
      "dim_around on, match:class ^(.*pavucontrol.*)$"
      # make Firefox PiP window floating and sticky
      "float on, match:title ^(Picture-in-Picture)$"
      "pin on, match:title ^(Picture-in-Picture)$"
      # thunar
      "opacity 0.8, match:class ^(thunar)$"
      "float on, match:class ^(thunar)$, match:title ^(File Operation Progress)$"
      "center on, match:class ^(thunar)$, match:title ^(File Operation Progress)$"
      "pin on, match:class ^(thunar)$, match:title ^(File Operation Progress)$"
      "size 400 100, match:class ^(thunar)$, match:title ^(File Operation Progress)$"
      "move 100%-w-25 5%, match:class ^(thunar)$, match:title ^(File Operation Progress)$"
      "center on, match:class ^(thunar)$, match:title ^(Attention|Error)$"
      # portal / polkit
      "float on, match:class ^(xdg-desktop-portal-gtk)$"
      "center on, match:class ^(xdg-desktop-portal-gtk)$"
      "size 50% 50%, match:class ^(xdg-desktop-portal-gtk)$"
      "dim_around on, match:class ^(xdg-desktop-portal-gtk)$"
      "dim_around on, match:class ^(polkit-gnome-authentication-agent-1)$"
      "float on, match:class ^(polkit-gnome-authentication-agent-1)$"
      # hyprland share picker
      "float on, match:title ^(MainPicker)$"
      "center on, match:title ^(MainPicker)$"
      "size 50% 50%, match:class ^(MainPicker)$"
      # JetBrains IDEs w/ wayland support. See: jetbrains module
      "no_anim on, match:class ^(jetbrains-.*)$"
      "no_blur on, match:class ^(jetbrains-.*)$"
      "no_shadow on, match:class ^(jetbrains-.*)$"
      "border_size 0, match:class ^(jetbrains-.*)$"
      "rounding 0, match:class ^(jetbrains-.*)$"
      "opacity 1, match:class ^(jetbrains-.*)$"
      # spotify
      "opacity 0.8, match:initialTitle ^(Spotify.*)$"
      # clipse
      "float on, match:class (clipse)"
      "center on, match:class (clipse)"
      "size 40% 64%, match:class (clipse)"
      "no_anim on, match:class (clipse)"

      ##########################################
      # OPAQUE
      ##########################################
      "opaque on, match:class ^(brave)$"
      "opaque on, match:title (Media viewer)"
      "opaque on, match:title (Firefox)"
      "opaque on, match:title (Slack)"
      "opaque on, match:title (telegram)"
      "opaque on, match:class ^(imv)$"
      "opaque on, match:class ^(mpv)$"
      "opaque on, match:class ^(org.gnome.Loupe)$"
      "opaque on, match:class ^(com.gabm.satty)$"
      "center on, match:class ^(com.gabm.satty)$"
      "size 80% 80%, match:class ^(com.gabm.satty)$"

      ##########################################
      # IDLEINHIBIT
      ##########################################
      "idle_inhibit focus, match:class ^(mpv)$"
      "idle_inhibit focus, match:class ^(alacritty)$"
      "idle_inhibit focus, match:class ^(wezterm)$"
      "idle_inhibit fullscreen, match:class ^(firefox)$"

      ##########################################
      # WORKSPACE CONFIG
      ##########################################
      # throw sharing indicators away
      "workspace special silent, match:title ^(Firefox — Sharing Indicator)$"
      "workspace special silent, match:title ^.*(Sharing Indicator)$"
      "workspace special silent, match:title ^(.*is sharing (your screen|a window)\\.)$"

      # IDE
      "workspace 1, match:class ^(Code)$"
      "workspace 1, match:class ^(jetbrains-studio)$" # android studio
      "workspace 1, match:class ^(jetbrains-studio)$, match:title ^(Conflicts)$" # android studio

      # Browsing
      # "workspace 2, match:class ^(firefox)$"
      # "workspace 2, match:class ^(brave)$"

      # Terminal
      # "workspace 3, match:class ^(wezterm)$"
      # "workspace 3, match:class ^(alacritty)$"
      # "workspace 3, match:class ^(kitty)$"

      # Messaging
      # "workspace 5 silent, match:class ^(Slack)$"
      # "workspace 5 silent, match:class ^(org.telegram.desktop)$"
      # "workspace 5 silent, match:class ^(discord)$"
      # "workspace 5 silent, match:class ^(zoom)$"
      # "workspace 5 silent, match:class ^(teams-for-linux)$"

      # "workspace special silent, match:class ^(.*pavucontrol.*)$"
    ];
  };
}
