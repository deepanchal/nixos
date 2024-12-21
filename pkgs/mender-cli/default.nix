# See:
# - https://docs.mender.io/downloads#mender-cli
# - https://github.com/mendersoftware/mender-cli
{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "mender-cli";
  version = "1.12.0";
  src = pkgs.fetchurl {
    url = "https://downloads.mender.io/mender-cli/${version}/linux/mender-cli";
    sha256 = "sha256-HtUmLMPBw0mMA6Wl6sPCdRBv93ekpxJcDYhlXXR3ar8=";
  };
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mender-cli
    chmod +x $out/bin/mender-cli
  '';
  meta = with lib; {
    homepage = "https://mender.io";
    description = "Command line interface for Mender Server API";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
