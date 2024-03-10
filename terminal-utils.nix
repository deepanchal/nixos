{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # upx
    git
    lazygit
    gh
    glab
    license-generator
    git-ignore
    pass-git-helper

    vim
    neovim

    brave
    google-chrome
    alacritty
    
    eza
    bat
    fd
    procs
    just
    sd
    du-dust
    ripgrep
    tokei
    hyperfine
    grex
    delta
    nushell
    zellij
    zoxide
    starship
    helix
    tealdeer
    eww # top bar
    # mcfly # terminal history
    # skim #fzf better alternative in rust
    # macchina #neofetch alternative in rust
    # xh #send http requests

    alejandra
    nvtop
    wget
    nix-index
    pciutils
    lshw
    btop
    dunst # For notification
    hyprpaper
    hyprpicker
    hyprkeys
    wl-clipboard
    rofi-wayland

    # For nvidia
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    
    tgpt
    progress
    noti
    topgrade
    rewrk
    wrk2
    nvtop
    monolith
    aria
    ouch
    duf
    jq
    trash-cli
    fzf
    mdcat
    pandoc
    lsd
    gping
    viu
    tre-command
    felix-fm
    chafa

    cmatrix
    pipes-rs
    rsclock
    cava
    figlet
  ];
}
