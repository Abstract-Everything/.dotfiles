The repository is designed to work inside of the home directory instead of being separate, the install-dotfiles script will set this up.

```
curl -fLo .install-dotfiles.sh https://raw.githubusercontent.com/Abstract-Everything/.dotfiles/master/.install-dotfiles.sh
chmod +x ./.install-dotfiles.sh
./.install-dotfiles.sh
```

To set up neovim use the setup-neovim script available in the repository, some dependencies are required in order to install it.

Make sure that the following dependencies are installed
```
curl
nodejs
npm
clangd
neovim
```

Then execute the setup-neovim script.
```
cd ~
chmod +x ./.setup-neovim.sh
./.setup-neovim.sh
```
