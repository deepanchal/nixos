{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "atuin-export-fish-history";
  version = "0.1.0";

  src = pkgs.fetchFromGitLab {
    owner = "hmajid2301";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2egZYLnaekcYm2IzPdWAluAZogdi4Nf/oXWLw8+AnMk=";
  };

  vendorHash = "sha256-hLEmRq7Iw0hHEAla0Ehwk1EfmpBv6ddBuYtq12XdhVc=";

  patches = [./fix-schema.patch];

  ldflags = ["-s" "-w"];

  meta = with lib; {
    homepage = "https://gitlab.com/${src.owner}/${pname}";
    description = "Export atuin history to fish history file";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
