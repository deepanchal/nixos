{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./sound.nix
    ./utils.nix
    ./bluetooth.nix
  ];

  home.packages = [
    # Git scripts
    (pkgs.writeShellScriptBin "ai-commit-recap" (builtins.readFile ./ai_commit_recap.sh))
  ];
}
