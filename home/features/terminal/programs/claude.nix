{
  pkgs,
  inputs,
  ...
}:
let
in
{
  nixpkgs.overlays = [
    inputs.claude-code-nix.overlays.default
  ];

  home.packages = [
    # pkgs.claude-code
    # OR
    # pkgs.claude-code-bun
    (inputs.claude-code-nix.packages.${pkgs.stdenv.system}.claude-code-bun.override {
      bunBinName = "claude";
    })
  ];

}
