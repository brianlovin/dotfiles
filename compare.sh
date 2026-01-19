#!/bin/bash

# Dry-run comparison for dotfiles install
# Shows what would change without making any modifications

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m' # No Color

echo ""
echo "Dotfiles Install Comparison (dry-run)"
echo "======================================"
echo ""

changes=0
warnings=0

show_diff() {
    local src="$1"
    local dest="$2"

    echo ""
    echo -e "${DIM}────────────────────────────────────────${NC}"
    echo -e "${CYAN}Repo version:${NC} $src"
    echo -e "${CYAN}Local version:${NC} $dest"
    echo -e "${DIM}────────────────────────────────────────${NC}"
    echo ""

    # Use diff with color: repo is "old" (red = would be removed), local is "new" (green = currently have)
    # Flip it so: GREEN = what repo has (what you'll get), RED = what local has (what you'll lose)
    diff --color=always -u "$dest" "$src" 2>/dev/null | tail -n +3 | head -50

    local total_lines=$(diff -u "$dest" "$src" 2>/dev/null | tail -n +3 | wc -l)
    if [ "$total_lines" -gt 50 ]; then
        echo ""
        echo -e "${DIM}... ($((total_lines - 50)) more lines, run: diff -u \"$dest\" \"$src\")${NC}"
    fi
    echo ""
}

compare_file() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
        # Destination doesn't exist
        echo -e "${GREEN}[NEW]${NC} $name"
        echo -e "      Will create symlink → $src"
        ((changes++))

    elif [ -L "$dest" ]; then
        # Destination is a symlink
        local target=$(readlink "$dest")
        if [ "$target" = "$src" ]; then
            echo -e "${BLUE}[OK]${NC} $name"
            echo -e "      ${DIM}Already symlinked correctly${NC}"
        elif [[ "$target" == "$DOTFILES_DIR"* ]]; then
            echo -e "${YELLOW}[UPDATE]${NC} $name"
            echo -e "      Symlink will change: $target → $src"
            ((changes++))
        else
            echo -e "${YELLOW}[REPLACE]${NC} $name"
            echo -e "      Currently points to: $target"
            echo -e "      Will point to: $src"
            ((changes++))
        fi

    elif [ -f "$dest" ]; then
        # Destination is a regular file
        if diff -q "$src" "$dest" > /dev/null 2>&1; then
            echo -e "${GREEN}[CONVERT]${NC} $name"
            echo -e "      Identical content - file will become symlink (safe)"
            ((changes++))
        else
            echo -e "${RED}[DIFFERS]${NC} $name"
            echo -e "      ${RED}Local file will be REPLACED by symlink${NC}"
            ((changes++))
            ((warnings++))
            show_diff "$src" "$dest"
        fi

    elif [ -d "$dest" ]; then
        echo -e "${RED}[CONFLICT]${NC} $name"
        echo -e "      Is a directory, expected a file"
        ((warnings++))
    fi

    echo ""
}

check_local_file() {
    local file="$1"
    local required="$2"
    local template="$3"

    if [ -f "$file" ]; then
        echo -e "${BLUE}[OK]${NC} $file"
        echo -e "      ${DIM}Exists (machine-specific, not synced)${NC}"
    elif [ "$required" = "required" ]; then
        echo -e "${RED}[MISSING]${NC} $file"
        echo -e "      ${RED}Required!${NC} Create from: $template"
        ((warnings++))
    else
        echo -e "${DIM}[SKIP]${NC} $file"
        echo -e "      ${DIM}Not present (optional)${NC}"
    fi
    echo ""
}

echo "Git Configuration"
echo "-----------------"
compare_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig" "~/.gitconfig"
check_local_file "$HOME/.gitconfig.local" "required" "git/gitconfig.local.template"

echo "Shell Configuration"
echo "-------------------"
compare_file "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc" "~/.zshrc"
check_local_file "$HOME/.zshrc.local" "optional"

echo "SSH Configuration"
echo "-----------------"
compare_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config" "~/.ssh/config"
check_local_file "$HOME/.ssh/config.local" "optional"

echo "======================================"
echo ""

if [ $warnings -gt 0 ]; then
    echo -e "${RED}⚠ Warnings: $warnings${NC}"
    echo -e "  Review ${RED}[DIFFERS]${NC} sections above - local changes will be lost!"
    echo ""
fi

if [ $changes -eq 0 ]; then
    echo -e "${GREEN}✓ Everything is in sync - no changes needed${NC}"
else
    echo "Changes pending: $changes"
    echo ""
    if [ $warnings -gt 0 ]; then
        echo "If the diffs above look safe, run:"
    else
        echo "To apply changes, run:"
    fi
    echo -e "  ${CYAN}./install.sh${NC}"
fi
echo ""
