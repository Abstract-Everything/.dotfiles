The repository is designed to work inside of the home directory instead of being separate, the install-dotfiles script will set this up.

```
curl -fLo .install-dotfiles.sh https://raw.githubusercontent.com/Abstract-Everything/.dotfiles/master/.install-dotfiles.sh
chmod +x ./.install-dotfiles.sh
./.install-dotfiles.sh
```

For zsh config to get picked up defined the ZDOTDIR as specified in .config/zsh/.zprofile
