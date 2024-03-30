{pkgs, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        # catppuccin mocha theme: https://github.com/catppuccin/lazygit/blob/main/themes/mocha/green.yml
        theme = {
          lightTheme = false;
          activeBorderColor = ["#a6e3a1" "bold"];
          inactiveBorderColor = ["#a6adc8"];
          optionsTextColor = ["#89b4fa"];
          selectedLineBgColor = ["#313244"];
          cherryPickedCommitBgColor = ["#45475a"];
          cherryPickedCommitFgColor = ["#a6e3a1"];
          unstagedChangesColor = ["#f38ba8"];
          defaultFgColor = ["#cdd6f4"];
          searchingActiveBorderColor = ["#f9e2af"];
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
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --tabs 2";
        };
        git = {
          branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium --oneline {{branchName}} --";
        };
      };
    };
  };
}
