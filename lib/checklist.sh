# shellcheck shell=bash

_open_privacy_pane() {
  open "x-apple.systempreferences:com.apple.preference.security?$1" 2>/dev/null || true
}

run_checklist() {
  log_step "Manual steps"
  if [[ ! -t 0 ]]; then
    log_skip "Non-interactive shell; skipping manual checklist"
    return 0
  fi
  log_info "These can't be automated. I'll walk you through each — do it, then continue."

  log_info ""
  log_info "1. Sign in to 1Password, then sign in to your browser."
  pause

  log_info "2. Grant Accessibility to Hex (so it can paste transcribed text)"
  log_info "   and any other automation tools."
  _open_privacy_pane "Privacy_Accessibility"
  pause

  log_info "3. Grant Microphone to Hex (for voice-to-text) and your meeting apps."
  _open_privacy_pane "Privacy_Microphone"
  pause

  log_info "4. Grant Screen Recording to your meeting and screenshot apps."
  _open_privacy_pane "Privacy_ScreenCapture"
  pause

  log_info "5. Confirm your SSH and GPG keys show up at https://github.com/settings/keys"
  log_info "   (the pave generates them; add them there if the gh upload was skipped)."
  pause

  log_success "Checklist complete"
}
