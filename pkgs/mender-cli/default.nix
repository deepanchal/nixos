# See:
# - https://docs.mender.io/downloads#mender-cli
# - https://github.com/mendersoftware/mender-cli
{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "mender-cli";
  version = "1.12.0";

  src = pkgs.fetchFromGitHub {
    owner = "mendersoftware";
    repo = "mender-cli";
    rev = version;
    sha256 = "sha256-Pf87wTHXcFlnYsgx7ieiIJ9PWJFPUkFJYTkKJKmMFEQ=";
  };

  vendorHash = "sha256-MqyBa+wsbuXqtM4DL/QGBUWuEYlG8BRxIXq7O1LJUyM=";

  env.CGO_ENABLED = 0;

  ldflags = ["-X github.com/mendersoftware/mender-cli/cmd.Version=${version}"];

  meta = with lib; {
    homepage = "https://mender.io";
    description = "Command line interface for Mender Server API";
    license = licenses.asl20;
    mainProgram = "mender-cli";
    platforms = platforms.unix;
  };
}
