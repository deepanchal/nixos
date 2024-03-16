# Edit trueconfiguration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./asus.nix
    ./battery.nix
    ./nvidia.nix
    ./fingerprint-scanner.nix
    # ./yubikey.nix
    ./sound.nix
    # ./usb.nix
    ./time.nix
    # ./swap.nix
    ./bootloader.nix
    ./nix-settings.nix
    ./nixpkgs.nix
    ./gc.nix
    ./auto-upgrade.nix
    # ./linux-kernel.nix
    ./screen.nix
    ./display-manager.nix
    ./theme.nix
    ./internationalization.nix
    ./fonts.nix
    ./security-services.nix
    ./services.nix
    # ./printing.nix
    ./gnome.nix
    ./hyprland.nix
    ./environment-variables.nix
    ./bluetooth.nix
    ./networking.nix
    # ./mac-randomize.nix
    # ./open-ssh.nix
    ./firewall.nix
    # ./dns.nix
    # ./vpn.nix
    ./users.nix
    ./virtualization.nix
    ./programming-languages.nix
    # ./lsp.nix
    # ./rust.nix
    # ./wasm.nix
    # ./info-fetchers.nix
    ./utils.nix
    ./terminal-utils.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      deep = {
        imports = [
          ./home.nix
        ];
        _module.args.theme = import ../../modules/home-manager/theme;
      };
    };
  };

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
