{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports =
    [
      # ../features/cli
      # ../features/nvim
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

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
  };
}
