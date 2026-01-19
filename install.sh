#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"
echo ""

# ===== Git =====
if [ -f "$DOTFILES_DIR/git/gitconfig" ]; then
    ln -sf "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
    echo "✓ Git config installed"

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
echo "Machine-specific files needed:"
echo "  - ~/.gitconfig.local (required: name, email, gpg key)"
echo "  - ~/.zshrc.local (optional: machine-specific PATH, aliases)"
echo "  - ~/.ssh/config.local (optional: additional hosts)"
echo ""
echo "For Claude Code config, see: https://github.com/brianlovin/claude-config"
