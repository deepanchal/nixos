{
  pkgs,
  lib,
  ...
}: {
  # Enable Services
  programs.direnv.enable = true;
  services.upower.enable = true;
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
    };
  };
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    xfce.xfconf
    gnome2.GConf
  ];
  services.mpd.enable = true;
  programs.thunar.enable = true;
  programs.adb.enable = true;
  programs.openvpn3.enable = true;
  programs.nm-applet.enable = true;
  services.teamviewer.enable = true;
  services.locate.enable = true;
  services.tumbler.enable = true;
  services.fwupd.enable = true;
  programs.light.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/deep/projects/nixos";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # https://blog.stigok.com/2019/12/09/nixos-avahi-publish-service.html
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

  ##################################################
  # SECURITY SERVICES
  ##################################################
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Security Services
  # users.users.root.hashedPassword = "!";
  # security.tpm2 = {
  #   enable = true;
  #   pkcs11.enable = true;
  #   tctiEnvironment.enable = true;
  # };
  # security.apparmor = {
  #   enable = true;
  #   packages = with pkgs; [
  #     apparmor-utils
  #     apparmor-profiles
  #   ];
  # };
  # services.fail2ban.enable = true;
  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};
  security.polkit.enable = true;
  # programs.browserpass.enable = true;
  # services.clamav = {
  #   daemon.enable = true;
  #   updater.enable = true;
  #   updater.interval = "daily"; #man systemd.time
  #   updater.frequency = 12;
  # };
  # programs.firejail = {
  #   enable = true;
  #   wrappedBinaries = {
  #     mpv = {
  #       executable = "${lib.getBin pkgs.mpv}/bin/mpv";
  #       profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
  #     };
  #     imv = {
  #       executable = "${lib.getBin pkgs.imv}/bin/imv";
  #       profile = "${pkgs.firejail}/etc/firejail/imv.profile";
  #     };
  #     zathura = {
  #       executable = "${lib.getBin pkgs.zathura}/bin/zathura";
  #       profile = "${pkgs.firejail}/etc/firejail/zathura.profile";
  #     };
  #     discord = {
  #       executable = "${lib.getBin pkgs.discord}/bin/discord";
  #     };
  #   };
  # };

  environment.systemPackages = with pkgs; [
    # wlsunset
    gammastep
    brightnessctl
    # at-spi2-atk
    qt6.qtwayland
    # psi-notify
    # poweralertd
    # swaylock-effects
    swayidle
    playerctl
    psmisc # A package of small utilities that use the proc file-system.
    grim
    slurp
    imagemagick
    swappy
    ffmpeg_6-full
    wl-screenrec
    wl-clipboard
    cliphist
    # clipboard-jh
    xdg-utils
    wtype # xdotool type for wayland
    wlrctl
    hyprpicker
    # pyprland
    waybar
    # rofi-wayland
    dunst
    # avizo
    wlogout
    # wpaperd
    # swww
    # gifsicle

    #   vulnix       #scan command: vulnix --system
    #   clamav       #scan command: sudo freshcalm; clamscan [options] [file/directory/-]
    #   chkrootkit   #scan command: sudo chkrootkit
    #
    #   # passphrase2pgp
    #   pass-wayland
    #   pass2csv
    #   passExtensions.pass-tomb
    #   passExtensions.pass-update
    #   passExtensions.pass-otp
    #   passExtensions.pass-import
    #   passExtensions.pass-audit
    #   tomb
  ];
}
