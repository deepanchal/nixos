{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "claude-squad";
  version = "1.0.20";

  src = pkgs.fetchFromGitHub {
    owner = "smtg-ai";
    repo = "claude-squad";
    rev = "v${version}";
    sha256 = "sha256-VyZ6nU84pL4RPXDZDVGCcOh8FwId1XokImdI/i7uw7Y=";
  };

  vendorHash = "sha256-0EFCao5l9BNX6zdHVziV9ZwJX9v+BNu+e3tcFtYrDJ4=";

  nativeBuildInputs = [pkgs.makeWrapper];

  nativeCheckInputs = [pkgs.git pkgs.tmux];

  preCheck = ''
    export HOME=$TMPDIR
    git config --global user.email nix@localhost
    git config --global user.name nix
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/claude-squad $out/bin/cs
    wrapProgram $out/bin/cs \
      --suffix PATH : ${lib.makeBinPath [pkgs.tmux pkgs.git pkgs.gh]}
  '';

  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${pname}";
    description = "Manage multiple AI coding agents in separate tmux sessions and git worktrees";
    license = licenses.agpl3Only;
    mainProgram = "cs";
    platforms = platforms.unix;
  };
}
