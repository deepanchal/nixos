# Edit trueconfiguration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
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
    (import ./disk-config.nix {device = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_191386466003";})

    inputs.nur.nixosModules.nur

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/pipewire.nix

    # This import disables nvidia gpu. This runs only intel/amdgpu igpus and nvidia dgpus do not drain power.
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    # ./nvidia.nix

    ./asus.nix
    ./desktop.nix
    ./services.nix
    ./virtualization.nix
    ./theme.nix
    ./home.nix # Note: building home-manager along with nixos
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
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_8;

  ##################################################
  # USER SETTINGS
  ##################################################
  users.users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    deep = {
      isNormalUser = true;
      description = "Deep Panchal";
      extraGroups = [
        "networkmanager"
        "input"
        "wheel"
        "video"
        "audio"
        "libvirtd"
        "docker"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        neovim
        firefox
        brave
        discord
        spotify
        vscode
        slack
      ];
    };
  };

  ##################################################
  # NIX SETTINGS
  ##################################################
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
    overlays = [
      inputs.nur.overlay
    ];
  };

  ##################################################
  # NIX GARBAGE COLLECTION
  ##################################################
  # Garbage collection
  # Optimize storage and automatic scheduled GC running
  # If you want to run GC manually, use commands:
  # `nix-store --optimize` for finding and eliminating redundant copies of identical store paths
  # `nix-store --gc` for optimizing the nix store and removing unreferenced and obsolete store paths
  # `nix-collect-garbage -d` for deleting old generations of user profiles
  ##################################################
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc = {
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  ##################################################
  # NIX AUTO UPGRADE
  ##################################################
  # Scheduled auto upgrade system (this is only for system upgrades,
  # if you want to upgrade cargo\npm\pip global packages, docker containers or different part of the system
  # or get really full system upgrade, use `topgrade` CLI utility manually instead.
  # I recommend running `topgrade` once a week or at least once a month)
  ##################################################
  system.autoUpgrade = {
    enable = false;
    operation = "switch"; # If you don't want to apply updates immediately, only after rebooting, use `boot` option in this case
    flake = "/etc/nixos";
    flags = ["--update-input" "nixpkgs" "--update-input" "rust-overlay" "--commit-lock-file"];
    dates = "weekly";
    # channel = "https://nixos.org/channels/nixos-unstable";
  };

  ##################################################
  # NETWORKING
  ##################################################
  networking = {
    hostName = "zephyrion"; # Define your hostname.
    enableIPv6 = false;
    # Pick only one of the below networking options.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    firewall.enable = true;
    # firewall.allowedTCPPorts = [ 3000 ];
    # firewall.allowedUDPPorts = [ 3000 ];
    # Or disable the firewall altogether.
    # firewall.enable = false;

    # hosts = {
    #   "192.168.0.79" = [ "beacon.local" ];
    # };
    # extraHosts = ''
    #   192.168.0.79 beacon.local
    # '';
  };
  programs.nm-applet.enable = true;

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
    BROWSER = "firefox";

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
  # SYSTEM PACKAGES
  ##################################################
  environment.systemPackages = with pkgs; [
    # Networking
    curl
    iw
    wget
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

    # upx
    git
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
    du-dust
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

    mold
    gcc13
    jdk11

    rustup
    gcc
    libgcc
    go
    (python311Full.withPackages (ps: with ps; [pygobject3 gobject-introspection pyqt6-sip]))
    nodePackages_latest.nodejs
    # bun
    lua
    zig
    # numbat
  ];

  # ================================================================ #
  # =                         DO NOT TOUCH                         = #
  # ================================================================ #

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
