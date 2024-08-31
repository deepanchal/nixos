# Powerlevel10k prompt segments for mise
#
# https://github.com/romkatv/powerlevel10k
# https://github.com/jdxcode/mise
# [Feature request: add segment for mise](https://github.com/romkatv/powerlevel10k/issues/2212)
#
# Usage in ~/.zshrc:
#
#   # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#   [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#   [[ -f ~/.p10k.mise.zsh ]] && source ~/.p10k.mise.zsh
#

() {
  function prompt_mise() {
    # All plugins
    # local plugins=("${(@f)$(mise current 3>/dev/null)}")

    # Plugins excluding ~/.tool-versions
    # local plugins=("${(@f)$(mise ls --current 2>/dev/null | awk '$3!="~/.tool-versions" {print $1, $2}')}")

    # Plugins including mise's config.toml
    # local plugins=("${(@f)$(mise ls --current 2>/dev/null | awk '!/\(symlink\)/ && $3!="~/.config/mise/config.toml" {print $1, $2}')}")

    local plugins=("${(@f)$(mise ls --current 2>/dev/null | awk '!/\(symlink\)/ && $3!="~/.tool-versions" && $3!="~/.config/mise/config.toml" {print $1, $2}')}")

    local plugin
    for plugin in ${(k)plugins}; do
      local parts=("${(@s/ /)plugin}")
      local tool=${(U)parts[1]}
      local version=${parts[2]}
      p10k segment -r -i "${tool}_ICON" -s $tool -t "$version"
    done
  }

  typeset -g POWERLEVEL9K_MISE_FOREGROUND=6

  typeset -g POWERLEVEL9K_MISE_RUBY_FOREGROUND=1
  typeset -g POWERLEVEL9K_MISE_PYTHON_FOREGROUND=6
  typeset -g POWERLEVEL9K_MISE_GOLANG_FOREGROUND=6
  typeset -g POWERLEVEL9K_MISE_NODEJS_FOREGROUND=2
  typeset -g POWERLEVEL9K_MISE_RUST_FOREGROUND=4
  typeset -g POWERLEVEL9K_MISE_DOTNET_CORE_FOREGROUND=5
  typeset -g POWERLEVEL9K_MISE_FLUTTER_FOREGROUND=4
  typeset -g POWERLEVEL9K_MISE_LUA_FOREGROUND=4
  typeset -g POWERLEVEL9K_MISE_JAVA_FOREGROUND=4
  typeset -g POWERLEVEL9K_MISE_PERL_FOREGROUND=6
  typeset -g POWERLEVEL9K_MISE_ERLANG_FOREGROUND=1
  typeset -g POWERLEVEL9K_MISE_ELIXIR_FOREGROUND=5
  typeset -g POWERLEVEL9K_MISE_POSTGRES_FOREGROUND=6
  typeset -g POWERLEVEL9K_MISE_PHP_FOREGROUND=5
  typeset -g POWERLEVEL9K_MISE_HASKELL_FOREGROUND=3
  typeset -g POWERLEVEL9K_MISE_JULIA_FOREGROUND=2

  # Substitute the default asdf prompt element
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=("${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/asdf/mise}")
}

