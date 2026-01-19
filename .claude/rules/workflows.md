# Workflows

## Setting up a new machine

```bash
git clone git@github.com:brianlovin/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh

# Required: create machine-specific git identity
cp git/gitconfig.local.template ~/.gitconfig.local
# Edit with name, email, GPG key

# Install Homebrew packages
brew bundle --file=~/Developer/dotfiles/Brewfile
```

## Adding a new dotfile

1. Add the file to the appropriate directory (`git/`, `shell/`, `ssh/`)
2. Update `install.sh` to create the symlink
3. Commit and push

## Updating Brewfile from current system

```bash
brew bundle dump --file=~/Developer/dotfiles/Brewfile --force
git add Brewfile && git commit -m "Update Brewfile" && git push
```

## Pulling changes on another machine

```bash
cd ~/Developer/dotfiles
git pull
./install.sh  # Re-run to pick up new symlinks
```

## Machine-specific files

These are sourced by synced configs but not tracked in git:

| File | Purpose |
|------|---------|
| `~/.gitconfig.local` | Name, email, GPG key (required) |
| `~/.zshrc.local` | Machine-specific PATH, aliases (optional) |
| `~/.ssh/config.local` | Additional SSH hosts (optional) |
