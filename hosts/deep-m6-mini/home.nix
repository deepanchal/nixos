{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    backupFileExtension = "hm-backup";
    sharedModules = [./named-launch-agents.nix];
    users = {
      deep = import ../../home/deep-m6-mini.nix;
    };
  };
}
