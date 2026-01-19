# Dotfiles

Personal configuration files for git, zsh, ssh, and Homebrew packages.

## Repository structure

```
~/Developer/dotfiles/
├── git/
│   ├── gitconfig              # Shared git config (aliases, settings)
│   └── gitconfig.local.template  # Template for machine-specific identity
├── shell/
│   └── zshrc                  # Zsh configuration with oh-my-zsh
├── ssh/
│   └── config                 # SSH host configurations
├── Brewfile                   # Homebrew packages and casks
├── install.sh                 # Symlink installer
└── README.md
```

## Key workflows

### Setting up a new machine

```bash
git clone git@github.com:brianlovin/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh

# Create machine-specific git identity (required)
cp git/gitconfig.local.template ~/.gitconfig.local
# Edit ~/.gitconfig.local with name, email, GPG key

# Install Homebrew packages
brew bundle --file=~/Developer/dotfiles/Brewfile
```

### Adding a new dotfile to sync

1. Add the file to the appropriate directory (git/, shell/, ssh/)
2. Update `install.sh` to create the symlink
3. Commit and push

### Updating Brewfile from current system

```bash
brew bundle dump --file=~/Developer/dotfiles/Brewfile --force
git add Brewfile && git commit -m "Update Brewfile" && git push
```

### Pulling changes on another machine

```bash
cd ~/Developer/dotfiles
git pull
./install.sh  # Re-run to pick up any new symlinks
```

## Machine-specific files (not in repo)

These files are sourced/included by the synced configs but kept local:

| File | Purpose | Created by |
|------|---------|------------|
| `~/.gitconfig.local` | Name, email, GPG signing key | User (from template) |
| `~/.zshrc.local` | Machine-specific PATH, aliases | User (optional) |
| `~/.ssh/config.local` | Additional SSH hosts | User (optional) |

## Related

Claude Code configuration lives in a separate repo for more frequent updates:
- https://github.com/brianlovin/claude-config
- Clone to `~/Developer/claude-config`
