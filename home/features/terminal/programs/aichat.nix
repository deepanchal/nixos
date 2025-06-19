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
        rev = "c4df18b4c82e36a7ce0adf0eeff1a3bcaf980425";
        sha256 = "sha256-swPbgS9KRzTnWVZ0+0QV/RPwqKh8uQ7dtCC5hcxtAnE=";
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

        # For any platform compatible with OpenAI's API
        - type: openai-compatible
          name: ollama
          api_base: http://localhost:11434/v1
          models:
            - name: deepseek-r1:1.5b
              max_input_tokens: 131072
            - name: llama3.1
              max_input_tokens: 128000
              supports_function_calling: true
            - name: llama3.2-vision
              max_input_tokens: 131072
              supports_vision: true
            - name: nomic-embed-text
              type: embedding
              default_chunk_size: 1000
              max_batch_size: 50

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
        compress_threshold: 100000000000
    '';
}
