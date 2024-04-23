# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    ./global
    ./features/shell/nushell
    ./features/shell/fish.nix
    ./features/shell/zsh
    ./features/shell/direnv
    ./features/shell/starship.nix
    ./features/shell/atuin.nix
    ./features/nvim
    # ./features/rofi
    # ./features/terminal
    # ./features/terminal/emulators/wezterm
    # ./features/terminal/emulators/alacritty
    # ./features/terminal/emulators/kitty
    ./features/terminal/programs/btop.nix
    ./features/terminal/programs/bat.nix
    ./features/terminal/programs/ripgrep.nix
    ./features/terminal/programs/lazygit.nix
    ./features/terminal/programs/tailspin.nix
    ./features/terminal/programs/zoxide.nix
    ./features/terminal/programs/git-cliff.nix
    ./features/terminal/programs/keychain.nix
    ./features/terminal/programs/yazi.nix
    ./features/zellij
  ];

  colorscheme = lib.mkDefault colorSchemes.catppuccin-mocha;
  theme = {
    name = "Catppuccin-Mocha";
    flavor = "Mocha";
    accentName = "Blue";
    accent = colorSchemes.catppuccin-mocha.palette.base0D;
  };
  specialisation = {
    light.configuration.colorscheme = colorSchemes.catppuccin-latte;
  };

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
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

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
  # home.sessionVariables = {
  #   EDITOR = "nvim";
  #   BROWSER = "firefox";
  # };

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
    git.enable = true;
  };

  services = {
    blueman-applet.enable = true;
  };
}
