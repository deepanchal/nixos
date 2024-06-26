{pkgs, ...}: {
  ##########################################
  # DESKTOP ENVIRONMENT
  ##########################################
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Gnome Exclude Packages
  # environment.gnome.excludePackages = (with pkgs; [
  #   gnome-tour
  # ]) ++ (with pkgs.gnome; [
  #       gnome-terminal
  #       gedit # text editor
  #       epiphany # web browser
  #       geary # email reader
  #       tali # poker game
  #       iagno # go game
  #       hitori # sudoku game
  #       atomix # puzzle game
  # ]);

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = true; # No longer needed
  };

  xdg.portal = {
    enable = true;
    # config.common.default = "*";
    wlr.enable = true;
    extraPortals = [
      # pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  ##########################################
  # DISPLAY MANAGER
  ##########################################
  services.xserver.displayManager.gdm.enable = true;
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     # default_session = {
  #     #   command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
  #     #   user = "greeter";
  #     # };
  #     default_session = {
  #       command = "${pkgs.cage}/bin/cage -s ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
  #       user = "greeter";
  #     };
  #   };
  # };
  # services.greetd.enable = true;
  # programs.regreet = {
  #   enable = true;
  #   package = pkgs.greetd.regreet;
  #   settings = {
  #     cageArgs = [
  #       "-s"
  #       "-m"
  #       "last"
  #     ];
  #     commands = {
  #       reboot = [ "systemctl" "reboot" ];
  #       poweroff = [ "systemctl" "poweroff" ];
  #     };
  #   };
  # };
  environment.systemPackages = with pkgs; [
    # cage
    # greetd.tuigreet
    # greetd.gtkgreet
    # greetd.regreet
  ];

  ##########################################
  # FONTS
  ##########################################
  fonts = {
    packages = with pkgs; [
      material-icons
      material-design-icons
      roboto
      work-sans
      comic-neue
      source-sans
      twemoji-color-font
      comfortaa
      inter
      lato
      lexend
      jost
      dejavu_fonts
      iosevka-bin
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      fira-code-nerdfont
      (nerdfonts.override {fonts = ["FiraCode" "Iosevka" "JetBrainsMono"];})
    ];

    enableDefaultPackages = false;

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
