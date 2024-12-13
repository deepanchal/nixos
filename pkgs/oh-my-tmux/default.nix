{
  stdenv,
  lib,
}:
stdenv.mkDerivation {
  name = "oh-my-tmux";

  # fetchFromGitHub has trouble with the extracted directory from the ZIP file having a
  # preceding dot, so use fetchTarball instead
  src = builtins.fetchTarball {
    url = "https://github.com/gpakosz/.tmux/archive/4cb811769abe8a2398c7c68c8e9f00e87bad4035.tar.gz";
    sha256 = "sha256:12fxz1hhyayc5fvgj4cvj5sdx3za345gg8xqicv5dv63f2zjddkv";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir $out
    cp -r ./.tmux.conf* $out
  '';

  meta = with lib; {
    homepage = "https://github.com/gpakosz/.tmux";
    description = "Oh my tmux! My self-contained, pretty & versatile tmux configuration made with love";
    platforms = platforms.all;
    licence = licences.mit;
  };
}
