{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "codegrab";
  version = "v1.0.3";

  src = pkgs.fetchFromGitHub {
    owner = "epilande";
    repo = "codegrab";
    rev = "${version}";
    sha256 = "sha256-HJXxQSeH7cEPPhrRQrghTzkqbdKm4XH02Hv9ESjVilI=";
  };

  vendorHash = "sha256-sVmjyM8/lpQGC7vq5yvXuU+rtpKflqp7Gzf4nCi/Zxc=";

  subPackages = ["cmd/grab"]; # we only need grab bin

  # https://ryantm.github.io/nixpkgs/stdenv/meta/
  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${pname}";
    description = "Interactive CLI tool for selecting and bundling code into a single, LLM-ready output file";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

