{
  description = "NixOS Configuration";

  # The nixConfig here only affects the flake itself, not the system configuration!
  # See: https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      "https://anyrun.cachix.org"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";
    # rust-overlay.url = "github:oxalica/rust-overlay";
    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdph = {
      # Slack & Browser screensharing works on this commit for me
      # Also, building v1.3.2 from scratch is broken
      url = "github:hyprwm/xdg-desktop-portal-hyprland?ref=b9b97e5ba23fe7bd5fa4df54696102e8aa863cf6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # anyrun - a wayland launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-omz-plugin-pnpm = {
      url = "github:ntnyq/omz-plugin-pnpm";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Any one of these commands should work
      # sudo nixos-rebuild switch --flake ~/nixos/#zephyrion
      # nh os switch ~/nixos -H zephyrion
      # nh os switch
      zephyrion = nixpkgs.lib.nixosSystem {
        modules = [./hosts/zephyrion];
        specialArgs = {inherit inputs outputs;};
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Any one of these commands should work
      # home-manager switch --flake ~/nixos/.#deep@zephyrion --show-trace
      # nh home switch ~/nixos -c deep@zephyrion
      # nh home switch
      "deep@zephyrion" = home-manager.lib.homeManagerConfiguration {
        # pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home manager requires 'pkgs' instance
        pkgs = import nixpkgs {
          # config.allowBroken = true;
          # config.allowUnfree = true; # resistance is futile
          system = "x86_64-linux";
          overlays = [inputs.nur.overlay];
        };
        modules = [./home/zephyrion.nix];
        extraSpecialArgs = {inherit inputs outputs;};
      };

      "deep@manjarog" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home manager requires 'pkgs' instance
        modules = [./home/manjarog.nix];
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };
}
