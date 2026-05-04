# Fish port of the oh-my-zsh `git` plugin.
# Source: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
{
  programs.fish = {
    functions = {
      git_current_branch = ''
        set -l ref (command git symbolic-ref --quiet HEAD 2>/dev/null)
        set -l ret $status
        if test $ret -ne 0
          test $ret -eq 128; and return
          set ref (command git rev-parse --short HEAD 2>/dev/null); or return
        end
        string replace -r '^refs/heads/' "" -- $ref
      '';

      git_main_branch = ''
        command git rev-parse --git-dir >/dev/null 2>&1; or return
        for ref in refs/heads/{main,trunk,mainline,default,stable,master} \
                   refs/remotes/origin/{main,trunk,mainline,default,stable,master} \
                   refs/remotes/upstream/{main,trunk,mainline,default,stable,master}
          if command git show-ref -q --verify $ref
            echo (string split / -- $ref)[-1]
            return 0
          end
        end
        for remote in origin upstream
          set -l ref (command git rev-parse --abbrev-ref $remote/HEAD 2>/dev/null)
          if string match -q "$remote/*" -- $ref
            string replace "$remote/" "" -- $ref
            return 0
          end
        end
        echo master
        return 1
      '';

      git_develop_branch = ''
        command git rev-parse --git-dir >/dev/null 2>&1; or return
        for branch in dev devel develop development
          if command git show-ref -q --verify refs/heads/$branch
            echo $branch
            return 0
          end
        end
        echo develop
        return 1
      '';

      grename = ''
        if test -z "$argv[1]"; or test -z "$argv[2]"
          echo "Usage: grename old_branch new_branch"
          return 1
        end
        git branch -m $argv[1] $argv[2]
        if git push origin :$argv[1]
          git push --set-upstream origin $argv[2]
        end
      '';

      gunwipall = ''
        set -l _commit (git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)
        if test "$_commit" != (git rev-parse HEAD)
          git reset $_commit; or return 1
        end
      '';

      work_in_progress = ''
        command git -c log.showSignature=false log -n 1 2>/dev/null \
          | grep -q -- "--wip--"; and echo "WIP!!"
      '';

      gbda = ''
        git branch --no-color --merged \
          | command grep -vE "^([+*]|\s*("(git_main_branch)"|"(git_develop_branch)")\s*\$)" \
          | command xargs git branch --delete 2>/dev/null
      '';

      gbds = ''
        set -l default_branch (git_main_branch)
        test $status -eq 0; or set default_branch (git_develop_branch)
        git for-each-ref refs/heads/ --format='%(refname:short)' | while read -l branch
          set -l merge_base (git merge-base $default_branch $branch)
          set -l tree (git rev-parse "$branch^{tree}")
          set -l commit (git commit-tree $tree -p $merge_base -m _)
          set -l result (git cherry $default_branch $commit)
          if string match -q -- "-*" $result
            git branch -D $branch
          end
        end
      '';

      gccd = ''
        command git clone --recurse-submodules $argv; or return
        set -l last $argv[-1]
        if test -d "$last"
          cd "$last"
        else
          set -l name (string replace -r '\.git/?$' "" -- (string split / -- $last)[-1])
          cd $name
        end
      '';

      gdv = ''
        git diff -w $argv | view -
      '';

      gdnolock = ''
        git diff $argv ":(exclude)package-lock.json" ":(exclude)*.lock"
      '';

      glp = ''
        if test -n "$argv[1]"
          git log --pretty=$argv[1]
        end
      '';

      ggu = ''
        set -l b $argv[1]
        test (count $argv) -ne 1; and set b (git_current_branch)
        git pull --rebase origin $b
      '';

      ggl = ''
        if test (count $argv) -gt 1
          git pull origin $argv
        else
          set -l b $argv[1]
          test (count $argv) -eq 0; and set b (git_current_branch)
          git pull origin $b
        end
      '';

      ggp = ''
        if test (count $argv) -gt 1
          git push origin $argv
        else
          set -l b $argv[1]
          test (count $argv) -eq 0; and set b (git_current_branch)
          git push origin $b
        end
      '';

      ggf = ''
        set -l b $argv[1]
        test (count $argv) -ne 1; and set b (git_current_branch)
        git push --force origin $b
      '';

      ggfl = ''
        set -l b $argv[1]
        test (count $argv) -ne 1; and set b (git_current_branch)
        git push --force-with-lease origin $b
      '';

      ggpnp = ''
        if test (count $argv) -eq 0
          ggl; and ggp
        else
          ggl $argv; and ggp $argv
        end
      '';

      gtl = ''
        git tag --sort=-v:refname -n --list "$argv[1]*"
      '';
    };

    # Abbreviations expand inline on space, so the full command is visible
    # before execution. Mirrors aliases from the oh-my-zsh git plugin.
    shellAbbrs = {
      # add
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gapa = "git add --patch";
      gau = "git add --update";
      gav = "git add --verbose";
      gwip = ''git add -A; git rm (git ls-files --deleted) 2>/dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'';

      # am
      gam = "git am";
      gama = "git am --abort";
      gamc = "git am --continue";
      gamscp = "git am --show-current-patch";
      gams = "git am --skip";

      # apply
      gap = "git apply";
      gapt = "git apply --3way";

      # bisect
      gbs = "git bisect";
      gbsb = "git bisect bad";
      gbsg = "git bisect good";
      gbsn = "git bisect new";
      gbso = "git bisect old";
      gbsr = "git bisect reset";
      gbss = "git bisect start";

      # blame
      gbl = "git blame -w";

      # branch
      gb = "git branch";
      gba = "git branch --all";
      gbd = "git branch --delete";
      gbD = "git branch --delete --force";
      gbgd = ''LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '{print $1}' | xargs git branch -d'';
      gbgD = ''LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '{print $1}' | xargs git branch -D'';
      gbm = "git branch --move";
      gbnm = "git branch --no-merged";
      gbr = "git branch --remote";
      ggsup = "git branch --set-upstream-to=origin/(git_current_branch)";
      gbg = ''LANG=C git branch -vv | grep ": gone\]"'';

      # checkout
      gco = "git checkout";
      gcor = "git checkout --recurse-submodules";
      gcb = "git checkout -b";
      gcB = "git checkout -B";
      gcd = "git checkout (git_develop_branch)";
      gcm = "git checkout (git_main_branch)";

      # cherry-pick
      gcp = "git cherry-pick";
      gcpa = "git cherry-pick --abort";
      gcpc = "git cherry-pick --continue";

      # clean
      gclean = "git clean --interactive -d";

      # clone
      gcl = "git clone --recurse-submodules";
      gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";

      # commit
      gcam = "git commit --all --message";
      gcas = "git commit --all --signoff";
      gcasm = "git commit --all --signoff --message";
      gcs = "git commit --gpg-sign";
      gcss = "git commit --gpg-sign --signoff";
      gcssm = "git commit --gpg-sign --signoff --message";
      gcmsg = "git commit --message";
      gcsm = "git commit --signoff --message";
      gc = "git commit --verbose";
      gca = "git commit --verbose --all";
      "gca!" = "git commit --verbose --all --amend";
      "gcan!" = "git commit --verbose --all --no-edit --amend";
      "gcans!" = "git commit --verbose --all --signoff --no-edit --amend";
      "gcann!" = "git commit --verbose --all --date=now --no-edit --amend";
      "gc!" = "git commit --verbose --amend";
      gcn = "git commit --verbose --no-edit";
      "gcn!" = "git commit --verbose --no-edit --amend";
      gcfu = "git commit --fixup";

      # config
      gcf = "git config --list";

      # describe
      gdct = "git describe --tags (git rev-list --tags --max-count=1)";

      # diff
      gd = "git diff";
      gdca = "git diff --cached";
      gdcw = "git diff --cached --word-diff";
      gds = "git diff --staged";
      gdw = "git diff --word-diff";
      gdup = "git diff @{upstream}";
      gdt = "git diff-tree --no-commit-id --name-only -r";

      # fetch
      gf = "git fetch";
      gfa = "git fetch --all --tags --prune --jobs=10";
      gfo = "git fetch origin";

      # gui
      gg = "git gui citool";
      gga = "git gui citool --amend";

      # help
      ghh = "git help";

      # log
      glgg = "git log --graph";
      glgga = "git log --graph --decorate --all";
      glgm = "git log --graph --max-count=10";
      glods = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'';
      glod = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'';
      glola = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'';
      glols = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'';
      glol = ''git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'';
      glo = "git log --oneline --decorate";
      glog = "git log --oneline --decorate --graph";
      gloga = "git log --oneline --decorate --graph --all";
      glg = "git log --stat";
      glgp = "git log --stat --patch";
      gwch = "git log --patch --abbrev-commit --pretty=medium --raw";

      # ls-files
      gignored = ''git ls-files -v | grep "^[[:lower:]]"'';
      gfg = "git ls-files | grep";

      # merge
      gm = "git merge";
      gma = "git merge --abort";
      gmc = "git merge --continue";
      gms = "git merge --squash";
      gmff = "git merge --ff-only";
      gmom = "git merge origin/(git_main_branch)";
      gmum = "git merge upstream/(git_main_branch)";
      gmtl = "git mergetool --no-prompt";
      gmtlvim = "git mergetool --no-prompt --tool=vimdiff";

      # pull
      gl = "git pull";
      gpr = "git pull --rebase";
      gprv = "git pull --rebase -v";
      gpra = "git pull --rebase --autostash";
      gprav = "git pull --rebase --autostash -v";
      gprom = "git pull --rebase origin (git_main_branch)";
      gpromi = "git pull --rebase=interactive origin (git_main_branch)";
      gprum = "git pull --rebase upstream (git_main_branch)";
      gprumi = "git pull --rebase=interactive upstream (git_main_branch)";
      ggpull = ''git pull origin "(git_current_branch)"'';
      ggpur = "ggu";
      gluc = "git pull upstream (git_current_branch)";
      glum = "git pull upstream (git_main_branch)";

      # push
      gp = "git push";
      gpd = "git push --dry-run";
      "gpf!" = "git push --force";
      gpf = "git push --force-with-lease --force-if-includes";
      gpsup = "git push --set-upstream origin (git_current_branch)";
      gpsupf = "git push --set-upstream origin (git_current_branch) --force-with-lease --force-if-includes";
      gpv = "git push --verbose";
      gpoat = "git push origin --all; and git push origin --tags";
      gpod = "git push origin --delete";
      ggpush = ''git push origin "(git_current_branch)"'';
      gpu = "git push upstream";

      # rebase
      grb = "git rebase";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbi = "git rebase --interactive";
      grbo = "git rebase --onto";
      grbs = "git rebase --skip";
      grbd = "git rebase (git_develop_branch)";
      grbm = "git rebase (git_main_branch)";
      grbom = "git rebase origin/(git_main_branch)";
      grbum = "git rebase upstream/(git_main_branch)";

      # reflog
      grf = "git reflog";

      # remote
      gr = "git remote";
      grv = "git remote --verbose";
      gra = "git remote add";
      grrm = "git remote remove";
      grmv = "git remote rename";
      grset = "git remote set-url";
      grup = "git remote update";

      # reset
      grh = "git reset";
      gru = "git reset --";
      grhh = "git reset --hard";
      grhk = "git reset --keep";
      grhs = "git reset --soft";
      gpristine = "git reset --hard; and git clean --force -dfx";
      gwipe = "git reset --hard; and git clean --force -df";
      groh = "git reset origin/(git_current_branch) --hard";

      # restore
      grs = "git restore";
      grss = "git restore --source";
      grst = "git restore --staged";

      # rev-parse / rev-list
      grt = ''cd (git rev-parse --show-toplevel 2>/dev/null; or echo .)'';
      gunwip = ''git rev-list --max-count=1 --format="%s" HEAD | grep -q -- "--wip--"; and git reset HEAD~1'';

      # revert
      grev = "git revert";
      greva = "git revert --abort";
      grevc = "git revert --continue";

      # rm
      grm = "git rm";
      grmc = "git rm --cached";

      # shortlog
      gcount = "git shortlog --summary --numbered";

      # show
      gsh = "git show";
      gsps = "git show --pretty=short --show-signature";

      # stash
      gstall = "git stash --all";
      gstaa = "git stash apply";
      gstc = "git stash clear";
      gstd = "git stash drop";
      gstl = "git stash list";
      gstp = "git stash pop";
      gsta = "git stash push";
      gstu = "git stash push --include-untracked";
      gsts = "git stash show --patch";

      # status
      gst = "git status";
      gss = "git status --short";
      gsb = "git status --short --branch";

      # submodule
      gsi = "git submodule init";
      gsu = "git submodule update";

      # svn
      gsd = "git svn dcommit";
      "git-svn-dcommit-push" = "git svn dcommit; and git push github (git_main_branch):svntrunk";
      gsr = "git svn rebase";

      # switch
      gsw = "git switch";
      gswc = "git switch --create";
      gswd = "git switch (git_develop_branch)";
      gswm = "git switch (git_main_branch)";

      # tag
      gta = "git tag --annotate";
      gts = "git tag --sign";
      gtv = "git tag | sort -V";

      # update-index
      gignore = "git update-index --assume-unchanged";
      gunignore = "git update-index --no-assume-unchanged";

      # worktree
      gwt = "git worktree";
      gwta = "git worktree add";
      gwtls = "git worktree list";
      gwtmv = "git worktree move";
      gwtrm = "git worktree remove";

      # gitk
      gk = "gitk --all --branches &; disown";
      gke = "gitk --all (git log --walk-reflogs --pretty=%h) &; disown";
    };
  };
}
