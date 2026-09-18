{...}: {
  xdg.configFile."treehouse/config.toml".text =
    # toml
    ''
      max_trees = 32
    '';
}
