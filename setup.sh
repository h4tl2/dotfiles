#!/usr/bin/env bash

echo "Setting up development env"

echo "Installing xcode..."
xcode-select —-install

echo "Installing homebrew..."
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

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
    docker
    docker-compose
    colima
    bat
    ripgrep
    lazygit
    sqlite
    gnu-sed
)
echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Installing cask..."
CASKS=(
    iterm2
    spotify
    visual-studio-code
    logitech-options
    tableplus
    chromium
    notable
    google-chrome
    rectangle
    kubecontext
    tyke
    itsycal
    alt-tab
)
echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Create dev env..."
mkdir -p ~/code/scratches
cp .vimrc ~/.vimrc
# cp ./zsh/.zshrc ~/.zshrc
# cp ./zsh/.p10k.zsh ~/.p10k.zsh

echo "DONE!"
