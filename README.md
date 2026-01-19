# dotfiles

Personal configuration files synced across machines.

## Setup on a new machine

```bash
# 1. Clone and install dotfiles
git clone git@github.com:brianlovin/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh

# 2. Clone and install Claude config (separate repo)
git clone git@github.com:brianlovin/claude-config.git ~/Developer/claude-config
cd ~/Developer/claude-config
./install.sh

# 3. Install Homebrew packages
brew bundle --file=~/Developer/dotfiles/Brewfile
```

Then create machine-specific config files:

```bash
# Required: Git identity
cp ~/Developer/dotfiles/git/gitconfig.local.template ~/.gitconfig.local
# Edit with your name, email, and GPG key

# Optional: Machine-specific shell config
touch ~/.zshrc.local

# Optional: Additional SSH hosts
touch ~/.ssh/config.local
```

## What's included

### Git (`git/`)
- `gitconfig` - Aliases, pull/push settings, defaults
- `gitconfig.local.template` - Template for machine-specific identity

### Shell (`shell/`)
- `zshrc` - Oh-my-zsh config, plugins, aliases

### SSH (`ssh/`)
- `config` - GitHub host config

### Brewfile
Homebrew packages and casks for reproducible installs.

## Machine-specific files (not synced)

| File | Purpose |
|------|---------|
| `~/.gitconfig.local` | Name, email, GPG signing key |
| `~/.zshrc.local` | Machine-specific PATH, aliases, tools |
| `~/.ssh/config.local` | Additional SSH hosts |

## See also

- [claude-config](https://github.com/brianlovin/claude-config) - Claude Code settings, commands, and skills (separate repo for frequent updates)
