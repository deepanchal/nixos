{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  c = config.colorScheme.palette;
in {
  imports = [
    ./config.nix
    ./binds.nix
    ./rules.nix
  ];
  home.packages = with pkgs; [
    libnotify
    wl-screenrec
    brightnessctl
    pamixer
    slurp
    grim
    hyprpicker
    swappy
    grimblast
    hyprpicker
    hyprshot
    wl-clip-persist
    wl-clipboard
    wdisplays
    wev
    # watershot # Simple wayland native screenshot tool in Rust
    # ironbar # Wayland gtk bar in Rust
    cliphist

    (pkgs.writeShellScriptBin "move-cursor" ''
      set -e

      dir="$1"   # up | down | left | right
      amt="$2"   # pixel offset (positive integer)

      pos=$(hyprctl cursorpos)
      x=$(echo "$pos" | cut -d ',' -f1)
      y=$(echo "$pos" | cut -d ',' -f2 | tr -d '[:space:]')

      case "$dir" in
        left)  x=$((x - amt)) ;;
        right) x=$((x + amt)) ;;
        up)    y=$((y - amt)) ;;
        down)  y=$((y + amt)) ;;
        *)
          echo "Usage: move_cursor {up|down|left|right} amount" >&2
          exit 1
          ;;
      esac

      hyprctl dispatch movecursor "$x" "$y"
    '')
  ];

  # https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/hyprland.nix
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
    ];
    # systemd = {
    #   variables = ["--all"];
    #   extraCommands = [
    #     "systemctl --user stop graphical-session.target"
    #     "systemctl --user start hyprland-session.target"
    #   ];
    # };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      "$accent" = "rgb(${c.primary})";
      "$accentAlpha" = "${c.primary}";
      "$surface0" = "rgb(${c.surface0})";
      "$red" = "rgb(${c.error})";
      "$yellow" = "rgb(${c.warning})";
      "$text" = "rgb(${c.base05})";
      "$textAlpha" = "${c.base05}";
      "$font" = "SF Pro Display SemiBold";

      # Config from https://github.com/MrVivekRajan/Hyprlock-Styles/blob/a66b66a1697df450f9c9fa72478706005b9a69ba/Style-10/hyprlock.conf
      general = {
        disable_loading_bar = false;
        # grace = 300;
        hide_cursor = false;
        no_fade_in = false;
      };
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 2;
        }
      ];
      label = [
        # Day
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo -e "$(date +"%A")"
          '';
          color = "$text";
          font_size = "90";
          font_family = "$font";
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        # Date-Month
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo -e "$(date +"%d %B")"
          '';
          color = "$text";
          font_size = "40";
          font_family = "$font";
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<span>$(date +"- %I:%M -")</span>"
          '';
          color = "$text";
          font_size = "20";
          font_family = "$font";
          position = "0, 190";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "  $USER";
          color = "rgba(216, 222, 233, 0.80)";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          font_size = "18";
          font_family = "$font";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        # Power
        # {
        #   monitor = "";
        #   text = "󰐥  󰜉  󰤄";
        #   color = "rgba(255, 255, 255, 0.6)";
        #   font_size = "50";
        #   position = "0, 100";
        #   halign = "center";
        #   valign = "bottom";
        # }
      ];
      # Profile-Pic
      image = {
        monitor = "";
        path = "${config.home.homeDirectory}/.face";
        border_size = 2;
        border_color = "rgba(255, 255, 255, .65)";
        size = 130;
        rounding = -1;
        rotate = 0;
        reload_time = -1;
        reload_cmd = "";
        position = "0, 40";
        halign = "center";
        valign = "center";
      };
      # User-Box
      shape = {
        monitor = "";
        size = "300, 60";
        color = "rgba(255, 255, 255, .1)";
        rounding = -1;
        border_size = 0;
        border_color = "rgba(255, 255, 255, 0)";
        rotate = 0;
        xray = false; # if true, make a "hole" in the background (rectangle of specified size, no rotation)
        position = "0, -130";
        halign = "center";
        valign = "center";
      };
      input-field = [
        {
          monitor = "";
          size = "300, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(255, 255, 255, 0)";
          inner_color = "rgba(255, 255, 255, 0.1)";
          font_color = "$text";
          fade_on_empty = false;
          font_family = "$font";
          placeholder_text = ''
            <i><span foreground="##$textAlpha">󰌾  Enter Pass</span></i>
          '';
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "$yellow";
          position = "0, -210";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # services.hypridle = {
  #   enable = true;
  # };
  # services.hyprpaper = {
  #   enable = true;
  # };

  # fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
