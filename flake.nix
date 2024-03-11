{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # rust-overlay.url = "github:oxalica/rust-overlay";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.zephyrus = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [
          ./configuration.nix
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
          # ./security-services.nix
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
      };
    };
}
