{ pkgs, lib, ... }:

{
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
  # security.pam.services.swaylock = {};
  # security.polkit.enable = true;
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

  # environment.systemPackages = with pkgs; [
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
  # ];
}
