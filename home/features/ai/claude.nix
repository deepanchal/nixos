{
  config,
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

  # Claude Code reads ~/.claude/CLAUDE.md — point it at the generic AGENTS.md.
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/AGENTS.md";
}
