{...}: let
  blurredLayers = ["^(gtk-layer-shell)$" "^(launcher)$" "notifications"];
in {
  wayland.windowManager.hyprland.settings = {
    # https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
    layer_rule =
      map (namespace: {
        match = {inherit namespace;};
        blur = true;
        ignore_alpha = 0.5;
      })
      blurredLayers
      ++ [
        {
          match.namespace = "launcher";
          no_anim = true;
        }
        {
          match.namespace = "bar";
          ignore_alpha = 0.5;
          no_anim = true;
        }
      ];

    # https://wiki.hypr.land/Configuring/Basics/Window-Rules/
    window_rule = [
      ##########################################
      # FLOATING
      ##########################################
      {match.class = "udiskie"; float = true;}
      {match.title = "(Media viewer)"; float = true;}
      {match.class = "^(imv)$"; float = true;}
      {match.class = "^(mpv)$"; float = true;}
      {match.class = "^(org.gnome.Loupe)$"; float = true;}
      {match.float = false; no_shadow = true;} # only allow shadows for floating windows
      {match.class = "Rofi"; float = true; stay_focused = true;}
      {match.class = "feh"; float = true;}
      {match.class = "wlogout"; float = true;}
      {match.class = "file_progress"; float = true;}
      {match.class = "confirm"; float = true;}
      {match.class = "dialog"; float = true;}
      {match.class = "download"; float = true;}
      {match.class = "notification"; float = true;}
      {match.class = "error"; float = true;}
      {match.class = "splash"; float = true;}
      {match.class = "confirmreset"; float = true;}
      {
        match.class = "^(wdisplays)$";
        float = true;
        size = ["monitor_w*0.7" "monitor_h*0.7"];
      }
      # float blueman-manager
      {
        match.class = "^(.*blueman-.*)$";
        float = true;
        center = true;
        size = ["monitor_w*0.5" "monitor_h*0.6"];
        dim_around = true;
      }
      # float network-manager-editor
      {
        match.class = "^(nm-connection-editor)$";
        float = true;
        center = true;
      }
      # float bitwarden
      {
        match.title = "^(.*Bitwarden.*)$";
        float = true;
        center = true;
      }
      # float pavucontrol
      {
        match.class = "^(.*pavucontrol.*)$";
        float = true;
        center = true;
        size = ["monitor_w*0.5" "monitor_h*0.6"];
        dim_around = true;
      }
      # make Firefox PiP window floating and sticky
      {
        match.title = "^(Picture-in-Picture)$";
        float = true;
        pin = true;
      }
      # thunar
      {match.class = "^(thunar)$"; opacity = "0.8";}
      {
        match = {
          class = "^(thunar)$";
          title = "^(File Operation Progress)$";
        };
        float = true;
        center = true;
        pin = true;
        size = [400 100];
        move = ["monitor_w-window_w-25" "monitor_h*0.05"];
      }
      {
        match = {
          class = "^(thunar)$";
          title = "^(Attention|Error)$";
        };
        center = true;
      }
      # portal / polkit
      {
        match.class = "^(xdg-desktop-portal-gtk)$";
        float = true;
        center = true;
        size = ["monitor_w*0.5" "monitor_h*0.5"];
        dim_around = true;
      }
      {
        match.class = "^(polkit-gnome-authentication-agent-1)$";
        float = true;
        dim_around = true;
      }
      # hyprland share picker
      {
        match.title = "^(MainPicker)$";
        float = true;
        center = true;
      }
      {
        match.class = "^(MainPicker)$";
        size = ["monitor_w*0.5" "monitor_h*0.5"];
      }
      # JetBrains IDEs w/ wayland support. See: jetbrains module
      {
        match.class = "^(jetbrains-.*)$";
        no_anim = true;
        no_blur = true;
        no_shadow = true;
        border_size = 0;
        rounding = 0;
        opacity = "1";
      }
      # spotify
      {match.initial_title = "^(Spotify.*)$"; opacity = "0.8";}
      # clipse
      {
        match.class = "(clipse)";
        float = true;
        center = true;
        size = ["monitor_w*0.4" "monitor_h*0.64"];
        no_anim = true;
      }

      ##########################################
      # OPAQUE
      ##########################################
      {match.class = "^(brave)$"; opaque = true;}
      {match.title = "(Media viewer)"; opaque = true;}
      {match.title = "(Firefox)"; opaque = true;}
      {match.title = "(Slack)"; opaque = true;}
      {match.title = "(telegram)"; opaque = true;}
      {match.class = "^(imv)$"; opaque = true;}
      {match.class = "^(mpv)$"; opaque = true;}
      {match.class = "^(org.gnome.Loupe)$"; opaque = true;}
      {
        match.class = "^(swappy)$";
        opaque = true;
        center = true;
        size = ["monitor_w*0.8" "monitor_h*0.8"];
      }

      ##########################################
      # IDLEINHIBIT
      ##########################################
      {match.class = "^(mpv)$"; idle_inhibit = "focus";}
      {match.class = "^(alacritty)$"; idle_inhibit = "focus";}
      {match.class = "^(wezterm)$"; idle_inhibit = "focus";}
      {match.class = "^(firefox)$"; idle_inhibit = "fullscreen";}

      ##########################################
      # WORKSPACE CONFIG
      ##########################################
      # throw sharing indicators away
      {match.title = "^(Firefox — Sharing Indicator)$"; workspace = "special silent";}
      {match.title = "^.*(Sharing Indicator)$"; workspace = "special silent";}
      {match.title = "^(.*is sharing (your screen|a window)\\.)$"; workspace = "special silent";}

      # IDE
      {match.class = "^(Code)$"; workspace = "1";}
      {match.class = "^(jetbrains-studio)$"; workspace = "1";} # android studio
      {
        match = {
          class = "^(jetbrains-studio)$";
          title = "^(Conflicts)$";
        };
        workspace = "1";
      } # android studio

      # Browsing
      # {match.class = "^(firefox)$"; workspace = "2";}
      # {match.class = "^(brave)$"; workspace = "2";}

      # Terminal
      # {match.class = "^(wezterm)$"; workspace = "3";}
      # {match.class = "^(alacritty)$"; workspace = "3";}
      # {match.class = "^(kitty)$"; workspace = "3";}

      # Messaging
      # {match.class = "^(Slack)$"; workspace = "5 silent";}
      # {match.class = "^(org.telegram.desktop)$"; workspace = "5 silent";}
      # {match.class = "^(discord)$"; workspace = "5 silent";}
      # {match.class = "^(zoom)$"; workspace = "5 silent";}
      # {match.class = "^(teams-for-linux)$"; workspace = "5 silent";}

      # {match.class = "^(.*pavucontrol.*)$"; workspace = "special silent";}
    ];
  };
}
