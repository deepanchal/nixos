{ pkgs, ... }:
{
  programs.ripgrep = {
    enable = true;

    # GLOBAL CONFIGURATION FILE FOR RIPGREP
    # See: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
    # Requires `RIPGREP_CONFIG_PATH` to be set
    arguments = [
      # Type additions
      "--type-add=style:*.{css,sass,less,stylus}"
      "--type-add=pug:*.{pug,jade}"
      "--type-add=tmpl:*.{html,hbs,pug}"
      "--type-add=dts:*.d.ts"
      "--type-add=spec:*.{spec,test}.{ts,tsx,js,jsx}"
      "--type-add=test:*.{spec,test}.{ts,tsx,js,jsx}"
      "--type-add=tsx:*.tsx"
      "--type-add=stories:**/*.stories.{ts,tsx,js,jsx,mdx}"
      "--type-add=jsx:*.jsx"
      "--type-add=gql:*.{graphql,gql}"
      "--type-add=pkg:package.json"
      "--type-add=web:*.{html,css,js,jsx,ts,tsx,scss,sass,html.heex}"

      # Glob patterns to include/exclude files or folders
      "--glob=!.git/*"
      "--glob=!.svn"
      "--glob=!node_modules"
      "--glob=!build"
      "--glob=!dist"
      "--glob=!bower_components"
      "--glob=!target"
      "--glob=!{package-lock.json,yarn.lock,poetry.lock,Gemfile.lock,pnpm-lock.yaml,composer.lock}"
      "--glob=!__pycache__/*"
      "--glob=!*.pyc"
      "--glob=!*.svg"
      "--glob=!.DS_Store"
      "--glob=!*.cache"
      "--glob=!.Trash"
      "--glob=!tmp"
      "--glob=!coverage"
      "--glob=!test-results"
      "--glob=!playwright"
      "--glob=!playwright-report"
      "--glob=!blob-report"

      # Additional Flags
      # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
      "--max-columns=150"
      "--max-columns-preview"
      # Search hidden files / directories (e.g. dotfiles) by default
      "--hidden"
      # Because who cares about case!?
      "--smart-case"
      # Follow symbolic links while recursively searching.
      "--follow"
    ];
  };
}
