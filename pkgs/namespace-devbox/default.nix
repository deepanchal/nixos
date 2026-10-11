{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "namespace-devbox";
  version = "0.0.198";

  src = pkgs.fetchurl {
    url = "https://get.namespace.so/packages/devbox/v${version}/devbox_${version}_linux_amd64.tar.gz";
    sha256 = "08b09921326f48487fdb50329561f20405cfb6683ab4879f28b7df5f1e0f7a51";
  };

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 devbox $out/bin/devbox
  '';

  meta = with lib; {
    homepage = "https://namespace.so/devbox";
    description = "CLI for managing Namespace devboxes";
    license = licenses.unfree;
    mainProgram = "devbox";
    platforms = ["x86_64-linux"];
  };
}
