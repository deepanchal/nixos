{pkgs, ...}: {
  imports = [
    ./global
    ./features/ai
    ./features/desktop/theme/catppuccin.nix
    ./features/editors/nvim
    ./features/editors/vscode
    ./features/editors/zed
    ./features/terminal/emulators/alacritty
    ./features/terminal/emulators/ghostty
    ./features/terminal/programs
    ./features/terminal/shell
  ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

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
