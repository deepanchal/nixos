{
  imports = [
    ./zellij
    ./direnv
    ./atuin.nix
    ./eza.nix
    ./bat.nix
    ./btop.nix
    ./ripgrep.nix
    ./lazygit.nix
    ./zoxide.nix
    ./tealdeer.nix
    ./git.nix
    ./gh.nix
    ./fd.nix
    ./git-cliff.nix
    ./tailspin.nix
    ./keychain.nix
    ./yazi.nix
    ./dnote.nix
    ./mise.nix
    ./tmux.nix
  ];

  programs.jq.enable = true;
  # programs.taskwarrior.enable = true;
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.command-not-found.enable = true; # https://discourse.nixos.org/t/which-package-is-mkfs-in/24882/3
  programs.awscli.enable = true;
  # programs.cava.enable = true;
  programs.fastfetch.enable = true;
}
