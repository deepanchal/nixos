{pkgs, ...}: {
  home.packages = [
    # NOTE: This is coming from my custom packages. See pkgs/dnote-cli/default.nix
    pkgs.dnote-cli
  ];

  # Dnote's config file is in yaml
  xdg.configFile."dnote/dnoterc".text =
    # yaml
    ''
      # vim: ft=yaml
      editor: nvim
      apiEndpoint: http://beacon.local:3333/api
      enableUpgradeCheck: false
    '';
}
