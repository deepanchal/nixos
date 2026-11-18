{
  config,
  lib,
  pkgs,
  ...
}: let
  desktopSettings = "${config.home.homeDirectory}/.t3/userdata/desktop-settings.json";
in {
  home.packages = [pkgs.t3code.unwrapped];

  home.activation.t3codeDisableLocalEnvironment = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$(dirname ${desktopSettings})"
    [ -s ${desktopSettings} ] || echo '{}' > ${desktopSettings}
    run ${lib.getExe pkgs.jq} '.localEnvironmentEnabled = false' ${desktopSettings} > ${desktopSettings}.tmp
    run mv ${desktopSettings}.tmp ${desktopSettings}
  '';
}
