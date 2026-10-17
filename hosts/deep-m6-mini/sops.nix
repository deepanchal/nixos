{
  inputs,
  config,
  lib,
  ...
}: let
  user = "deep";
  home = config.users.users.${user}.home;
  secretDirs = lib.unique (map (secret: dirOf secret.path) (lib.attrValues config.sops.secrets));
in {
  imports = [
    inputs.sops-nix.darwinModules.sops
    ../common/optional/sops.nix
  ];

  system.activationScripts.preActivation.text = ''
    for dir in ${lib.escapeShellArgs secretDirs}; do
      mkdir -p "$dir"
      while [ "$dir" != ${lib.escapeShellArg home} ] && [ "$dir" != / ]; do
        chown ${user}:staff "$dir"
        dir=$(dirname "$dir")
      done
    done
  '';
}
