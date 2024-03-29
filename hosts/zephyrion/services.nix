{ pkgs, lib, ... }:

{
  # Systemd services setup
  systemd.packages = with pkgs; [
    auto-cpufreq
  ];

  # Enable Services
  programs.direnv.enable = true;
  services.upower.enable = true;
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    xfce.xfconf
    gnome2.GConf
  ];
  services.mpd.enable = true;
  programs.thunar.enable = true;
  services.tumbler.enable = true;
  services.fwupd.enable = true;
  programs.light.enable = true;
  services.geoclue2 = {
    enable = true;
    appConfig = {
      "gammastep" = {
        isAllowed = true;
        isSystem = false;
        users = [ "1000" ]; # FIXME: set your user id (to get user id use command 'id -u "your_user_name"')
      };
    };
  };
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto"; # always | auto | never
      };
    };
  };
  # services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # services.avahi = {
  #   enable = true;
  #   nssmdns = true;
  # };

  ##################################################
  # SECURITY SERVICES
  ##################################################
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  security.pam.services.swaylock = { };
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
    at-spi2-atk
    qt6.qtwayland
    psi-notify
    poweralertd
    swaylock-effects
    swayidle
    playerctl
    psmisc
    grim
    slurp
    imagemagick
    swappy
    ffmpeg_6-full
    # wl-screenrec
    wf-recorder
    wl-clipboard
    cliphist
    clipboard-jh
    xdg-utils
    wtype
    wlrctl
    hyprpicker
    pyprland
    waybar
    rofi-wayland
    dunst
    avizo
    wlogout
    wpaperd
    # swww
    gifsicle

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
