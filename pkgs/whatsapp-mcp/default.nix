{
  pkgs,
  lib,
  ...
}: let
  version = "0-unstable-2025-07-13";

  src = pkgs.fetchFromGitHub {
    owner = "lharries";
    repo = "whatsapp-mcp";
    rev = "7d6a06dcdce1f01dfb24f60e1030d5efba9f3b88";
    hash = "sha256-z05PFRmODaIEfcFwNt7UO4crkgHGeI3fN95AXlYNeeY=";
  };

  stateDir = "$HOME/.local/share/whatsapp-bridge";

  bridge = pkgs.buildGoModule {
    pname = "whatsapp-bridge-unwrapped";
    inherit version src;
    sourceRoot = "${src.name}/whatsapp-bridge";

    patches = [./bridge-fixes.patch];

    postPatch = ''
      cp ${./go.mod} go.mod
      cp ${./go.sum} go.sum
    '';

    vendorHash = "sha256-ak6ddAvUgXkzHj8ArMGd8vLVIgl5TNKF4NmlxFj/krE=";
  };

  serverSrc = pkgs.runCommand "whatsapp-mcp-server-src" {} ''
    cp -r ${src}/whatsapp-mcp-server $out
    chmod -R u+w $out
    substituteInPlace $out/main.py \
      --replace-fail 'from mcp.server.fastmcp import FastMCP' 'from mcp.server.mcpserver import MCPServer as FastMCP'
    substituteInPlace $out/whatsapp.py \
      --replace-fail "os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'whatsapp-bridge', 'store', 'messages.db')" \
                     "os.path.expanduser('~/.local/share/whatsapp-bridge/store/messages.db')"
  '';

  python = pkgs.python3.withPackages (ps: [
    ps.mcp
    ps.httpx
    ps.requests
  ]);

  bridgeCommand = pkgs.writeShellApplication {
    name = "whatsapp-bridge";
    text = ''
      mkdir -p "${stateDir}"
      cd "${stateDir}"
      exec ${bridge}/bin/whatsapp-client "$@"
    '';
  };

  serverCommand = pkgs.writeShellApplication {
    name = "whatsapp-mcp-server";
    runtimeInputs = [pkgs.ffmpeg];
    text = ''
      exec ${python}/bin/python ${serverSrc}/main.py "$@"
    '';
  };
in
  pkgs.symlinkJoin {
    name = "whatsapp-mcp-${version}";
    paths = [
      bridgeCommand
      serverCommand
    ];

    meta = with lib; {
      homepage = "https://github.com/lharries/whatsapp-mcp";
      description = "WhatsApp bridge (linked device) and MCP server for reading and sending WhatsApp messages";
      license = licenses.mit;
      mainProgram = "whatsapp-mcp-server";
      platforms = platforms.unix;
    };
  }
