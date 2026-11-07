{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./global
    ./features/ai
    ./features/ai/claude-remote-control.nix
    ./features/ai/claude-tmux-sessions.nix
    ./features/ai/mcp-hub.nix
    ./features/ai/t3code-server.nix
    ./features/ai/whatsapp-bridge.nix
    ./features/sync
    ./features/desktop/theme/catppuccin.nix
    ./features/editors/nvim
    ./features/editors/vscode
    ./features/editors/zed
    ./features/terminal/emulators/alacritty
    ./features/terminal/emulators/ghostty
    ./features/terminal/programs
    ./features/terminal/programs/unlock-keys.nix
    ./features/terminal/shell
  ];

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/projects/nixos";
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
    defaultCacheTtl = 86400;
    maxCacheTtl = 604800;
  };

  home.file.keybase.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/Keybase (deep)";

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
    pkgs.mender-cli

    pkgs.aria2
    pkgs.ffmpeg
    pkgs.imagemagick
    pkgs.rsync

    pkgs.mpv
    pkgs.scrcpy
  ];
}
