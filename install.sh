#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"
echo ""

# ===== Claude Code =====
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES_DIR/claude/statusline.sh" ~/.claude/statusline.sh

# Claude commands (individual files to allow local additions)
mkdir -p ~/.claude/commands
for f in "$DOTFILES_DIR/claude/commands"/*.md; do
    [ -f "$f" ] && ln -sf "$f" ~/.claude/commands/
done

# Claude skills (directory symlinks per skill)
mkdir -p ~/.claude/skills
for skill in "$DOTFILES_DIR/claude/skills"/*/; do
    skill_name=$(basename "$skill")
    ln -sfn "$skill" ~/.claude/skills/"$skill_name"
done

echo "✓ Claude config installed"

# ===== Git =====
if [ -f "$DOTFILES_DIR/git/gitconfig" ]; then
    ln -sf "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
    echo "✓ Git config installed"

    # Prompt about local config if it doesn't exist
    if [ ! -f ~/.gitconfig.local ]; then
        echo "  → Create ~/.gitconfig.local with your name/email/gpg key"
        echo "  → See $DOTFILES_DIR/git/gitconfig.local.template"
    fi
fi

# ===== Zsh =====
if [ -f "$DOTFILES_DIR/shell/zshrc" ]; then
    ln -sf "$DOTFILES_DIR/shell/zshrc" ~/.zshrc
    echo "✓ Zsh config installed"

    if [ ! -f ~/.zshrc.local ]; then
        echo "  → Create ~/.zshrc.local for machine-specific config"
    fi
fi

# ===== SSH =====
if [ -f "$DOTFILES_DIR/ssh/config" ]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    ln -sf "$DOTFILES_DIR/ssh/config" ~/.ssh/config
    chmod 600 ~/.ssh/config
    echo "✓ SSH config installed"

    if [ ! -f ~/.ssh/id_ed25519 ]; then
        echo "  → Generate SSH key: ssh-keygen -t ed25519 -C \"your_email@example.com\""
    fi
fi

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
echo ""
echo "Don't forget to set up machine-specific files:"
echo "  - ~/.gitconfig.local (required: name, email, gpg key)"
echo "  - ~/.zshrc.local (optional: machine-specific PATH, aliases)"
echo "  - ~/.ssh/config.local (optional: additional hosts)"
