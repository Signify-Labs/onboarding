setup() {
  load test_helper
  setup_mock_bin
  source "$REPO_ROOT/lib/log.sh"
  source "$REPO_ROOT/lib/optional.sh"
  file="$BATS_TEST_TMPDIR/Brewfile.optional"
  {
    echo 'cask "keepme"  # default: yes'
    echo 'cask "skipme"  # default: no'
  } >"$file"
}

@test "install_optional is a no-op when the file is missing" {
  run install_optional "$BATS_TEST_TMPDIR/does-not-exist"
  [ "$status" -eq 0 ]
  [[ $output == *"No optional"* ]]
}

@test "install_optional installs default-yes and skips default-no under --yes" {
  cat >"$MOCK_BIN/brew" <<'EOF'
#!/usr/bin/env bash
[[ "$1" == "list" ]] && exit 1
exit 0
EOF
  chmod +x "$MOCK_BIN/brew"
  ASSUME_YES=1 run install_optional "$file"
  [ "$status" -eq 0 ]
  [[ $output == *"Installed keepme"* ]]
  [[ $output == *"Skipped skipme"* ]]
  [[ $output != *"Installed skipme"* ]]
}

@test "install_optional skips a cask that is already installed" {
  mock brew 0
  ASSUME_YES=1 run install_optional "$file"
  [ "$status" -eq 0 ]
  [[ $output == *"keepme already installed"* ]]
  [[ $output != *"Installed keepme"* ]]
}
