# How to use
- Install nvim and install NvChad
- Clone this reposity to .confing/nvim
## Post setup for image.nvim plugin
```sh
sudo pacman -S luarocks
luarocks --local --lua-version=5.1 install magick
```
## Post setup in nvim
- Set up Mason:
```
:MasonInstallAll
```

- Set up for fold:
```
:set foldmethod=indent
:set foldcolumn=1
```
