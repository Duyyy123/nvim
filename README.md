# How to use
- Install nvim and install NvChad
- Clone this reposity to .config/nvim
## Post setup for image.nvim plugin
```sh
sudo pacman -Syu imagemagick
sudo pacman -S luarocks
luarocks --local --lua-version=5.1 install magick
```
## Post setup in nvim
- Set up Mason:
```
:MasonInstallAll
```
## Post setup for lazygit
```sh
sudo pacman -S lazygit
```
