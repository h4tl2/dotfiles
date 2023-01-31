# nvim config

## Pre-requisite
- ripgrep
- fzf
- node 
- yarn
- [scratches](./lua/plugins/scratches.lua)
- [gomvp](https://github.com/abenz1267/gomvp)
- [vim-go](https://github.com/fatih/vim-go)
- [prettier-d](https://github.com/fsouza/prettierd)
- [eslint-d](https://www.npmjs.com/package/eslint_d)

## TODO
- [ ] a way to run test under the cursor
- [ ] migrate init.vim to init.lua
- [ ] use lazy.nvim

## Setup
Install required program
```sh
# install vim-plug for neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
go install github.com/abenz1267/gomvp@latest

stow --target=$HOME/.config/nvim nvim
```
Setup plugins
```
# Inside nvim
:PlugInstall # install plugins
:LspInstallInfo # install language server
```

### Scratches plugins
```
mkdir -p ~/code/scratches
touch ~/code/scratches/sc.md
```

## Performance
check nvim startup time
```
nvim --startuptime t.log
```
