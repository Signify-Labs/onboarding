setup() {
  load test_helper
  HOME="$BATS_TEST_TMPDIR/home"
  REPO_DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$HOME" "$REPO_DIR/dotfiles"
  printf 'zprofile\n' >"$REPO_DIR/dotfiles/.zprofile"
  printf 'zshrc\n' >"$REPO_DIR/dotfiles/.zshrc"
  printf 'p10k\n' >"$REPO_DIR/dotfiles/.p10k.zsh"
  printf 'gitconfig\n' >"$REPO_DIR/dotfiles/.gitconfig"
  printf 'ghostty\n' >"$REPO_DIR/dotfiles/ghostty.config"
  source "$REPO_ROOT/lib/log.sh"
  source "$REPO_ROOT/lib/zsh.sh"
}

@test "link_dotfiles copies every dotfile into HOME" {
  run link_dotfiles
  [ "$status" -eq 0 ]
  [ "$(cat "$HOME/.zshrc")" = "zshrc" ]
  [ "$(cat "$HOME/.zprofile")" = "zprofile" ]
  [ "$(cat "$HOME/.p10k.zsh")" = "p10k" ]
  [ "$(cat "$HOME/.config/ghostty/config")" = "ghostty" ]
}

@test "link_dotfiles backs up a differing existing file" {
  printf 'old\n' >"$HOME/.zshrc"
  link_dotfiles
  [ "$(cat "$HOME/.zshrc")" = "zshrc" ]
  run compgen -G "$HOME/.zshrc.pre-pave.*"
  [ "$status" -eq 0 ]
}

@test "link_dotfiles leaves no backup when the file is identical" {
  printf 'zshrc\n' >"$HOME/.zshrc"
  link_dotfiles
  run compgen -G "$HOME/.zshrc.pre-pave.*"
  [ "$status" -ne 0 ]
}

@test "ensure_oh_my_zsh skips when oh-my-zsh and powerlevel10k are present" {
  mkdir -p "$OMZ_DIR/custom/themes/powerlevel10k"
  run ensure_oh_my_zsh
  [ "$status" -eq 0 ]
  [[ $output == *"Already installed"* ]]
}
