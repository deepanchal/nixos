# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    inputs.nur.modules.homeManager.default
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    ./global
    ./features/editors
    ./features/terminal
    ./features/desktop
    ./features/scripts
    ./features/programs
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello

    # Fonts
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.roboto-mono

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (pkgs.writeShellScriptBin "nohup-open" ''
      # Run any command passed as arguments in the background,
      # discarding both stdout and stderr.
      nohup "$@" > /dev/null 2>&1 &
    '')

    # Cider - Paid Apple Music Client
    # 1. Get AppImage from 
    #    - https://taproom.cider.sh/downloads
    #    - https://cidercollective.itch.io/cider
    # 2. Make it executable
    #      chmod +x ~/Downloads/apps/cider-v3.0.2-linux-x64.AppImage
    # 2. Add it to nix store
    #      nix-store --add-fixed sha256 ~/Downloads/apps/cider-3/cider-linux-x64.AppImage
    # 3. Rebuild system
    pkgs.cider-2

    # Helpful tools
    pkgs.csvlens # csv tui in rust
    pkgs.jless # pager for json in rust
    pkgs.entr
    pkgs.pipx
    pkgs.httpie
    pkgs.popsicle # utility for flashing multiple usb devices in parallel in rust, also provides popsicle cli
    pkgs.rpi-imager
    pkgs.bmaptool
    pkgs.totp-cli
    pkgs.scrcpy
    pkgs.kubectl
    pkgs.bluetui
    pkgs.neofetch
    pkgs.google-cloud-sdk
    pkgs.prismlauncher # minecraft launcher
    pkgs.postman

    # AI Tools
    pkgs.aider-chat # AI pair programming in your terminal
    pkgs.plandex # AI driven development in your terminal.
    pkgs.code-cursor
    pkgs.ollama

    # NOTE: My custom packages found under pkgs dir

    # How to sync bt?
    # Boot into windows and pair your bt device (eg. headphones)
    # Boot back into linux, forget your bt device
    # We need to mount windows C drive to /mnt
    # `sudo mkdir -p /mnt`
    # Find your windows C drive partition with `lsblk`
    # Mount windows C drive to /mnt with `sudo mount /dev/nvme1n1p3 /mnt`
    # Run `bt-keys-sync`
    # It will ask to run as root (sudo)
    # Select import key from Windows to Linux option since windows has latest pairing key
    # Once script exits, try powering on your bt device and it should auto connect in your linux
    pkgs.bt-keys-sync # See: pkgs/bt-keys-sync/default.nix
    pkgs.sf-pro-fonts # See: pkgs/sf-pro-fonts/default.nix
    pkgs.mender-cli # See: pkgs/mender-cli/default.nix
    pkgs.codegrab # See: pkgs/codegrab/default.nix
    pkgs.fuego # See: pkgs/fuego/default.nix
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deep/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "brave";
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  programs = {
    home-manager.enable = true;
    obs-studio.enable = true;
  };

  services = {
    blueman-applet.enable = true;
    swayosd.enable = true;
    gnome-keyring.enable = true;
    gpg-agent.enable = true;
  };

  # Defined in custom hm module -> monitors.nix
  monitors = let
    primaryMonitor = {
      name = "HDMI-A-1"; # or "DP-1"; # external monitor w/ usb-c
      enabled = true;
      primary = true;
      width = 2560;
      height = 1440;
      x = 0;
      y = 0;
      refreshRate = 143.85;
      # NOTE: Using any other than 1, 1.066666, 1.25 scaleFactor shows
      # Invalid scale passed to monitor _, failed to find a clean divisor. Suggested nearest scale: _
      scaleFactor = 1.0;
    };
    secondaryMonitor = {
      name = "eDP-1"; # laptop screen
      enabled = true;
      primary = false;
      width = 1920;
      height = 1080;
      x = 0;
      # center monitor horizontally below primary monitor (not working)
      # x = builtins.floor (primaryMonitor.width * primaryMonitor.scaleFactor - width * scaleFactor);
      # stack below primary monitor
      y = builtins.floor (primaryMonitor.height / primaryMonitor.scaleFactor);
      refreshRate = 165.0;
      scaleFactor = 1.0;
    };
  in [
    primaryMonitor
    secondaryMonitor
  ];
}
