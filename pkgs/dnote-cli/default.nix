{
  pkgs,
  lib,
  ...
}: let
  pkgName = "dnote-cli";
  pkgVersion = "v0.15.1";
in
  pkgs.buildGoModule rec {
    pname = pkgName;
    version = pkgVersion;

    src = pkgs.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "1ff4c075284055115d4b4f32c6b946dba13d5e95";
      sha256 = "sha256-80CT86YsLeAymnrtNQ5YHPbomKpGOgd7za51IqrILr4=";
    };

    vendorHash = "sha256-XCdzzlT3iYiaFlTljIlxIAYBxgN4jBp3yjetrTWBRfk=";

    doCheck = false;

    tags = [
      "fts5"
    ];

    postInstall = ''
      # Rename cli bin to dnote
      mv $out/bin/cli $out/bin/dnote
      echo "Renamed dnote cli binary to dnote"
      # Remove other binaries
      rm -v $out/bin/migrate
      rm -v $out/bin/server
      rm -v $out/bin/templates
      rm -v $out/bin/watcher
      echo "Removed excess dnote binaries"
    '';

    meta = with lib; {
      homepage = "https://github.com/dnote/dnote";
      description = "A simple command line notebook for programmers";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  }
