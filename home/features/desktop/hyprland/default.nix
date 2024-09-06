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
    wl-clip-persist
    wl-clipboard
    wdisplays
    wev
    # watershot # Simple wayland native screenshot tool in Rust
    # ironbar # Wayland gtk bar in Rust
    cliphist
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
      "$font" = "JetBrainsMono Nerd Font";

      general = {
        disable_loading_bar = false;
        # grace = 300;
        hide_cursor = false;
        no_fade_in = false;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 3;
        }
      ];
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = "90";
          font_family = "$font";
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:43200000] date +"%A, %d %B %Y"
          '';
          color = "$text";
          font_size = "25";
          font_family = "$font";
          position = "0, -75";
          halign = "center";
          valign = "top";
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "300, 60";
          outline_thickness = "4";
          dots_size = "0.2";
          dots_spacing = "0.2";
          dots_center = "true";
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = "false";
          placeholder_text = ''
            <span foreground="##$textAlpha"><i>󰌾  Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
          '';
          hide_input = "false";
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "$yellow";
          position = "0, -47";
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
