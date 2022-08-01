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
    fd
    ripgrep
    lazygit
    sqlite
    gnu-sed
    stow
    direnv
    git-delta
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
)
echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Create dev env..."
mkdir -p ~/code/scratches
cp .vimrc ~/.vimrc
# cp ./zsh/.zshrc ~/.zshrc
# cp ./zsh/.p10k.zsh ~/.p10k.zsh

echo "Stow dotfiles..."
# stow config files
mkdir $HOME/.config
mkdir $HOME/.config/nvim
mkdir $HOME/.config/kitty
stow --target=$HOME/.config/kitty kitty
stow --target=$HOME/.config/nvim nvim
stow --target=$HOME git

echo "configure git..."
git config --global --add --bool push.autoSetupRemote true
# TODO: add .gitignore and .gitconfig
echo "DONE!"
