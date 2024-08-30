{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "dnote-cli";
  version = "v0.15.1";

  src = pkgs.fetchFromGitHub {
    owner = "dnote";
    repo = "dnote";
    rev = "cli-${version}";
    sha256 = "sha256-2vVopuFf9bx8U3+U4wznC/9nlLtan+fU5v9HUCEI1R4=";
  };

  vendorHash = "sha256-4mP5z3ZVlHYhItRjkbXvcOxVm6PuZ6viL2GHqzCH9tA=";

  subPackages = ["pkg/cli"]; # we only need dnote-cli

  tags = [
    "fts5"
  ];

  postInstall = ''
    # Rename cli bin to dnote
    mv $out/bin/cli $out/bin/dnote
    echo "Renamed dnote cli binary to dnote"
  '';

  # https://ryantm.github.io/nixpkgs/stdenv/meta/
  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${pname}";
    description = "A simple command line notebook for programmers";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
