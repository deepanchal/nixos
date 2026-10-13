{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "slack-cli";
  version = "4.10.0";

  src = pkgs.fetchurl {
    url = "https://github.com/slackapi/slack-cli/releases/download/v${version}/slack_cli_${version}_linux_amd64.tar.gz";
    sha256 = "1ymz595s4mfdl67y5asvzdm7vqfz419589dflqp55v64f1zv2wlp";
  };

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 bin/slack $out/bin/slack
  '';

  meta = with lib; {
    homepage = "https://docs.slack.dev/tools/slack-cli/";
    description = "Official Slack CLI for building Slack apps";
    license = licenses.asl20;
    mainProgram = "slack";
    platforms = ["x86_64-linux"];
  };
}
