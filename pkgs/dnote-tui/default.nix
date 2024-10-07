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
  version = "v0.5.10";

  src = pkgs.fetchFromGitHub {
    owner = "deepanchal";
    repo = pname;
    rev = version;
    sha256 = "sha256-dmtrhK3REaXWT6bGAdlJQy42pX8+05AWr5tOs47O268=";
  };

  cargoHash = "sha256-OWLn8JGUstvZdyzYgsksKbyQdfmWGIdm52XeZBVpMSA=";

  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${pname}";
    description = "Dnote TUI with ratatui";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [deepanchal];
  };
}
