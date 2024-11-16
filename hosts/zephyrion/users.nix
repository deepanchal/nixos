{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  # Originally from https://github.com/iynaix/dotfiles/blob/9a837d2505cf5ad2189d20194aa52bbb9a752b77/nixos/users.nix
  # silence warning about setting multiple user password options
  # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
  options = {
    warnings = lib.mkOption {
      apply = lib.filter (
        w: !(lib.strings.hasInfix "The options silently discard others by the order of precedence" w)
      );
    };
  };
  config = {
    users = {
      # immutable users
      mutableUsers = false; # https://github.com/nix-community/impermanence/issues/120#issuecomment-1574224096
      users = {
        # Persistent passwords for users
        # create a password with for root and $user with:
        # sudo mkdir -p /persist/etc/shadow
        # mkpasswd -m sha-512 | sudo tee -a /persist/etc/shadow/root
        # See: https://reddit.com/r/NixOS/comments/o1er2p/tmpfs_as_root_but_without_hardcoding_your/h22f1b9/
        root = {
          initialPassword = "root";
          hashedPasswordFile = "/persist/etc/shadow/root";
        };
        deep = {
          isNormalUser = true;
          description = "Deep Panchal";
          initialPassword = "deep";
          hashedPasswordFile = "/persist/etc/shadow/deep";
          extraGroups = [
            "networkmanager"
            "input"
            "wheel" # Enable ‘sudo’ for the user.
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
    };
  };
}
