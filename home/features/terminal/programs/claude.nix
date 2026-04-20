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
    pkgs.claude-code
  ];
}
