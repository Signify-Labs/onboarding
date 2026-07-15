# shellcheck shell=bash

_confirm_default() {
  local default="$1" prompt="$2" reply hint
  [[ $default == yes ]] && hint="[Y/n]" || hint="[y/N]"
  if [[ ${ASSUME_YES:-0} == 1 || ! -t 0 ]]; then
    [[ $default == yes ]]
    return
  fi
  printf '  ? %s %s ' "$prompt" "$hint"
  read -r reply
  [[ -z $reply ]] && {
    [[ $default == yes ]]
    return
  }
  [[ $reply =~ ^[Yy]$ ]]
}

install_optional() {
  local file="$1"
  log_step "Optional apps"
  if [[ ! -f $file ]]; then
    log_skip "No optional Brewfile at $file"
    return 0
  fi

  local line name default
  while IFS= read -r line; do
    [[ $line =~ ^[[:space:]]*cask[[:space:]]+\"([^\"]+)\" ]] || continue
    name="${BASH_REMATCH[1]}"
    [[ $line =~ default:[[:space:]]*yes ]] && default=yes || default=no

    if brew list --cask "$name" >/dev/null 2>&1; then
      log_skip "$name already installed"
      continue
    fi
    if _confirm_default "$default" "Install $name?"; then
      if brew install --cask "$name"; then
        log_success "Installed $name"
      else
        log_warn "Failed to install $name; continuing"
      fi
    else
      log_skip "Skipped $name"
    fi
  done <"$file"
}
