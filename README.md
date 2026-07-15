# pave

Take a fresh Mac from zero to a working development environment with one script.

## Quick start

```sh
git clone https://github.com/csides/pave.git
cd pave
./bootstrap.sh
```

Re-run any time — every step is idempotent.

## What it does

1. Installs Xcode Command Line Tools and Homebrew.
2. Installs everything in [`Brewfile`](./Brewfile) via `brew bundle`.
3. Asks, per app, whether to install the opt-in extras in
   [`Brewfile.optional`](./Brewfile.optional) (browsers, AI tools).
4. Sets up oh-my-zsh with powerlevel10k and installs the shell dotfiles from
   [`dotfiles/`](./dotfiles) (backing up any existing files).
5. Generates a per-machine SSH key and GPG signing key, configures git to sign
   commits, and authenticates `gh` (uploading both keys to GitHub when it can).
6. Applies opinionated macOS defaults (optional; it asks first).
7. Walks you through the steps that can't be automated — logins and macOS
   privacy permissions.

### Options

```
--yes              Assume "yes" for all prompts (non-interactive)
--skip-brew        Skip Homebrew package installation
--skip-optional    Skip the opt-in optional apps
--skip-zsh         Skip oh-my-zsh and shell dotfiles
--skip-git         Skip SSH/GPG key generation and GitHub auth
--skip-macos       Skip macOS system defaults
--skip-checklist   Skip the manual-steps checklist
--brewfile PATH    Install from an alternate Brewfile
```

## Development

```sh
pre-commit install            # lint, format, and secret-scan on every commit
pre-commit run --all-files
bats tests/                   # unit tests
```

CI runs the same lint hooks on every push. A weekly macOS job validates the
Brewfile and proves the script is idempotent.
