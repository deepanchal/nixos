{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "fuego";
  version = "0.35.0";

  src = pkgs.fetchFromGitHub {
    owner = "sgarciac";
    repo = "fuego";
    rev = "${version}";
    sha256 = "sha256-ljbjv4VYAMiuAgsr0t10SLeubZacuzaVtM7CZ5VqUhQ=";
  };

  vendorHash = "sha256-UbhXyuQjWwgZfr2R6KtHj8gvXejW9nonu4HmDLD4aEg=";

  # https://ryantm.github.io/nixpkgs/stdenv/meta/
  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${pname}";
    description = "Fuego is a command line client for the firestore database";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
