#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Syncing local changes to dotfiles repo..."
echo ""

# ===== Claude Skills =====
echo "Claude skills:"
for skill in ~/.claude/skills/*/; do
    skill_name=$(basename "$skill")
    repo_skill="$DOTFILES_DIR/claude/skills/$skill_name"

    # Skip if it's already a symlink pointing to our repo
    if [ -L "$skill" ]; then
        target=$(readlink "$skill")
        if [[ "$target" == "$DOTFILES_DIR"* ]]; then
            echo "  ✓ $skill_name (synced)"
            continue
        fi
    fi

    # It's a local-only skill
    if [ -d "$repo_skill" ]; then
        echo "  ~ $skill_name (exists in both - skipping)"
    else
        echo "  ? $skill_name (local only)"
    fi
done

echo ""
echo "Claude commands:"
for cmd in ~/.claude/commands/*.md; do
    [ -f "$cmd" ] || continue
    cmd_name=$(basename "$cmd")
    repo_cmd="$DOTFILES_DIR/claude/commands/$cmd_name"

    if [ -L "$cmd" ]; then
        target=$(readlink "$cmd")
        if [[ "$target" == "$DOTFILES_DIR"* ]]; then
            echo "  ✓ $cmd_name (synced)"
            continue
        fi
    fi

    if [ -f "$repo_cmd" ]; then
        echo "  ~ $cmd_name (exists in both - skipping)"
    else
        echo "  ? $cmd_name (local only)"
    fi
done

echo ""
echo "Commands:"
echo "  ./sync.sh add skill <name>    - Copy a local skill to dotfiles"
echo "  ./sync.sh add command <name>  - Copy a local command to dotfiles"
echo "  ./sync.sh pull                - Git pull and re-run install"
echo ""

# Handle subcommands
case "${1:-}" in
    add)
        case "${2:-}" in
            skill)
                if [ -z "${3:-}" ]; then
                    echo "Usage: ./sync.sh add skill <skill-name>"
                    exit 1
                fi
                skill_name="$3"
                src="$HOME/.claude/skills/$skill_name"
                dest="$DOTFILES_DIR/claude/skills/$skill_name"

                if [ ! -d "$src" ]; then
                    echo "Error: Skill not found at $src"
                    exit 1
                fi

                if [ -L "$src" ]; then
                    echo "Error: $skill_name is already a symlink (already synced?)"
                    exit 1
                fi

                echo "Copying $skill_name to dotfiles..."
                cp -r "$src" "$dest"

                echo "Creating symlink..."
                rm -rf "$src"
                ln -s "$dest" "$src"

                echo "✓ Skill '$skill_name' added to dotfiles and symlinked"
                echo "  Don't forget to: git add -A && git commit && git push"
                ;;
            command)
                if [ -z "${3:-}" ]; then
                    echo "Usage: ./sync.sh add command <command-name.md>"
                    exit 1
                fi
                cmd_name="$3"
                [[ "$cmd_name" != *.md ]] && cmd_name="${cmd_name}.md"
                src="$HOME/.claude/commands/$cmd_name"
                dest="$DOTFILES_DIR/claude/commands/$cmd_name"

                if [ ! -f "$src" ]; then
                    echo "Error: Command not found at $src"
                    exit 1
                fi

                if [ -L "$src" ]; then
                    echo "Error: $cmd_name is already a symlink (already synced?)"
                    exit 1
                fi

                echo "Copying $cmd_name to dotfiles..."
                cp "$src" "$dest"

                echo "Creating symlink..."
                rm "$src"
                ln -s "$dest" "$src"

                echo "✓ Command '$cmd_name' added to dotfiles and symlinked"
                echo "  Don't forget to: git add -A && git commit && git push"
                ;;
            *)
                echo "Usage: ./sync.sh add <skill|command> <name>"
                exit 1
                ;;
        esac
        ;;
    pull)
        echo "Pulling latest changes..."
        cd "$DOTFILES_DIR"
        git pull
        echo ""
        echo "Re-running install..."
        ./install.sh
        ;;
esac
