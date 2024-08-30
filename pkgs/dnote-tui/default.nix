# NOTE: To build Rust packages, set `src.sha256` and `cargoSha256` to an empty string ("").
# Then, run `nix build #.<pkg-name>`. Nix will provide the correct hash values,
# which you can then update in your nix file.
{
  pkgs,
  lib,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  # TODO: Upstream this on dnote-tui repo with flake
  pname = "dnote-tui";
  version = "v0.5.9";

  src = pkgs.fetchFromGitHub {
    owner = "deepanchal";
    repo = pname;
    rev = version;
    sha256 = "sha256-UsIQPLUOZOv6QnOLrhZ1yDgCb7xD4ZBpczzgToaf1ew=";
  };

  cargoHash = "sha256-2RDDY9FbK/o9Q9/jaRaKD3FpeCtr0ERH3rQdHGUv910=";

  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${pname}";
    description = "Dnote TUI with ratatui";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [deepanchal];
  };
}
