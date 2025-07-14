{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./sound.nix
    ./utils.nix
    ./bluetooth.nix
  ];
}
