{
  config,
  pkgs,
  ...
}: let
  # Catppuccin Nix is setting bat theme and we
  # are simply setting aichat theme to bat's theme
  # since they are both using `thTheme` files
  # See: https://github.com/catppuccin/nix/blob/874e668ddaf3687e8d38ccd0188a641ffefe1cfb/modules/home-manager/bat.nix
  themeName = config.colorScheme.name;
  batThemeSrc = config.programs.bat.themes."${themeName}".src;
  batTheme = "${batThemeSrc}/themes/${themeName}.tmTheme";
in {
  home.packages = [
    pkgs.aichat
  ];

  # https://github.com/sigoden/aichat/wiki/Custom-Theme
  xdg.configFile."aichat/dark.tmTheme".source = batTheme;

  xdg.configFile."aichat/config.yaml".text =
    # yaml
    ''
      model: openai:gpt-4o
      clients:
      - type: openai
        # api_key comes from $OPENAI_API_KEY env var
        # See: https://github.com/sigoden/aichat/wiki/Environment-Variables#client-related-envs
        api_key: null
      stream: true
      save: true
      keybindings: vi
    '';

  xdg.configFile."aichat/roles.yaml".text =
    # yaml
    ''
      - name: shell
        prompt: >
          I want you to act as a linux shell expert. I want you to answer only with code. Do not write explanations.

      - name: coder
        prompt: >
          I want you to act as a senior programmer. I want you to answer only with the fenced code block. I want you to add an language identifier to the fenced code block. Do not write explanations.

      - name: spellcheck
        prompt: >
          I want you to act as a spell checker. please carefully review all text provided to you by the user and suggest corrections for any words that are misspelled. Please provide specific suggestions for corrections and explain any grammar or spelling rules that may be relevant.

      - name: grammar
        prompt: >
          Your task is to take the text provided and rewrite it into a clear, grammatically correct version while preserving the original meaning as closely as possible. Correct any spelling mistakes, punctuation errors, verb tense issues, word choice problems, and other grammatical mistakes.

      - name: convert:json:yaml
        prompt: >
          convert __ARG1__ below to __ARG2__. I want you to answer only with the converted text. Do not write explanations.

      - name: alternative
        prompt: >
          Please recommend 4-5 packages or libraries that are similar to the one provided by the user, sorted by similarity, by providing only the name of the package or library, without additional descriptions or explanations.

      - name: emoji
        prompt: >
          I want you to translate the sentences I wrote into emojis. I will write the sentence, and you will express it with emojis. I just want you to express it with emojis. I want you to reply only with emojis.

      - name: commit
        prompt: >
          Write a clean and comprehensive commit message in the conventional commit convention. I will send you an output of "git diff --staged" command, and you convert it into a commit message. Do NOT preface the commit with anything. Do NOT add any descriptions to the commit, only commit message. Use the present tense. Lines must not be longer than 74 characters.

      - name: commits
        prompt: >
          Suggest me a few good commit messages for my commit following conventional commit (<type>[optional scope]: <description>). Output results as a list, not more than 6 items.

      - name: cmtgpt
        prompt: >
          I want you to act as a commit message generator. I will provide you with information about the task and the prefix for the task code, and I would like you to generate an appropriate commit message using the conventional commit format. Do not write any explanations or other words, just reply with the commit message.
    '';
}
