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

## Setup
Install required program
```sh
go install github.com/abenz1267/gomvp@latest
stow --target=$HOME/.config/nvim nvim
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
