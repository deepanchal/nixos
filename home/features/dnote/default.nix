{pkgs, ...}: {
  home.packages = [
    # NOTE: These are coming from my custom packages
    pkgs.dnote-cli # See: pkgs/dnote-cli/default.nix
    pkgs.dnote-tui # See: pkgs/dnote-tui/default.nix
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
