{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.tmux];
  home.file = {
    ".tmux.conf".source = "${pkgs.oh-my-tmux}/.tmux.conf"; # NOTE: this is coming from custom pkgs
    ".tmux.conf.local".source = ./.tmux.conf.local;
  };
}
