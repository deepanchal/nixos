{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # upx
    git
    gh
    glab
    license-generator
    git-ignore
    pass-git-helper

    vim
    neovim

    brave
    google-chrome
    
    fd
    procs
    just
    sd
    du-dust
    tokei
    hyperfine
    grex
    delta
    nushell
    helix
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
    hyprpaper
    hyprpicker
    hyprkeys
    wl-clipboard

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
