# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  # You can import other home-manager modules here
  imports = [
    inputs.nur.hmModules.nur
    inputs.catppuccin.homeManagerModules.catppuccin

    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    ./global
    ./features/shell
    ./features/hyprland
    # ./features ./eww # Not working yet
    ./features/waybar
    ./features/anyrun
    # ./features ./dunst
    ./features/swaync
    ./features/rofi
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
  ];

  # ***********************************
  # Catppuccin Mocha Theme
  # ***********************************
  # --------------------------------------------------------------------------
  # | Labels    | base16 | Hex     | RGB                | HSL                |
  # |-----------|--------|---------|--------------------|--------------------|
  # | Rosewater | base06 | #f5e0dc | rgb(245, 224, 220) | hsl(10, 56%, 91%)  |
  # | Flamingo  | base0F | #f2cdcd | rgb(242, 205, 205) | hsl(0, 59%, 88%)   |
  # | Pink      |        | #f5c2e7 | rgb(245, 194, 231) | hsl(316, 72%, 86%) |
  # | Mauve     | base0E | #cba6f7 | rgb(203, 166, 247) | hsl(267, 84%, 81%) |
  # | Red       | base08 | #f38ba8 | rgb(243, 139, 168) | hsl(343, 81%, 75%) |
  # | Maroon    |        | #eba0ac | rgb(235, 160, 172) | hsl(350, 65%, 77%) |
  # | Peach     | base09 | #fab387 | rgb(250, 179, 135) | hsl(23, 92%, 75%)  |
  # | Yellow    | base0A | #f9e2af | rgb(249, 226, 175) | hsl(41, 86%, 83%)  |
  # | Green     | base0B | #a6e3a1 | rgb(166, 227, 161) | hsl(115, 54%, 76%) |
  # | Teal      | base0C | #94e2d5 | rgb(148, 226, 213) | hsl(170, 57%, 73%) |
  # | Sky       |        | #89dceb | rgb(137, 220, 235) | hsl(189, 71%, 73%) |
  # | Sapphire  |        | #74c7ec | rgb(116, 199, 236) | hsl(199, 76%, 69%) |
  # | Blue      | base0D | #89b4fa | rgb(137, 180, 250) | hsl(217, 92%, 76%) |
  # | Lavender  | base07 | #b4befe | rgb(180, 190, 254) | hsl(232, 97%, 85%) |
  # | Text      | base05 | #cdd6f4 | rgb(205, 214, 244) | hsl(226, 64%, 88%) |
  # | Subtext1  |        | #bac2de | rgb(186, 194, 222) | hsl(227, 35%, 80%) |
  # | Subtext0  |        | #a6adc8 | rgb(166, 173, 200) | hsl(228, 24%, 72%) |
  # | Overlay2  |        | #9399b2 | rgb(147, 153, 178) | hsl(228, 17%, 64%) |
  # | Overlay1  |        | #7f849c | rgb(127, 132, 156) | hsl(230, 13%, 55%) |
  # | Overlay0  |        | #6c7086 | rgb(108, 112, 134) | hsl(231, 11%, 47%) |
  # | Surface2  | base04 | #585b70 | rgb(88, 91, 112)   | hsl(233, 12%, 39%) |
  # | Surface1  | base03 | #45475a | rgb(69, 71, 90)    | hsl(234, 13%, 31%) |
  # | Surface0  | base02 | #313244 | rgb(49, 50, 68)    | hsl(237, 16%, 23%) |
  # | Base      | base00 | #1e1e2e | rgb(30, 30, 46)    | hsl(240, 21%, 15%) |
  # | Mantle    | base01 | #181825 | rgb(24, 24, 37)    | hsl(240, 21%, 12%) |
  # | Crust     |        | #11111b | rgb(17, 17, 27)    | hsl(240, 23%, 9%)  |
  # --------------------------------------------------------------------------

  wallpaper = ./features/theme/wallpapers/mocha-surf-wave.png; # Comes from custom wallpaper hm-module
  colorscheme = lib.mkDefault colorSchemes.catppuccin-mocha;
  theme = {
    name = "Catppuccin-Mocha";
    flavor = "Mocha";
    # accentName = "Peach";
    # accent = colorSchemes.catppuccin-mocha.palette.base09;
    accentName = "Blue";
    accent = colorSchemes.catppuccin-mocha.palette.base0D;
    # accentName = "Flamingo";
    # accent = colorSchemes.catppuccin-mocha.palette.base0F;
    # accentName = "Rosewater";
    # accent = colorSchemes.catppuccin-mocha.palette.base06;
    # accentName = "Lavender";
    # accent = colorSchemes.catppuccin-mocha.palette.base07;
    # accentName = "Mauve";
    # accent = colorSchemes.catppuccin-mocha.palette.base0E;
    # accentName = "Teal";
    # accent = colorSchemes.catppuccin-mocha.palette.base0C;
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
  };

  services = {
    blueman-applet.enable = true;
    swayosd.enable = true;
    gnome-keyring.enable = true;
  };

  catppuccin = let
    # Type: one of “latte”, “frappe”, “macchiato”, “mocha”
    flavor = "mocha";
    # Type: one of “blue”, “flamingo”, “green”, “lavender”, “maroon”, “mauve”, “peach”, “pink”, “red”, “rosewater”, “sapphire”, “sky”, “teal”, “yellow”
    accent = "blue";
  in {
    # enable for all programs
    enable = true;
    flavor = flavor;
    accent = accent;

    pointerCursor = {
      enable = false;
    };
  };
}
