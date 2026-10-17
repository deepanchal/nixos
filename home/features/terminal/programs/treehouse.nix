{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    (inputs.treehouse.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {doCheck = false;})
  ];

  xdg.configFile."treehouse/config.toml".text =
    # toml
    ''
      max_trees = 32
    '';
}
