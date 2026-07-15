# CLAUDE.md

Guidance for working in this repository.

## What this is

A macOS **"pave"** script: it takes a brand-new Mac from a near-zero state to a
fully functional development machine — installing applications and developer
tooling, applying sane system defaults, and walking the user through the manual
steps that genuinely can't be automated. There is no "nuke" step; it assumes a
fresh machine.

## Guiding principles

1. **Automate the automatable, checklist the rest.** A large share of macOS setup
   cannot be scripted — anything behind interactive auth (Apple ID, 1Password,
   SSO, VPN) and anything gated by macOS TCC privacy permissions (Accessibility,
   Full Disk Access, Screen Recording, etc.) requires a human or an MDM profile.
   Do not fight this. Install what can be installed, then **pause and guide the
   human** with clear instructions and `open "x-apple.systempreferences:..."`
   deep-links. Never pretend a manual step was automated.

2. **Idempotent above all.** Every step must be safe to run repeatedly. Re-running
   `bootstrap.sh` on an already-set-up machine should be an uneventful no-op.
   Guard every action with an "is this already done?" check. This is also the
   core property the tests verify.

3. **Declarative where possible.** Prefer expressing *what* should be installed as
   data (the `Brewfile`) over imperative install steps. Declarative state is
   easier to read, diff, and test.

4. **Readable and contributable.** Plain shell that any engineer can read and send
   a PR against. Favor clarity over cleverness. Make the code self-explanatory
   through good names and structure rather than narration. No hidden magic.

5. **Fail loudly and informatively.** On error, say what failed, why, and what the
   user can do. Pretty-printed, scannable output (clear step headers, ✓/✗).

6. **No secrets, ever.** Nothing sensitive committed. This repo is public.

## Conventions

- **Entry point:** `./bootstrap.sh` after cloning. Pretty-printed output now; a
  TUI may come later.
- **Software lives in `Brewfile`.** Add/remove apps there, not in shell logic.
- **Shared helpers live in `lib/`** (logging, prerequisites, brew, zsh/dotfiles,
  git identity, macOS defaults, manual checklist). Keep `bootstrap.sh` a thin
  orchestrator that calls them in order.
- **Keys are per-machine, never copied.** SSH and GPG signing keys are generated
  on each machine; machine-specific git config (the signing key) lives in
  `~/.gitconfig.local`, included by the committed `.gitconfig`. Never commit a
  key, fingerprint, or anything that ties one machine's identity into the repo.
- **Shell dotfiles live in `dotfiles/`** and are copied into `$HOME` (existing
  files are backed up). Keep them generic and hardcode-free (`$HOME`, not
  absolute paths).
- **Shell style:** `bash`, `set -euo pipefail`, pass `shellcheck` and `shfmt`.
- **Comments are a last resort.** Prefer self-explanatory names and structure.
  Add a comment only when code would otherwise be confusing — a non-obvious
  workaround, a tricky invariant, a "why" that isn't visible in the "what". Keep
  them succinct, and never narrate what the code plainly says.
- **Tests:** `bats` unit tests under `tests/`; CI runs lint on every push and an
  idempotency check on a macOS runner. If you add a step, add/extend its guard
  test.

## Things to keep in mind

- macOS-only. Don't add Linux/Windows branches.
- The bootstrap chicken-and-egg: Xcode Command Line Tools and Homebrew must be
  installed *before* anything else can run; handle them first and defensively.
- This repo is intended to be forked later into a multi-role version. Keep the
  orchestration clean enough that adding roles is a small, additive change — but
  do **not** build role support here.
