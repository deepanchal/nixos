{
  pkgs,
  config,
  ...
}: let
  userHome = config.home.homeDirectory;
in {
  home.packages = [
    pkgs.swappy
  ];

  xdg.configFile = {
    # https://github.com/jtheoof/swappy#config
    "swappy/config".text =
      # ini
      ''
        [Default]
        save_dir=${userHome}/Pictures/screenshots
        save_filename_format=screenshot-%Y-%m-%d_%H-%M-%S.png
        show_panel=true
        line_size=5
        text_size=20
        text_font=JetBrainsMono Nerd Font
        paint_mode=brush
        early_exit=true
        fill_shape=false
      '';
  };
}
