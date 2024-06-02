# Setup format: https://github.com/vimjoyer/flake-starter-config
# Setup inspirations:
# - https://github.com/vimjoyer/flake-starter-config
# - https://github.com/sioodmy/dotfiles
# - https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles
# - https://github.com/fufexan/dotfiles
{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    # rust-overlay.url = "github:oxalica/rust-overlay";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.40.0"; # where {version} is the hyprland release version
      # url = "github:hyprwm/Hyprland"; # to follow the development branch
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.40.0"; # where {version} is the hyprland release version
      # url = "github:outfoxxed/hy3"; # to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-omz-plugin-pnpm = {
      url = "github:ntnyq/omz-plugin-pnpm";
      flake = false;
    };

    catppuccin-kvantum = {
      url = "github:catppuccin/Kvantum";
      flake = false;
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-btop = {
      url = "github:catppuccin/btop";
      flake = false;
    };
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
    catppuccin-yazi = {
      url = "github:catppuccin/yazi";
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
