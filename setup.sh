#!/usr/bin/env bash

echo "setting up"

xcode-select —-install

if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

PACKAGES=(
    git
    fzf
    awscli
    rust
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
    go
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
)
echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "DONE!"
