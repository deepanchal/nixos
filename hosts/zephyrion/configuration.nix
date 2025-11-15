# Edit trueconfiguration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    inputs.disko.nixosModules.default
    (import ./disk-config.nix {device = "/dev/disk/by-id/nvme-HFM001TD3JX013N_CYA3N053310603J32";})
    # (import ./disk-config.nix {device = "/dev/disk/by-id/nvme-WDC_WDS240G2G0C-00AJM0_205130900427";})
    # (import ./disk-config.nix {device = "/dev/disk/by-id/ata-WDC_WDS240G2G0C-00AJM0_205130900427";})

    inputs.nur.modules.nixos.default

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/pipewire.nix

    # This import disables nvidia gpu. This runs only intel/amdgpu igpus and nvidia dgpus do not drain power.
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    # ./nvidia.nix

    ./asus.nix
    ./users.nix
    ./desktop.nix
    ./services.nix
    ./udev.nix
    ./nix-ld.nix
    ./virtualization.nix
    ./theme.nix
    ./home.nix # NOTE: building home-manager along with nixos
    ./impermanence.nix
  ];

  ##################################################
  # BOOTLOADER
  ##################################################
  boot = {
    loader = {
      # systemd-boot
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # grub
      # grub.enable = true;
      # grub.efiSupport = true;
      # grub.device = "nodev";
      # efi.canTouchEfiVariables = true;
      # efi.efiSysMountPoint = "/boot/efi";
      # timeout = 5;
    };
    # blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [
      # Quiet boot flags
      "quiet"
      "udev.log_level=3"

      # Nvidia flags are not needed
      # "nvidia_drm.fbdev=1"
      # "nvidia_drm.modeset=1"

      # Disable amd_pstate to use acpi-cpufreq driver instead of amd_pstate_epp
      # "amd_pstate=disable"

      # For maybe disabling cpu boost
      # See: https://bbs.archlinux.org/viewtopic.php?id=291561
      # "amd_pstate=passive"
    ];
    consoleLogLevel = 0;
    initrd = {
      enable = true;
      verbose = true;
      systemd.enable = true;
      # Enable AMD iGPU early in the boot process
      kernelModules = ["amdgpu"];
    };
    # grub = {
    #   enable = true;
    #   device = "nodev";
    #   useOSProber = true;
    # };
    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    };
    tmp = {
      cleanOnBoot = true;
    };
  };
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-124n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_11;

  ##################################################
  # NIX SETTINGS
  ##################################################
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
    overlays = [
      inputs.nur.overlays.default
    ];
  };

  ##################################################
  # NETWORKING
  ##################################################
  networking = {
    hostName = "zephyrion"; # Define your hostname.
    # Pick only one of the below networking options.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    wireguard.enable = true;
    # https://wiki.nixos.org/wiki/WireGuard#Client_setup_(non-declaratively)
    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        configFile = "/etc/wireguard/wg0.conf";
      };
      wg1 = {
        autostart = false;
        configFile = "/etc/wireguard/wg1.conf";
      };
    };

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    firewall.enable = true;
    # firewall.allowedTCPPorts = [ 3000 ];
    firewall.allowedUDPPorts = [
      51820 # Clients and peers can use the same port, see listenport
    ];
    # Or disable the firewall altogether.
    # firewall.enable = false;

    # hosts = {
    #   "192.168.0.79" = [ "beacon.local" ];
    # };
    # extraHosts = ''
    #   192.168.0.79 beacon.local
    # '';
  };

  ##################################################
  # BLUETOOTH
  ##################################################
  hardware.enableAllFirmware = true; # See: https://discourse.nixos.org/t/bluetooth-troubles/38940/16
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  ##################################################
  # ENVIRONMENT VARIABLES
  ##################################################
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "brave";

    # Wayland
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    # MOZ_DRM_DEVICE = "/dev/dri/renderD129"; # see (Section 4.2.3): https://wiki.archlinux.org/title/Firefox#Hardware_video_acceleration
    # WLR_BACKEND = "vulkan";
    # WLR_RENDERER = "vulkan";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";

    # Other
    XDG_RUNTIME_DIR = "/run/user/$UID"; # See: https://discourse.nixos.org/t/login-keyring-did-not-get-unlocked-hyprland/40869/10
  };

  ##################################################
  # MISC
  ##################################################
  hardware.usb-modeswitch.enable = true; # For switching usb devices from storage to network mode
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  ##################################################
  # SYSTEM PACKAGES
  ##################################################
  environment.systemPackages = with pkgs; [
    # Networking
    curl
    iw
    wget

    openssl
    openssl.dev
    cacert
    gparted

    # Hardware tools
    acpi
    brightnessctl
    lshw
    pciutils
    busybox # Tiny versions of common UNIX utilities in a single small executable
    pamixer
    pavucontrol
    linuxKernel.packages.linux_zen.cpupower
    # cpupower-gui
    cpufrequtils
    e2fsprogs # Tools for creating and checking ext2/ext3/ext4 filesystems
    ntfs3g # ntfs filesystem support
    screen
    picocom
    groff
    mandoc
    hw-probe

    # upx
    git
    zip
    unzip
    gh
    glab

    vim
    neovim

    brave
    google-chrome

    fd
    procs
    # just
    # sd
    dust
    hexyl
    # tokei
    # hyperfine
    # grex
    delta
    # nushell
    # helix
    # mcfly # terminal history
    # skim #fzf better alternative in rust
    # macchina #neofetch alternative in rust
    # xh #send http requests

    alejandra
    nix-index

    progress
    # noti
    # rewrk
    # wrk2
    nvtopPackages.full
    # monolith
    # aria
    # ouch
    # duf
    jq
    trash-cli
    fzf
    # mdcat
    # pandoc
    # lsd
    # gping
    # viu
    # tre-command
    # felix-fm
    # chafa

    # cmatrix
    # pipes-rs
    # rsclock
    # cava
    # figlet

    mpv # video player
    imv # image viewer

    cmake
    gnumake
    mold
    gcc13
    jdk11
    ninja
    pkg-config

    nodePackages.nodejs
    rustup
    gcc
    libgcc
    go
    # bun
    lua
    zig
    # numbat
    gobject-introspection
    python312Packages.pygobject3
    python312Packages.pyqt6-sip

    # For python
    zlib.dev
    bzip2.dev
    xz.dev
    libffi.dev
    sqlite.dev
    readline.dev
    ncurses.dev
    gdbm.dev
    tcl
    tk
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11"; # Did you read the comment?
}
