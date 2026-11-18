_: {
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enable";
      aliases = {
        prc = "pr create";
        prco = "pr checkout";
      };
    };
  };
}
