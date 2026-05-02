{
  config,
  lib,
  ...
}:
let
  inherit (lib.strings) concatStrings;

  # 8-color palette mapping (matches p10k lean_8colors):
  #   1=red  2=green  3=yellow  4=blue  5=magenta  6=cyan  7=white

  leftSegments = [
    "os"
    "directory"
    "git_branch"
    "git_commit"
    "git_state"
    "git_status"
  ];

  rightSegments = [
    "status"
    "cmd_duration"
    "jobs"
    "direnv"
    "custom.mise"
    "nix_shell"
    # "aws"
    # "gcloud"
    # "azure"
    # "kubernetes"
    # "terraform"
    "time"
  ];

  toRef = s: "\${${s}}";
  format = concatStrings (
    (map toRef leftSegments)
    ++ [ "\${fill}" ]
    ++ (map toRef rightSegments)
    ++ [ "\${line_break}\${character}" ]
  );
in
{
  home.sessionVariables = {
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
  };

  programs.starship = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;

    enableTransience = config.programs.fish.enable;

    settings = {
      # nixpkgs starship implodes on lower values
      scan_timeout = 2;
      command_timeout = 2000;

      add_newline = false;

      inherit format;
      right_format = "";

      fill = {
        symbol = " ";
        style = "white";
      };

      line_break.disabled = false;

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      os = {
        disabled = false;
        format = "[$symbol]($style) ";
        style = "white";
        symbols = {
          NixOS = " ";
          Arch = "󰣇";
          Ubuntu = "";
          Debian = "";
          Fedora = "";
          Macos = "";
          Linux = "";
          Windows = "";
        };
      };

      directory = {
        style = "blue";
        format = "[  $path]($style)[$read_only]($read_only_style) ";
        truncation_length = 3;
        truncate_to_repo = false;
        truncation_symbol = "~/…/";
        read_only = " 󰌾";
        read_only_style = "red";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "green";
      };

      git_commit = {
        format = "[@$hash]($style) ";
        style = "green";
        commit_hash_length = 8;
        only_detached = true;
      };

      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "red";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "green";
        # branch markers
        ahead = "[⇡\${count}](green)";
        behind = "[⇣\${count}](green)";
        diverged = "[⇣\${behind_count}⇡\${ahead_count}](green)";
        up_to_date = "";
        # working tree markers (counts shown to mirror p10k)
        stashed = "[*\${count}](green) ";
        modified = "[!\${count}](yellow) ";
        staged = "[+\${count}](yellow) ";
        renamed = "[»\${count}](yellow) ";
        deleted = "[✘\${count}](red) ";
        conflicted = "[~\${count}](red) ";
        untracked = "[?\${count}](blue) ";
      };

      status = {
        disabled = false;
        format = "[$symbol$common_meaning$signal_name$maybe_int]($style) ";
        symbol = "✘ ";
        success_symbol = "";
        not_executable_symbol = "✘ ";
        not_found_symbol = "✘ ";
        sigint_symbol = "✘ ";
        signal_symbol = "✘ ";
        style = "red";
        pipestatus = true;
        pipestatus_format = "[$pipestatus] => [$symbol$common_meaning$signal_name$maybe_int]($style) ";
      };

      cmd_duration = {
        # match p10k threshold (3s)
        min_time = 3000;
        format = "[ $duration]($style) ";
        style = "yellow";
      };

      jobs = {
        format = "[$symbol$number]($style) ";
        symbol = "✦";
        symbol_threshold = 1;
        number_threshold = 2;
        style = "red";
      };

      direnv = {
        disabled = false;
        format = "[$symbol$loaded/$allowed]($style) ";
        symbol = "";
        style = "yellow";
        allowed_msg = "";
        not_allowed_msg = "denied";
        denied_msg = "denied";
        loaded_msg = "";
        unloaded_msg = "off";
      };

      # mise current tools — mirrors home/features/terminal/shell/zsh/p10k/p10k.mise.zsh
      custom.mise = {
        description = "mise current tool versions";
        when = "command -v mise >/dev/null 2>&1 && mise ls --current 2>/dev/null | grep -q .";
        command = ''
          mise ls --current 2>/dev/null \
            | awk '!/\(symlink\)/ && $3 !~ /tool-versions|config\/mise/ {printf "%s ", $2}'
        '';
        format = "[$symbol$output]($style) ";
        symbol = "󰍙 ";
        style = "cyan";
        shell = [
          "bash"
          "--noprofile"
          "--norc"
        ];
      };

      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "❄ ";
        style = "blue";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "";
      };

      aws = {
        format = "[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style) ";
        symbol = " ";
        style = "yellow";
      };

      gcloud = {
        format = "[$symbol$account(@$domain)(\\($region\\))]($style) ";
        symbol = "󱇶 ";
        style = "blue";
      };

      azure = {
        format = "[$symbol($subscription)]($style) ";
        symbol = "󰠅 ";
        style = "blue";
      };

      kubernetes = {
        disabled = false;
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        symbol = "󱃾 ";
        style = "cyan";
      };

      terraform = {
        format = "[$symbol$workspace]($style) ";
        symbol = "󱁢 ";
        style = "magenta";
      };

      time = {
        disabled = false;
        format = "[ $time]($style) ";
        style = "white";
        time_format = "%H:%M:%S";
        utc_time_offset = "local";
      };

      # delegate language version display to the mise custom module
      package.disabled = true;
    };
  };
}
