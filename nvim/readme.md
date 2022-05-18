# nvim config

## Setup
Install required program
```sh
brew install neovim ripgrep fzf
# install vim-plug for neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

cp -R ../nvim ~/.config/nvim
```
Setup plugins
```
# Inside nvim
:PlugInstall
```
## Todo
- keymapping for gitdiff
