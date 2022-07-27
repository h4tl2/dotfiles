# dotfiles

## todo
- [x] neovim 
- [x] zsrhc 
- [x] iterm2
- [x] gitignore global
- [x] manage dotfiles with stow 

## fonts
- https://www.programmingfonts.org/#meslo
- https://www.nerdfonts.com/font-downloads

## stow
https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html

## extension
### vscode extension
```shell
code --list-extensions | xargs -L 1 echo code --install-extension
```

## tuning perf
- check zsh startuptime `for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done`
