#!/bin/bash

# Tmux Install/Update

TMUX_CONFIG_URL="https://raw.githubusercontent.com/WVAviator/mac_setup/main/.tmux.conf"
TMUX_CONFIG_PATH="$HOME/.tmux.conf"
TPM_PATH="$HOME/.tmux/plugins/tpm"

if ! command -v brew &>/dev/null; then
    echo "Homebrew is required to install or upgrade tmux."
    exit 1
fi

if ! command -v git &>/dev/null; then
    echo "Git is required to install or upgrade tmux."
    exit 1
fi

# Install or upgrade tmux through Homebrew

brew-check() {
  local FORMULA=$1

  echo "Checking installation requirements for $FORMULA..."
  if brew list --formula | grep -q "^$FORMULA\$"; then
      echo "$FORMULA is already installed."
      echo "Upgrading $FORMULA..."
      brew upgrade "$FORMULA" > /dev/null
  else
      echo "$FORMULA is not installed."
      echo "Installing $FORMULA..."
      brew install "$FORMULA" > /dev/null
  fi
}

brew-check "tmux"

echo "Downloading tmux configuration..."
curl -o "$TMUX_CONFIG_PATH.tmp" -L "$TMUX_CONFIG_URL" > /dev/null
if [ $? -eq 0 ]; then
    mv "$TMUX_CONFIG_PATH.tmp" "$TMUX_CONFIG_PATH"
    echo "tmux configuration updated successfully."
else
    echo "Failed to download tmux configuration."
    rm "$TMUX_CONFIG_PATH.tmp"
    exit 1
fi

# Clone the tpm repo if it doesn't already exist, otherwise pull in new changes

if [ -d "$TPM_PATH" ]; then
  echo "Updating TPM..."
  git -C "$TPM_PATH" pull
else
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
fi

echo "Installing TPM plugins..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# Additional setup

echo "Updating script permissions for Kanagawa theme..."
chmod u+x $HOME/.tmux/plugins/tmux-kanagawa/kanagawa.tmux
chmod u+x $HOME/.tmux/plugins/tmux-kanagawa/scripts/*.sh

echo "Installing Extrakto dependencies..."
brew-check "bash"
brew-check "fzf"
