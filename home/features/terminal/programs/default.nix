{ config, pkgs, ...}: {
  imports = [
    ./zellij
    ./direnv
    ./tmux
    ./television
    ./atuin.nix
    ./aichat.nix
    ./eza.nix
    ./bat.nix
    ./btop.nix
    # Unlinked in favour of walker's clipboard provider; config kept for reference.
    # ./clipse.nix
    ./ripgrep.nix
    ./lazygit.nix
    ./zoxide.nix
    ./tealdeer.nix
    ./git.nix
    ./gh.nix
    ./glow.nix
    ./fd.nix
    ./git-cliff.nix
    ./tailspin.nix
    ./keychain.nix
    ./yazi.nix
    ./dnote.nix
    ./mise.nix
    # ./vale.nix
  ];

  home.packages = [
    pkgs.impala # wifi tui
    pkgs.bluetui # bluetooth tui
    pkgs.tenere # llm tui
  ];

  programs.jq.enable = true;
  # programs.taskwarrior.enable = true;
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.command-not-found.enable = true; # https://discourse.nixos.org/t/which-package-is-mkfs-in/24882/3
  # programs.awscli.enable = true;
  # programs.cava.enable = true;
  programs.fastfetch.enable = true;


  ###################
  # Services
  ###################

  systemd.user.services.gpg-import-key = {
    Unit = {
      Description = "Import GPG secret key from the sops-deployed file (see hosts/common/optional/sops.nix)";
      After = [ "gpg-agent.service" ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "gpg-import-key" ''
        set -eu
        key="$HOME/.secrets/gpg-private.asc"
        if [ -f "$key" ]; then
          ${pkgs.gnupg}/bin/gpg --batch --import "$key" || true
        fi
      ''}";
    };
  };

}
