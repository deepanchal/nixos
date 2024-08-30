{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
in {
  programs.git = {
    enable = true;
    userName = "Deep Panchal";
    userEmail = "deep302001@gmail.com";
    delta = {
      enable = true;
      options = {
        navigate = true; # use n and N to move between diff sections
        # side-by-side = true;
        diff-so-fancy = true;
        line-numbers = true;
      };
    };

    lfs = {
      enable = true;
    };

    aliases = {
      search = "log -p --all -S";
    };

    extraConfig = {
      safe = {
        directory = "*";
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      color = {
        diff = {
          meta = 11;
          frag = "magenta bold";
          commit = "yellow bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
        "diff-hightlight" = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHightlight = "green bold 22";
        };
      };
      # interactive = {
      #   diffFilter = "delta --color-only --tabs 2";
      # };
      # add = {
      #   interactive = {
      #     useBuiltIn = false; # required for git 2.37.0
      #   };
      # };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
