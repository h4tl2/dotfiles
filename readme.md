# dotfiles

## stow
https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html

## macos
### Finder
General 
- New Finder windows show -> Home Folder
Advanced 
- Show all filename extensions -> Yes
- how warning before changing an extension -> No
- When performing a search -> Search the current folder
View
- Show Path Bar
- Show Tab Bar
### set keystoke
Need to logout/in
```
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
```
## extension
some software/tools that I didn't turn on the autosync.
### vscode extension
```shell
code --list-extensions | xargs -L 1 echo code --install-extension
```
### Chrome extension
- octotree or gitako
- refined-github
- session-buddy
- picture-in-picture
- cors
- react-dev

## setting up icons
extract: `tar -xzvf icons.tar.gz`
compress: `tar -czvf icons.tar.gz *.icns`

*credit to https://github.com/DinkDonk/kitty-icon*
Find `*.app` in the Applications folder, select it and press ⌘ + i.
Drag `*.icns` onto the application icon. 
Delete the icon cache and restart Dock:
`
$ rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
`
## tuning perf
- check zsh startuptime `for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done`
