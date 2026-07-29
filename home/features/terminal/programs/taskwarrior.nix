{ pkgs, lib, ... }: {
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
  };

  home.packages = [ pkgs.taskwarrior-tui ];

  programs.fish.shellAbbrs.tt = "taskwarrior-tui";

  xdg.dataFile."task/hooks/on-modify.timewarrior" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      export PATH=${lib.makeBinPath [ pkgs.python3 pkgs.timewarrior ]}:$PATH
      exec ${pkgs.python3}/bin/python3 ${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior "$@"
    '';
  };
}
