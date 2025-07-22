# Nix Configuration

# Neovim

To test neovim configuration changes without having to rebuild nix do the following:

- Create a soft link with a configuration name in .config:

```bash
cd ~/.config
ln -s <path/to/dotfiles>/config/nvim nvim-dotfiles
```

Then launch neovim as follows, works from any path:

```bash
NVIM_APPNAME=nvim-dotfiles nvim
```
