{ config, pkgs, ... }:
let
  colors = config.colorScheme.palette;
in
{
  services.clipse = {
    enable = true;
    allowDuplicates = false;
    historySize = 1024; # Default is 100
    imageDisplay = {
      heightCut = 2;
      scaleX = 9;
      scaleY = 9;
      type = "kitty"; # Options are basic, kitty or sixel
    };
    keyBindings = {
      choose = "enter";
      clearSelected = "S";
      up = "ctrl+p";
      down = "ctrl+n";
      end = "end";
      filter = "f";
      home = "home";
      more = "?";
      nextPage = "right";
      prevPage = "left";
      preview = "t";
      quit = "q";
      remove = "x";
      selectDown = "ctrl+down";
      selectSingle = "s";
      selectUp = "ctrl+up";
      togglePin = "p";
      togglePinned = "tab";
      yankFilter = "ctrl+s";
    };
    theme = {
      useCustomTheme = true;
      TitleFore = "#${colors.base}";
      TitleBack = "#${colors.mauve}";
      TitleInfo = "#${colors.primary}";
      NormalTitle = "#${colors.text}";
      DimmedTitle = "#${colors.subtext1}";
      SelectedTitle = "#${colors.red}";
      NormalDesc = "#${colors.subtext0}";
      DimmedDesc = "#${colors.overlay1}";
      SelectedDesc = "#${colors.pink}";
      StatusMsg = "#${colors.green}";
      PinIndicatorColor = "#${colors.yellow}";
      SelectedBorder = "#${colors.primary}";
      SelectedDescBorder = "#${colors.primary}";
      FilteredMatch = "#${colors.text}";
      FilterPrompt = "#${colors.green}";
      FilterInfo = "#${colors.primary}";
      FilterText = "#${colors.text}";
      FilterCursor = "#${colors.yellow}";
      HelpKey = "#${colors.overlay1}";
      HelpDesc = "#${colors.subtext0}";
      PageActiveDot = "#${colors.primary}";
      PageInactiveDot = "#${colors.overlay1}";
      DividerDot = "#${colors.primary}";
      PreviewedText = "#${colors.text}";
      PreviewBorder = "#${colors.primary}";
    };
  };
}
