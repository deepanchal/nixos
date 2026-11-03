{pkgs, ...}: {
  home.packages = [
    (pkgs.t3code.override {enableClaude = true;})
  ];
}
