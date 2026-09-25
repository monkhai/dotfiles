#!/bin/sh
set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_SUFFIX="backup.$(date +%Y%m%d%H%M%S)"

link_path() {
  source_path="$1"
  destination_path="$2"

  mkdir -p "$(dirname "$destination_path")"

  if [ -L "$destination_path" ] && [ "$(readlink "$destination_path")" = "$source_path" ]; then
    return
  fi

  if [ -e "$destination_path" ] || [ -L "$destination_path" ]; then
    mv "$destination_path" "$destination_path.$BACKUP_SUFFIX"
  fi

  ln -s "$source_path" "$destination_path"
  echo "linked $destination_path"
}

link_path "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
link_path "$DOTFILES_DIR/zed/keymap.json" "$HOME/.config/zed/keymap.json"

link_path "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
link_path "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_path "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_path "$DOTFILES_DIR/zsh/personal" "$HOME/.config/zsh/personal"

mkdir -p "$HOME/.config/zsh/work" "$HOME/.config/zsh/private"
chmod 700 "$HOME/.config/zsh/work" "$HOME/.config/zsh/private"

echo "dotfiles installed"
