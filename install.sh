#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$DOTFILES/$1" dst="$HOME/.config/$1"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $dst"; return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak-$STAMP"; echo "backup  $dst -> $dst.bak-$STAMP"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"; echo "linked  $dst -> $src"
}

link nvim
link alacritty
