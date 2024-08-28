{
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
    # portalPackage = pkgs.xdg-desktop-portal-hyprland;
    portalPackage = inputs.xdph.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
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
        tuigreetOptions = [
          "--remember"
          "--remember-session"
          "--time"
          # Make sure theme is wrapped in single quotes. See https://github.com/apognu/tuigreet/issues/147
          "--theme 'border=blue;text=cyan;prompt=green;time=red;action=blue;button=white;container=black;input=red'"
          "--cmd Hyprland"
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
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];
  };
}
