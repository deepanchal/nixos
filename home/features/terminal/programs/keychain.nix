{
  config,
  lib,
  ...
}: let
  keychain = config.programs.keychain;
in {
  options.keychainAgent.attachFish = lib.mkOption {
    type = lib.types.str;
    readOnly = true;
    default = "SHELL=fish ${keychain.package}/bin/keychain --eval --quiet --noask ${lib.escapeShellArgs keychain.keys} | source";
  };

  config.programs.keychain = {
    enable = true;
    keys = [
      "id_ed25519"
    ];
    extraFlags = [
      "--quiet"
    ];
  };
}
