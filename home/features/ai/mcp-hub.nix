{
  config,
  pkgs,
  ...
}: let
  home = config.home.homeDirectory;
  port = 7311;
  secrets = "${home}/.config/mcp-hub/secrets.env";

  sharedServers = {
    sentry = {
      command = "npx";
      args = ["-y" "@sentry/mcp-server@latest"];
    };
    xcode = {
      command = "npx";
      args = ["-y" "xcodebuildmcp@latest" "mcp"];
    };
    mobile = {
      command = "npx";
      args = ["-y" "@mobilenext/mobile-mcp@latest"];
    };
    whatsapp = {
      command = "whatsapp-mcp-server";
      args = [];
    };
  };

  serverConfig = (pkgs.formats.json {}).generate "mcp-hub-servers.json" {mcpServers = sharedServers;};

  mcpHub = pkgs.writeShellApplication {
    name = "mcp-hub";
    runtimeInputs = [pkgs.mcp-proxy pkgs.nodejs];
    text = ''
      export PATH="$PATH:${home}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin"
      export npm_config_cache="${home}/Library/Caches/mcp-hub/npm"
      if [ -f ${secrets} ]; then
        set -a
        # shellcheck source=/dev/null
        . ${secrets}
        set +a
      fi
      exec mcp-proxy --pass-environment --host 127.0.0.1 --port ${toString port} --named-server-config ${serverConfig}
    '';
  };
in {
  home.packages = [mcpHub];

  launchd.agents.mcp-hub = {
    enable = true;
    config = {
      ProgramArguments = ["${mcpHub}/bin/mcp-hub"];
      WorkingDirectory = home;
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "/tmp/mcp-hub.log";
      StandardErrorPath = "/tmp/mcp-hub.log";
    };
  };
}
