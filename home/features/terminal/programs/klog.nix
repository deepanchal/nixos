{
  config,
  pkgs,
  ...
}: let
  klogDir = "${config.home.homeDirectory}/Documents/klog";
in {
  home.packages = [pkgs.klog-time-tracker];

  xdg.configFile."klog/bookmarks.json".text = builtins.toJSON [
    {
      name = "default";
      path = "${klogDir}/time.klg";
    }
  ];

  sync.folders.klog = klogDir;
}
