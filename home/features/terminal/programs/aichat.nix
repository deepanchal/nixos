{
  config,
  pkgs,
  ...
}: let
  # Catppuccin Nix is setting bat theme and we
  # are simply setting aichat theme to bat's theme
  # since they are both using `thTheme` files
  # See:
  # - https://github.com/catppuccin/nix/blob/874e668ddaf3687e8d38ccd0188a641ffefe1cfb/modules/home-manager/bat.nix
  # - https://github.com/catppuccin/bat/tree/699f60fc8ec434574ca7451b444b880430319941/themes
  batTheme = builtins.fetchurl {
    url = "https://gist.githubusercontent.com/deepanchal/23b5bbdd74be6ec1cc33c6451664448e/raw/c9832b1043fceb268c8696e14d630115f3d96114/aichat-catppuccin-mocha.tmTheme";
    sha256 = "sha256:1algv6hb3sz02cy6y3hnxpa61qi3nanqg39gsgmjys62yc3xngj6";
  };

  # This commit has new openai o3 and o4-mini models
  aichatOverlay = final: prev: {
    aichat = prev.aichat.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "sigoden";
        repo = "aichat";
        rev = "e9adefccdff050dd1bb52dff0a62f188e72ecd4c";
        sha256 = "sha256-Z6/B8ZM18h+t7XFpofH3HYoP/+IG+OI2Cu/dDh7k2ik=";
      };
    });
  };
in {
  nixpkgs.overlays = [aichatOverlay];
  home.packages = [
    pkgs.aichat
  ];

  # https://github.com/sigoden/aichat/wiki/Custom-Theme
  xdg.configFile."aichat/dark.tmTheme".source = batTheme;

  xdg.configFile."aichat/config.yaml".text =
    # yaml
    ''
      model: openai:o4-mini
      clients:
        - type: openai
          # api_key comes from $OPENAI_API_KEY env var
          # See: https://github.com/sigoden/aichat/wiki/Environment-Variables#client-related-envs
          api_key: null

        # See https://ai.google.dev/docs
        - type: gemini
          # api_key comes from $GEMINI_API_KEY env var
          # See: https://github.com/sigoden/aichat/wiki/Environment-Variables#client-related-envs
          api_key: null
          patch:
            chat_completions:
              '.*':
                body:
                  safetySettings:
                    - category: HARM_CATEGORY_HARASSMENT
                      threshold: BLOCK_NONE
                    - category: HARM_CATEGORY_HATE_SPEECH
                      threshold: BLOCK_NONE
                    - category: HARM_CATEGORY_SEXUALLY_EXPLICIT
                      threshold: BLOCK_NONE
                    - category: HARM_CATEGORY_DANGEROUS_CONTENT
                      threshold: BLOCK_NONE
      save: true
      keybindings: emacs
      save_session: true
      stream: false
      session:
        compress_threshold: 100000000
    '';
}
