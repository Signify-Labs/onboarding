# shellcheck shell=bash

OMZ_DIR="$HOME/.oh-my-zsh"

ensure_oh_my_zsh() {
  log_step "oh-my-zsh"
  if [[ -d $OMZ_DIR ]]; then
    log_skip "Already installed"
  else
    log_info "Installing oh-my-zsh…"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      || die "oh-my-zsh installation failed"
    log_success "oh-my-zsh installed"
  fi

  local p10k="$OMZ_DIR/custom/themes/powerlevel10k"
  if [[ -d $p10k ]]; then
    log_skip "powerlevel10k already present"
  else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k" \
      || die "powerlevel10k clone failed"
    log_success "powerlevel10k installed"
  fi
}

_install_dotfile() {
  local src="$1" dest="$2" backup
  mkdir -p "$(dirname "$dest")"
  if [[ -e $dest ]] && ! diff -q "$src" "$dest" >/dev/null 2>&1; then
    backup="$dest.pre-pave.$(date +%Y%m%d%H%M%S)"
    cp "$dest" "$backup"
    log_info "Backed up existing ${dest/#"$HOME"/~} to $(basename "$backup")"
  fi
  cp "$src" "$dest"
  log_success "Installed ${dest/#"$HOME"/~}"
}

link_dotfiles() {
  log_step "Shell dotfiles"
  local src="$REPO_DIR/dotfiles"
  local f
  for f in .zprofile .zshrc .p10k.zsh .gitconfig; do
    _install_dotfile "$src/$f" "$HOME/$f"
  done
  _install_dotfile "$src/ghostty.config" "$HOME/.config/ghostty/config"
}

setup_zsh() {
  ensure_oh_my_zsh
  link_dotfiles
}
