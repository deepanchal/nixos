{...}: {
  imports = [
    ./claude.nix
    ./codex.nix
    ./claude-session-sync.nix
  ];

  # Generic, tool-agnostic agent instructions; tool-specific files symlink here.
  home.file."AGENTS.md".source = ./AGENTS.md;
}
