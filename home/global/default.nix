{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  imports =
    [
      # inputs.impermanence.nixosModules.home-manager.impermanence
      inputs.nix-colors.homeManagerModule
      # ../features/cli
      # ../features/nvim
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  options = {
    theme = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Catppuccin-Mocha";
        description = "Theme name";
      };
      flavor = lib.mkOption {
        type = lib.types.str;
        default = "Mocha";
        description = "Theme flavor name";
      };
      accentName = lib.mkOption {
        type = lib.types.str;
        default = "Teal";
        description = "Theme accent color name";
      };
      accent = lib.mkOption {
        type = lib.types.str;
        default = colorSchemes.catppuccin-mocha.palette.base0C;
        description = "Theme accent color";
      };
    };
  };

  config = {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
      # Configure your nixpkgs instance
      config = {
        # Disable if you don't want unfree packages
        allowUnfree = true;
        # Workaround for https://github.com/nix-community/home-manager/issues/2942
        allowUnfreePredicate = _: true;
      };
    };

    nix = {
      package = lib.mkDefault pkgs.nix;
      settings = {
        experimental-features = ["nix-command" "flakes" "repl-flake"];
        warn-dirty = false;
      };
    };

    systemd.user.startServices = "sd-switch";

    programs = {
      home-manager.enable = true;
      git.enable = true;
    };

    home = {
      username = lib.mkDefault "deep";
      homeDirectory = lib.mkDefault "/home/${config.home.username}";

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "24.11"; # Please read the comment before changing.

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
      sessionVariables = {
        BROWSER = "firefox";
        EDITOR = "nvim";
      };
      sessionPath = ["$HOME/.local/bin"];
    };

    colorscheme = lib.mkOverride 1499 colorSchemes.dracula;
    specialisation = {
      dark.configuration.colorscheme = lib.mkOverride 1498 config.colorscheme;
      light.configuration.colorscheme = lib.mkOverride 1498 config.colorscheme;
    };

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

      ".colorscheme".text = config.colorscheme.slug;
      ".colorscheme.json".text = builtins.toJSON config.colorscheme;
    };

    home.packages = let
      specialisation = pkgs.writeShellScriptBin "specialisation" ''
        profiles="$HOME/.local/state/nix/profiles"
        current="$profiles/home-manager"
        base="$profiles/home-manager-base"

        # If current contains specialisations, link it as base
        if [ -d "$current/specialisation" ]; then
          echo >&2 "Using current profile as base"
          ln -sfT "$(readlink "$current")" "$base"
        # Check that $base contains specialisations before proceeding
        elif [ -d "$base/specialisation" ]; then
          echo >&2 "Using previously linked base profile"
        else
          echo >&2 "No suitable base config found. Try 'home-manager switch' again."
          exit 1
        fi

        if [ "$1" = "list" ] || [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
          find "$base/specialisation" -type l -printf "%f\n"
          exit 0
        fi

        echo >&2 "Switching to ''${1:-base} specialisation"
        if [ -n "$1" ]; then
          "$base/specialisation/$1/activate"
        else
          "$base/activate"
        fi
      '';
      toggle-theme = pkgs.writeShellScriptBin "toggle-theme" ''
        if [ -n "$1" ]; then
          theme="$1"
        else
          current="$(${lib.getExe pkgs.jq} -re '.kind' "$HOME/.colorscheme.json")"
          if [ "$current" = "light" ]; then
            theme="dark"
          else
            theme="light"
          fi
        fi
        ${lib.getExe specialisation} "$theme"
      '';
    in [specialisation toggle-theme];
  };
}
