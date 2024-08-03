# This is mainly here to activate home-manager for impermanence
# along with nixos rebuild.
# See:
# - https://discourse.nixos.org/t/activating-home-manager-with-impermanence/31734
# - https://github.com/Misterio77/nix-starter-configs#use-home-manager-as-a-nixos-module
{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      deep = import ../../home/zephyrion.nix;
    };
  };
}
