{config, ...}: {
  programs.tmux = {
    enable = true;
    historyLimit = 20000;
  };
}

