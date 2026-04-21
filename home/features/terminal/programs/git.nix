{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
in {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true; # use n and N to move between diff sections
      # side-by-side = true;
      diff-so-fancy = true;
      line-numbers = true;
    };
  };

  programs.git = {
    enable = true;
    signing = {
      key = "45FE8F325F0C658648AD56AFC0C2511B2C7608F4";
      signByDefault = true;
      format = "openpgp";
    };

    lfs = {
      enable = true;
    };

    settings = {
      user = {
        name = "Deep Panchal";
        email = "deep302001@gmail.com";
      };
      alias = {
        search = "log -p --all -S";
      };
      format = {
        signOff = true;
      };
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
