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
    inputs.nur.hmModules.nur
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    ./global
    ./features/theme
    ./features/shell
    ./features/hyprland
    ./features/sway
    # ./features ./eww # Not working yet
    ./features/waybar
    ./features/anyrun
    # ./features ./dunst
    ./features/swaync
    ./features/terminal
    ./features/nvim
    ./features/zellij
    ./features/swaylock
    ./features/gtk
    ./features/flameshot
    # ./features/mise
    ./features/tmux
    ./features/firefox
    ./features/thunar
    ./features/jetbrains
    ./features/keybase
    ./features/wlogout
    ./features/swappy
    ./features/satty
    ./features/scripts
    ./features/dnote
    ./features/portals
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
    BROWSER = "firefox";
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
      width = 2560;
      height = 1440;
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
