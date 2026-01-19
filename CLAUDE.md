# Dotfiles

Personal configuration for git, zsh, ssh, and Homebrew packages.

## Commands

```bash
./install.sh                              # Create symlinks
brew bundle --file=~/Developer/dotfiles/Brewfile  # Install packages
```

**Required after install:** Create `~/.gitconfig.local` with name, email, and GPG key (see `git/gitconfig.local.template`).

For detailed workflows, see [.claude/rules/workflows.md](.claude/rules/workflows.md).
