{ pkgs, inputs, ... }:
{
  imports = [
    ./astronvim
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      withPython3 = true;
      withNodeJs = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
