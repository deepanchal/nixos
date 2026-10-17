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
    users = {
      deep = import ../../home/deep-m6-mini.nix;
    };
  };
}
