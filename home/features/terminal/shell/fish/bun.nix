# Fish port of the omz-plugin-bun plugin.
# Source: https://github.com/ntnyq/omz-plugin-bun/blob/main/bun.plugin.zsh
{
  programs.fish.shellAbbrs = {
    b = "bun";

    # Dependencies
    ba = "bun add";
    bad = "bun add --dev";
    brm = "bun remove";
    bls = "bun pm ls";
    bin = "bun install";
    bu = "bun update";
    biny = "bun install --yarn";

    # Global dependencies
    bga = "bun add --global";
    bgls = "bun pm ls --global";
    bgrm = "bun remove --global";
    bgu = "bun update --global";

    # Run scripts
    br = "bun run";
    brun = "bun run";
    bd = "bun run dev";
    bb = "bun run build";
    bs = "bun run serve";
    bst = "bun run start";
    bt = "bun run test";
    btc = "bun run test --coverage";
    bln = "bun run lint";
    bdocs = "bun run docs";
    bfmt = "bun run format";

    # Misc
    bi = "bun init";
    bc = "bun create";

    bx = "bun x";

    # Bundle
    bbd = "bun build";
  };
}
