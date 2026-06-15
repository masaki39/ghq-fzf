function ${GHQ_FZF_FUNC}() {
  local result
  result=$(ghq-fzf) && [[ -n "$result" ]] && cd "$(ghq root)/$result"
}
