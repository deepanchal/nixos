{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      withPython3 = true;
      withNodeJs = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile = {
    nvim = {
      source = ./astronvim;
      recursive = true;
    };
  };

  home = {
    packages = with pkgs; [
      # C/C++
      cmake
      # cmake-language-server
      gnumake
      checkmake
      gcc # c/c++ compiler, required by nvim-treesitter!
      llvmPackages.clang-unwrapped # c/c++ tools with clang-tools such as clangd
      lldb

      # PYTHON
      python3
      pyright
      ruff-lsp
      black
      poetry
      uv

      # node
      nodejs
      deno

      # RUST
      rustup

      # ZIG
      # zls

      # NIX
      nixd
      # nil
      statix # Lints and suggestions for the nix programming language
      deadnix # Find and remove unused code in .nix source files
      nixfmt-tree # Official nix code formatter
      alejandra # Nix Code Formatter

      # GOLANG
      go
      gomodifytags
      iferr # generate error handling code for go
      impl # generate function implementation for go
      gotools # contains tools like: godoc, goimports, etc.
      gopls # go language server
      delve # go debugger

      # LUA
      lua
      luarocks
      stylua
      lua-language-server

      # csharp
      dotnet-sdk
      csharp-ls
      csharpier

      # BASH
      nodePackages.bash-language-server
      shellcheck
      shfmt

      # JAVASCRIPT/TYPESCRIPT
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages."@tailwindcss/language-server"

      # SCALA
      # coursier
      # metals

      # arduino
      arduino-language-server
      arduino-cli
      arduino-ide
      avrdude

      # CLOUDNATIVE
      nodePackages.dockerfile-language-server-nodejs
      # terraform
      # terraform-ls
      # hadolint # Dockerfile linter

      # OTHERS
      taplo # TOML language server / formatter / validator
      nodePackages.yaml-language-server
      # sqlfluff # SQL linter
      actionlint # GitHub Actions linter
      # buf # protoc plugin for linting and formatting
      # proselint # English prose linter

      # MISC
      tree-sitter # common language parser/highlighter
      nodePackages.prettier # common code formatter
      # marksman # language server for markdown
      # glow # markdown previewer

      # OPTIONAL REQUIREMENTS:
      gdu # disk usage analyzer, required by AstroNvim
      ripgrep
      bottom
      lazygit
    ];
  };
}
