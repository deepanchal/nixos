{pkgs, ...}: {
  home.packages = [
    pkgs.tailspin # Log file highlighter in rust: https://github.com/bensadeh/tailspin
  ];
}
