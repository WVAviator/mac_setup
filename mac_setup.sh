
echo "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing git and the GitHub CLI"
brew install git
brew install gh

echo "Installing and configuring terminal environment"
brew install alacritty
brew install tmux
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


brew install --cask raycast
