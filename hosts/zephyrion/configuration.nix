# Edit trueconfiguration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/optional/pipewire.nix

    ./asus.nix
    ./nvidia.nix
    ./desktop.nix
    ./services.nix
    ./virtualization.nix
  ];

  ##################################################
  # BOOTLOADER
  ##################################################
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    # blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [
      # Quiet boot flags
      "quiet"
      "udev.log_level=3"

      # Nvidia flags are not needed
      # "nvidia_drm.fbdev=1"
      # "nvidia_drm.modeset=1"
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
      themePackages = [pkgs.catppuccin-plymouth];
      theme = "catppuccin-macchiato";
    };
    tmp = {
      cleanOnBoot = true;
    };
  };

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
      shell = pkgs.nushell;
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
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
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
    automatic = true;
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
    enable = true;
    operation = "switch"; # If you don't want to apply updates immediately, only after rebooting, use `boot` option in this case
    flake = "/etc/nixos";
    flags = ["--update-input" "nixpkgs" "--update-input" "rust-overlay" "--commit-lock-file"];
    dates = "weekly";
    # channel = "https://nixos.org/channels/nixos-unstable";
  };

  ##################################################
  # NETWORKING
  ##################################################
  networking.hostName = "zephyrion"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  programs.nm-applet.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Open ports in the firewall.
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ 3000 ];
  # networking.firewall.allowedUDPPorts = [ 3000 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ##################################################
  # BLUETOOTH
  ##################################################
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
    MOZ_DRM_DEVICE = "/dev/dri/renderD129"; # see (Section 4.2.3): https://wiki.archlinux.org/title/Firefox#Hardware_video_acceleration
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };

  ##################################################
  # SYSTEM PACKAGES
  ##################################################
  environment.systemPackages = with pkgs; [
    # upx
    busybox # Tiny versions of common UNIX utilities in a single small executable
    git
    gh
    glab

    vim
    neovim

    brave
    google-chrome

    fd
    procs
    just
    sd
    du-dust
    tokei
    hyperfine
    grex
    delta
    nushell
    helix
    # mcfly # terminal history
    # skim #fzf better alternative in rust
    # macchina #neofetch alternative in rust
    # xh #send http requests

    alejandra
    nvtop
    wget
    nix-index
    pciutils
    lshw

    progress
    noti
    rewrk
    wrk2
    nvtop
    monolith
    aria
    ouch
    duf
    jq
    trash-cli
    fzf
    mdcat
    pandoc
    lsd
    gping
    viu
    tre-command
    felix-fm
    chafa

    cmatrix
    pipes-rs
    rsclock
    cava
    figlet

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
  system.stateVersion = "23.11"; # Did you read the comment?
}
