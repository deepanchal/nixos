{
  config,
  lib,
  pkgs,
  ...
}: {
  options.t3code.package = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
    default = pkgs.t3code.override {enableClaude = true;};
  };

  config.home.packages = [config.t3code.package];
}
