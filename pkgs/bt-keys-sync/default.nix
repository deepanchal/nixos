{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "bt-keys-sync";
  version = "v0.3.10";

  src = pkgs.fetchFromGitHub {
    owner = "KeyofBlueS";
    repo = "bt-keys-sync";
    rev = "e3276a9e5d3d655975e839bdd56db5edf6de843f";
    sha256 = "sha256-nzr/eFnC23wsGfZinrR87HzOfBbSQmh55yhodoFyCk0=";
  };

  # Dependencies that should exist in the runtime environment
  buildInputs = [];
  # Dependencies that should exist in the runtime environment and also propagated to downstream runtime environments
  propagatedBuildInputs = [];
  # Dependencies that should only exist in the build environment
  nativeBuildInputs = [pkgs.makeWrapper];
  # Dependencies that should only exist in the build environment and also propagated to downstream build environments
  propagatedNativeBuildInputs = [];

  installPhase = ''
    mkdir -p $out/bin
    cp bt-keys-sync.sh $out/bin/bt-keys-sync
    chmod +x $out/bin/bt-keys-sync
    # Wrap the script to include chntpw in PATH
    wrapProgram $out/bin/bt-keys-sync \
      --prefix PATH : ${pkgs.chntpw}/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${src.repo}";
    description = "Sync bluetooth pairing keys from windows to linux AND from linux to windows";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
