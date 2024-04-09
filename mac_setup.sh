
echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing git and the GitHub CLI"
brew install git
brew install gh

git config --global core.editor lvim
git config --global init.defaultBranch main
git config --global pull.rebase true

echo "Installing and configuring Alacritty"

ALACRITTY_CONFIG_URL="https://raw.githubusercontent.com/WVAviator/mac_setup/main/alacritty.toml"
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
ALACRITTY_CONFIG_NAME="alacritty.toml"

brew install alacritty
mkdir -p "$ALACRITTY_CONFIG_DIR"
curl -o "$ALACRITTY_CONFIG_DIR/$ALACRITTY_CONFIG_NAME" -L "$ALACRITTY_CONFIG_URL"

echo "Installing Cascadia Mono Nerd Font"

NERD_FONT_URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/CascadiaMono.zip

if [ -f "$HOME/Library/Fonts/CascadiaMonoNF-Regular.ttf" ]; then
  echo "Cascadia Mono Nerd Font is already installed"
else
  curl -o "$HOME/Library/Fonts/CascadiaMono.zip" -L "$NERD_FONT_URL"
  unzip "$HOME/Library/Fonts/CascadiaMono.zip" -d ~/Library/Fonts
  rm "$HOME/Library/Fonts/CascadiaMono.zip"
fi


echo "Installing and configuring tmux"

TMUX_CONFIG_URL="https://raw.githubusercontent.com/WVAviator/mac_setup/main/.tmux.conf"
TMUX_CONFIG_PATH="$HOME/.tmux.conf"

brew install tmux
curl -o "$TMUX_CONFIG_PATH" -L "$TMUX_CONFIG_URL"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

chmod u+x "$HOME/.tmux/plugins/tmux-kanagawa/kanagawa.tmux"
chmod u+x "$HOME/.tmux/plugins/tmux-kanagawa/**/*.sh"

echo "Installing and configuring OhMyZsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i '' 's/^ZSH_THEME=".*"/ZSH_THEME="avit"/' ~/.zshrc || echo 'ZSH_THEME="avit"' >> ~/.zshrc

echo "Installing NVM and Node"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

if ! grep -q "NVM_DIR" ~/.zshrc; then
  # The nvm script is supposed to add this automatically, but just in case 
  echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
fi

source ~/.zshrc
nvm install node

echo "Installing Rust and Cargo"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Installing Lunarvim and dependencies"

brew install neovim
brew install make
brew install python3
brew install ripgrep
brew install lazygit

LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -s -- -y

rm -rf "$HOME/.config/lvim"
git clone https://github.com/WVAviator/lvim.git "$HOME/.config/lvim"
echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.zshrc"

echo "Installing SDKMAN and latest Java"

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java
sdk install maven

echo "Installing standard command line applications"

brew install awscli

echo "Installing standard GUI applications"

brew install --cask raycast
brew install --cask arc
brew install --cask jetbrains-toolbox
brew install --cask intellij-idea
brew install --cask datagrip
brew install --cask postman
brew install --cask docker
brew install --cask slack
brew install --cask zoom
brew install --cask microsoft-teams

source ~/.zshrc

