{
  pkgs,
  config,
  ...
}: let
  colors = config.colorscheme.palette;
  accent = config.theme.accent;
in {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        # catppuccin mocha theme: https://github.com/catppuccin/lazygit/blob/main/themes/mocha/green.yml
        theme = {
          activeBorderColor = ["#${accent}" "bold"];
          inactiveBorderColor = ["#a6adc8"];
          optionsTextColor = ["#${colors.base0D}"];
          selectedLineBgColor = ["#${colors.base02}"];
          cherryPickedCommitBgColor = ["#${colors.base03}"];
          cherryPickedCommitFgColor = ["#${accent}"];
          unstagedChangesColor = ["#${colors.base08}"];
          defaultFgColor = ["#${colors.base05}"];
          searchingActiveBorderColor = ["#${colors.base0A}"];
        };
        authorColors = {
          "*" = "#${colors.base07}";
        };
      };
      customCommands = [
        {
          key = "C";
          command = "git cz";
          context = "files";
          loadingText = "opening commitizen commit tool";
          subprocess = true;
        }
        {
          key = "E";
          description = "Add empty commit";
          context = "commits";
          command = "git commit - -allow-empty - m 'empty commit'";
          loadingText = "Committing empty commit...";
        }
        {
          key = "f";
          command = "git difftool -y {{.SelectedLocalCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
          context = "commitFiles";
          description = "Compare (difftool) with local copy";
        }
        {
          key = "<c-c>";
          description = "commit as non-default author";
          command = ''git commit -m "{{index .PromptResponses 0}}" --author="{{index .PromptResponses 1}} <{{index .PromptResponses 2}}>"'';
          context = "files";
          prompts = [
            {
              type = "input";
              title = "Commit Message";
              initialValue = "";
            }
            {
              type = "input";
              title = "Author Name";
              initialValue = "";
            }
            {
              type = "input";
              title = "Email Address";
              initialValue = "";
            }
          ];
          loadingText = "commiting";
        }
      ];
      git = {
        commit = {
          signOff = true;
        };
        paging = {
          colorArg = "always";
          # pager = "diff-so-fancy";
          pager = "delta --dark --paging=never --tabs 2";
        };
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium --oneline {{branchName}} --";
      };
    };
  };
}
