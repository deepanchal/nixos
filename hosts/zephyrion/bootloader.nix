{ pkgs, ... }:

{
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    # blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "nvidia_drm.fbdev=1"
      "nvidia_drm.modeset=1"
    ];
    consoleLogLevel = 0;
    initrd = {
      enable = true;
      verbose = true;
      systemd.enable = true;
    };
    # grub = {
    #   enable = true;
    #   device = "nodev";
    #   useOSProber = true;
    # };
    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = "catppuccin-macchiato";
    };
  };
}
