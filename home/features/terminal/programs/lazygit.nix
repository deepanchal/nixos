{
  pkgs,
  config,
  ...
}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        nerdFontsVersion = "3";
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
          key = "<c-a>";
          description = "Pick AI Commit";
          command = "aicommit2";
          context = "files";
          subprocess = true;
          showOutput = true;
        }
        {
          key = "<c-n>";
          description = "Pick AI Commit (no verify)";
          command = "aicommit2 --no-verify";
          context = "files";
          subprocess = true;
          showOutput = true;
        }
        {
          key = "E";
          description = "Add empty commit";
          context = "commits";
          command = "git commit --allow-empty -m 'empty commit'";
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
