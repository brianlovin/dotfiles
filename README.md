# dotfiles

Personal configuration files synced across machines.

## Setup on a new machine

```bash
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then create machine-specific config files:

```bash
# Required: Git identity
cp ~/dotfiles/git/gitconfig.local.template ~/.gitconfig.local
# Edit with your name, email, and GPG key

# Optional: Machine-specific shell config
touch ~/.zshrc.local

# Optional: Additional SSH hosts
touch ~/.ssh/config.local
```

## What's included

### Claude Code (`claude/`)
- `settings.json` - Global permissions and settings
- `statusline.sh` - Custom statusline script
- `commands/` - Custom slash commands (rams, simplify, favicon)
- `skills/` - Installed skills (agent-browser, reclaude)

### Git (`git/`)
- `gitconfig` - Aliases, pull/push settings, defaults
- `gitconfig.local.template` - Template for machine-specific identity

### Shell (`shell/`)
- `zshrc` - Oh-my-zsh config, plugins, aliases

### SSH (`ssh/`)
- `config` - GitHub host config

## Machine-specific files (not synced)

These files are loaded by the synced configs but not tracked in git:

| File | Purpose |
|------|---------|
| `~/.gitconfig.local` | Name, email, GPG signing key |
| `~/.zshrc.local` | Machine-specific PATH, aliases, tools |
| `~/.ssh/config.local` | Additional SSH hosts |
| `~/.claude/settings.local.json` | Session permissions (auto-created) |

## Adding new dotfiles

1. Add the file to the appropriate directory in `~/dotfiles/`
2. Update `install.sh` to symlink it
3. Commit and push

## Inspiration

Structure inspired by [pondorasti/pondorasti](https://github.com/pondorasti/pondorasti/tree/main/packages/cli) which includes:
- Brewfile for reproducible app installation
- Cursor editor settings
- Compiled CLI for one-command bootstrap
