{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  ##########################################
  # DESKTOP ENVIRONMENT
  ##########################################
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  # security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Gnome Exclude Packages
  environment.gnome.excludePackages = with pkgs; [
    # gnome-terminal
    # loupe # gnome image viewer
    gnome-tour
    gedit # text editor
    epiphany # web browser
    geary # email reader
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Temporarily using wlr portal. See: https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/251
    # portalPackage = pkgs.xdg-desktop-portal-wlr;
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
      default_session = let
        tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
        baseSessionsDir = "${config.services.displayManager.sessionData.desktops}";
        xSessions = "${baseSessionsDir}/share/xsessions";
        waylandSessions = "${baseSessionsDir}/share/wayland-sessions";
        tuigreetOptions = [
          "--remember"
          "--remember-session"
          "--sessions ${waylandSessions}:${xSessions}"
          "--time"
          # Make sure theme is wrapped in single quotes. See https://github.com/apognu/tuigreet/issues/147
          "--theme 'border=blue;text=cyan;prompt=green;time=red;action=blue;button=white;container=black;input=red'"
          # After upgrading to Hyprland 0.50.0, I started getting this error
          # /home/deep/.nix-profile/bin/Hyprland: /nix/store/6vzcxjxa2wlh3p9f5nhbk62bl3q313ri-gcc-14.3.0-lib/lib/libstdc++.so.6: version `GLIBCXX_3.4.34' not found (required by /home/deep/.nix-profile/bin/Hyprland)
          # which is similar to https://github.com/hyprwm/Hyprland/issues/7803
          # and this is happening bc I am setting LD_LIBRARY_PATH in nix-ld.nix file
          # Therefore, I am unsetting env var and launching Hyprland
          "--cmd bash -c 'LD_LIBRARY_PATH= Hyprland'"
        ];
        flags = lib.concatStringsSep " " tuigreetOptions;
      in {
        command = "${tuigreet} ${flags}";
        user = "greeter";
      };
    };
  };

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
      noto-fonts-cjk-sans
      noto-fonts-emoji
      # NOTE: I had to run `fc-cache -rf` to fix broken fonts after installation
      # See: https://github.com/NixOS/nixpkgs/issues/366979
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };
}
