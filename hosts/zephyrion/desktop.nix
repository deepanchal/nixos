{
  lib,
  pkgs,
  inputs,
  ...
}: let
  tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
  tuigreet-theme = "border=blue;container=black;time=magenta;prompt=green;action=blue;button=yellow;text=cyan";
in {
  ##########################################
  # DESKTOP ENVIRONMENT
  ##########################################
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  # security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Gnome Exclude Packages
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
      gedit # text editor
      epiphany # web browser
      geary # email reader
    ])
    ++ (with pkgs.gnome; [
      # gnome.gnome-terminal
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.sway = {
    enable = true;
    xwayland.enable = true;
    extraOptions = [
      "--verbose"
      # "--debug"
      # "--unsupported-gpu" # enable if using with nvidia
    ];
    # override default packages
    extraPackages = with pkgs; [
      swaylock
      swayidle
      # foot
      # dmenu
      # wmenu
    ];
  };

  xdg.portal = {
    enable = true;
  };

  ##########################################
  # DISPLAY MANAGER
  ##########################################
  # services.xserver.displayManager.gdm.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --remember --remember-session --time --theme ${tuigreet-theme} --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal"; # Without this errors will spam on screen
  #   # Without these bootlogs will spam on screen
  #   TTYReset = true;
  #   TTYVHangup = true;
  #   TTYVTDisallocate = true;
  # };

  ##########################################
  # FONTS
  ##########################################
  fonts = {
    packages = with pkgs; [
      material-icons
      material-design-icons
      roboto
      open-sans
      # work-sans
      # comic-neue
      # source-sans
      # twemoji-color-font
      # comfortaa
      # inter
      lato
      # lexend
      # jost
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];

    # enableDefaultPackages = false;

    # this fixes emoji stuff
    # fontconfig = {
    #   defaultFonts = {
    #     monospace = [
    #       "Iosevka Term"
    #       "Iosevka Term Nerd Font Complete Mono"
    #       "Iosevka Nerd Font"
    #       "Noto Color Emoji"
    #     ];
    #     sansSerif = ["Lexend" "Noto Color Emoji"];
    #     serif = ["Noto Serif" "Noto Color Emoji"];
    #     emoji = ["Noto Color Emoji"];
    #   };
    # };
  };
}
