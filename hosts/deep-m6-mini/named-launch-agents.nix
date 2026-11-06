{lib, ...}: {
  options.launchd.agents = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      waitForNixStore = lib.mkDefault false;
    });
  };
}
