{pkgs, ...}: {
  imports = [
    ./global
    ./features/ai
    ./features/desktop/theme/catppuccin.nix
    ./features/editors/nvim
    ./features/terminal/programs
    ./features/terminal/shell
  ];

  home.packages = [
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.jetbrains-mono

    pkgs.csvlens
    pkgs.jless
    pkgs.entr
    pkgs.httpie
    pkgs.kubectl
    pkgs.bitwarden-cli
    pkgs.namespace-cli
  ];
}
