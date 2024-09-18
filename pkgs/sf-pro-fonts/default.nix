{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "sf-pro-fonts";
  version = "v0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "sahibjotsaggu";
    repo = "San-Francisco-Pro-Fonts";
    rev = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
    sha256 = "0zm9112y5x6z36mhcqlga4lmiqjhp1n7qiszmd3h3wi77z3c81cq";
  };

  installPhase = ''
    targetDir=$out/share/fonts/sf-pro-fonts
    mkdir -p $targetDir
    for font in ./*.{otf,ttf}; do
      mv -v "$font" $targetDir/
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${src.repo}";
    description = "The entire collection of San Francisco Pro Fonts obtained from https://developer.apple.com/fonts/";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
