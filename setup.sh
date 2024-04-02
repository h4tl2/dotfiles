#!/usr/bin/env bash

echo "Setting up development env"

echo "Config macos specific"
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write -g ApplePressAndHoldEnabled -bool true
killall Finder

echo "Installing homebrew..."
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

echo "Tapping homebrew..."
TAPS=(
    homebrew/cask-fonts
)

PACKAGES=(
    git
    fzf
    awscli
    go
    neovim
    node
    yarn
    gh
    zsh
    zsh-completions
    # docker
    # docker-compose
    # colima
    bat
    ripgrep
    lazygit
    # gitui
    sqlite
    gnu-sed
    stow
    direnv
    # git-delta
    # ncdu
    # fd
)
echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Installing cask..."
CASKS=(
    amethyst
    # min
    iterm2
    spotify
    visual-studio-code
    # logitech-options
    # tableplus
    # chromium
    # notable
    google-chrome
    kubecontext
    tyke
    itsycal
    hiddenbar
    font-iosevka-nerd-font
    # rectangle
)
echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

echo "install useful key bindings and fuzzy completion..."
eval "$(brew --prefix)/opt/fzf/install"

echo "Create dev env..."
mkdir -p ~/code/scratches
cp .vimrc ~/.vimrc
# cp ./zsh/.zshrc ~/.zshrc
# cp ./zsh/.p10k.zsh ~/.p10k.zsh

echo "Stow dotfiles..."
# TODO refactor this stow
# stow config files
mkdir $HOME/.config
mkdir $HOME/.config/nvim
mkdir $HOME/.config/kitty
mkdir $HOME/.config/alacritty
mkdir $HOME/.config/gitui
stow --target=$HOME/.config/kitty kitty
stow --target=$HOME/.config/nvim nvim
stow --target=$HOME/.config/alacritty alacritty
stow --target=$HOME/.config/gitui gitui
stow --target=$HOME git
stow --target=$HOME vim
stow --target=$HOME tmux

echo "configure git..."
git config --global --add --bool push.autoSetupRemote true
echo "DONE!"
