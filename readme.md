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

### Chrome extension
- octotree or gitako
- refined-github
- session-buddy
- picture-in-picture
- cors
- react-dev

## setting up icons
*credit to https://github.com/DinkDonk/kitty-icon*
```
extract: `tar -xzvf icons.tar.gz`
compress: `tar -czvf icons.tar.gz *.icns`

Find `*.app` in the Applications folder, select it and press ⌘ + i.
Drag `*.icns` onto the application icon. 

Delete the icon cache and restart Dock:
$ rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
```
## tuning perf
- check zsh startuptime `for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done`
