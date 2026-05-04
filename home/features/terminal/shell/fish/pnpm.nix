# Fish port of the omz-plugin-pnpm plugin.
# Source: https://github.com/ntnyq/omz-plugin-pnpm/blob/main/pnpm.plugin.zsh
# PNPM_HOME / PATH setup lives in ./default.nix (shellInit).
{
  programs.fish.shellAbbrs = {
    p = "pnpm";

    # Dependencies
    pa = "pnpm add";
    pad = "pnpm add --save-dev";
    pap = "pnpm add --save-peer";
    prm = "pnpm remove";
    pin = "pnpm install";
    pinf = "pnpm install --frozen-lockfile";
    pls = "pnpm list";
    pu = "pnpm update";
    pui = "pnpm update --interactive";
    puil = "pnpm update --interactive --latest";

    # Global dependencies
    pga = "pnpm add --global";
    pgls = "pnpm list --global";
    pgrm = "pnpm remove --global";
    pgu = "pnpm update --global";

    # Run scripts
    pr = "pnpm run";
    prun = "pnpm run";
    pd = "pnpm run dev";
    pb = "pnpm run build";
    psv = "pnpm run serve";
    pst = "pnpm start";
    pt = "pnpm test";
    ptc = "pnpm test --coverage";
    pln = "pnpm run lint";
    pdocs = "pnpm run docs";
    pfmt = "pnpm run format";
    pex = "pnpm exec";
    pdx = "pnpm dlx";

    # Misc
    pi = "pnpm init";
    ppub = "pnpm publish";
    pc = "pnpm create";
    pab = "pnpm approve-builds";

    # Monorepo
    pf = "pnpm -r --filter";
  };
}
