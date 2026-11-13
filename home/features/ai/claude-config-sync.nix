{config, ...}: let
  claudeDir = "${config.home.homeDirectory}/.claude";
in {
  sync.folders = {
    claude-skills = "${claudeDir}/skills";
    claude-commands = "${claudeDir}/commands";
  };
}
