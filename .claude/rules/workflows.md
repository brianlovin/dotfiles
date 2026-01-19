# Workflows

## Setting up a new machine

```bash
git clone git@github.com:brianlovin/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./compare.sh  # Preview what will change (dry-run)
./install.sh  # Apply changes

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
./compare.sh  # See what changed
./install.sh  # Apply changes
```

## Comparing before install (dry-run)

```bash
./compare.sh
```

Shows status for each file:
- `[OK]` Already symlinked correctly
- `[NEW]` Will create new symlink
- `[CONVERT]` Identical file will become symlink
- `[DIFFERS]` Local file has different content (review before installing)
- `[MISSING]` Required file not present

## Machine-specific files

These are sourced by synced configs but not tracked in git:

| File | Purpose |
|------|---------|
| `~/.gitconfig.local` | Name, email, GPG key (required) |
| `~/.zshrc.local` | Machine-specific PATH, aliases (optional) |
| `~/.ssh/config.local` | Additional SSH hosts (optional) |
