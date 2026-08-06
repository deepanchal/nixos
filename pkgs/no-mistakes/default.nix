{
  pkgs,
  lib,
  ...
}:
pkgs.buildGoModule rec {
  pname = "no-mistakes";
  version = "1.46.0";

  src = pkgs.fetchFromGitHub {
    owner = "kunchenguid";
    repo = "no-mistakes";
    rev = "v${version}";
    sha256 = "sha256-07X27qOCdEyjtA42aOmYet9Rynvymy3YIWbMgMEkdRo=";
  };

  vendorHash = "sha256-NZOYxNYvt4192uqKBdKRxdgrKFvWx3585psdCnRdPSM=";

  subPackages = ["cmd/no-mistakes"];

  # Upstream assumes an FHS layout: it shells out to a bare `ps` and pins the
  # daemon's systemd unit to a hardcoded /usr:/bin PATH. Both resolve to nothing
  # on NixOS. Patched here rather than wrapped because the binary records
  # os.Executable() into that unit and into the managed git hooks.
  postPatch = ''
    substituteInPlace \
      internal/gatecontext/process_unix.go \
      internal/update/daemon.go \
      internal/cli/lifecycle_log.go \
      internal/daemon/proc_unix.go \
      --replace-fail '"ps"' '"${pkgs.procps}/bin/ps"'

    substituteInPlace internal/shellenv/shellenv.go \
      --replace-fail 'filepath.Join(home, ".local", "bin"),' 'filepath.Join(home, ".nix-profile", "bin"),
			filepath.Join(home, ".local", "bin"),' \
      --replace-fail '"/opt/homebrew/bin",' '"/run/current-system/sw/bin",
		"/nix/var/nix/profiles/default/bin",
		"/opt/homebrew/bin",'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kunchenguid/no-mistakes/internal/buildinfo.Version=v${version}"
  ];

  # https://ryantm.github.io/nixpkgs/stdenv/meta/
  meta = with lib; {
    homepage = "https://github.com/${src.owner}/${pname}";
    description = "Git push proxy that runs an AI review/test/lint pipeline before forwarding to the remote";
    license = licenses.mit;
    mainProgram = "no-mistakes";
    platforms = platforms.all;
  };
}
