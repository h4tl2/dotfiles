# nvim config

## Pre-requisite
- ripgrep
- fzf
- node 
- yarn
- nvim 0.11+
- [scratches](./lua/custom/scratches.lua)
- [gomvp](https://github.com/abenz1267/gomvp)
- [prettier-d](https://github.com/fsouza/prettierd)
- [eslint-d](https://www.npmjs.com/package/eslint_d)
- stylua

### Language servers
Servers use native `vim.lsp` config. Install them by hand, they must be in `PATH`.
```sh
go install golang.org/x/tools/gopls@latest
npm i -g typescript typescript-language-server
brew install lua-language-server
```

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
