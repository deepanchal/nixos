{
  config,
  pkgs,
  inputs,
  ...
}:
let
in
{
  home.packages = [
    pkgs.codex
  ];

  # Claude Code reads ~/.claude/CLAUDE.md — point it at the generic AGENTS.md.
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/AGENTS.md";
}

