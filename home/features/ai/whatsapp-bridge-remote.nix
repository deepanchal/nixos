{pkgs, ...}: let
  bridgeHost = "deep@deep-m6-mini.allosaurus-dojo.ts.net";
in {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "wa-bridge";
      runtimeInputs = [pkgs.openssh];
      text = ''
        exec ssh -t ${bridgeHost} wa-bridge "$@"
      '';
    })
  ];
}
