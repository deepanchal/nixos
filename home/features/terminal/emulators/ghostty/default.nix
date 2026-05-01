{
  config,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      term = "xterm-256color";

      window-decoration = false;
      window-padding-balance = true;
      window-padding-x = 0;
      window-padding-y = 0;
      window-width = 100;
      window-height = 25;
      maximize = true;
      background-opacity = 0.85;

      # See: https://github.com/ghostty-org/ghostty/discussions/3836#discussioncomment-11688264
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";

      font-family = "JetBrainsMono Nerd Font";
      font-style = "Regular";
      font-size = 10;

      confirm-close-surface = false;

      keybind = [
        "ctrl+shift+n=new_window"
        "ctrl+k=clear_screen"
        "ctrl+shift+space=write_screen_file:open"
      ];
    };
  };
}
