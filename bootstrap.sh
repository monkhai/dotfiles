#!/usr/bin/env bash
set -euo pipefail

DOTFILES_URL="https://github.com/Monkhai/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/Developer/skills}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This setup is for macOS." >&2
  exit 1
fi

if [[ "$(uname -m)" != "arm64" ]]; then
  echo "This setup requires an Apple Silicon Mac (Dia requires it)." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install Homebrew." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew was not found at /opt/homebrew/bin/brew." >&2
  exit 1
fi

if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
  if [[ -e "$DOTFILES_DIR" ]]; then
    echo "$DOTFILES_DIR exists but is not a Git checkout; move it aside first." >&2
    exit 1
  fi
  git clone "$DOTFILES_URL" "$DOTFILES_DIR"
fi

skip_casks=()
for app in \
  "1password:1Password.app" \
  "alt-tab:AltTab.app" \
  "chatgpt:ChatGPT.app" \
  "ghostty:Ghostty.app" \
  "raycast:Raycast.app" \
  "tailscale-app:Tailscale.app" \
  "thebrowsercompany-dia:Dia.app" \
  "zed:Zed.app"
do
  IFS=: read -r cask app_name <<< "$app"
  if [[ -d "/Applications/$app_name" || -d "$HOME/Applications/$app_name" ]]; then
    skip_casks+=("$cask")
    echo "Keeping existing $app_name"
  fi
done

if command -v codex >/dev/null 2>&1; then
  skip_casks+=("codex")
fi
if command -v claude >/dev/null 2>&1; then
  skip_casks+=("claude-code")
fi

if (( ${#skip_casks[@]} )); then
  export HOMEBREW_BUNDLE_CASK_SKIP="${HOMEBREW_BUNDLE_CASK_SKIP:+$HOMEBREW_BUNDLE_CASK_SKIP }${skip_casks[*]}"
fi

echo "Installing missing apps and command-line tools..."
brew bundle install --no-upgrade --file="$DOTFILES_DIR/Brewfile"

if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  if [[ -e "$HOME/.oh-my-zsh" ]]; then
    echo "$HOME/.oh-my-zsh exists but is incomplete; fix it before retrying." >&2
    exit 1
  fi
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

"$DOTFILES_DIR/install.sh"

skills_ready=false
if [[ -f "$SKILLS_DIR/bin/link.sh" ]]; then
  skills_ready=true
elif [[ -n "${SKILLS_REPO_URL:-}" ]]; then
  if [[ -e "$SKILLS_DIR" ]]; then
    echo "$SKILLS_DIR exists but has no bin/link.sh; fix it before retrying." >&2
    exit 1
  fi
  mkdir -p "$(dirname "$SKILLS_DIR")"
  git clone "$SKILLS_REPO_URL" "$SKILLS_DIR"
  skills_ready=true
fi

if [[ "$skills_ready" == true ]]; then
  bash "$SKILLS_DIR/bin/link.sh"
fi

cat <<'NEXT_STEPS'

Installed. Finish these sign-ins and macOS permissions:
  - Sign in to 1Password, Tailscale, Dia, ChatGPT, Raycast, Codex, and Claude Code.
  - Run `gh auth login`.
  - Grant the permissions requested by AltTab and Raycast.
  - Import your Raycast .rayconfig export if you want your old Raycast settings.
NEXT_STEPS

if [[ "$skills_ready" != true ]]; then
  echo "Shared skills are pending: no fetchable skills repo is configured." >&2
  echo "Rerun with SKILLS_REPO_URL set after the skills repo is published." >&2
  exit 2
fi
