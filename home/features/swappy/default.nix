{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swappy
  ];
  xdg.configFile = {
    # https://github.com/jtheoof/swappy?tab=readme-ov-file#config
    "swappy/config".text = ''
      [Default]
      save_dir=$HOME/Pictures/screenshots
      save_filename_format=ss-%Y%m%d-%H%M%S.png
      show_panel=true
      line_size=5
      text_size=20
      text_font=sans-serif
      paint_mode=brush
      early_exit=false
      fill_shape=false
    '';
  };
}
