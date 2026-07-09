{...}: {
  imports = [
    ./claude.nix
  ];

  # Generic, tool-agnostic agent instructions; tool-specific files symlink here.
  home.file."AGENTS.md".source = ./AGENTS.md;
}
