#!/bin/bash

# Dry-run comparison for dotfiles install
# Shows what would change without making any modifications

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "Dotfiles Install Comparison (dry-run)"
echo "======================================"
echo "Repo: $DOTFILES_DIR"
echo ""

changes=0
warnings=0

compare_file() {
    local src="$1"
    local dest="$2"
    local name="$3"

    printf "%-30s " "$name"

    if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
        # Destination doesn't exist
        echo -e "${GREEN}[NEW]${NC} Will create symlink"
        ((changes++))
    elif [ -L "$dest" ]; then
        # Destination is a symlink
        local target=$(readlink "$dest")
        if [ "$target" = "$src" ]; then
            echo -e "${BLUE}[OK]${NC} Already symlinked correctly"
        elif [[ "$target" == "$DOTFILES_DIR"* ]]; then
            echo -e "${YELLOW}[UPDATE]${NC} Symlink points to: $target"
            ((changes++))
        else
            echo -e "${YELLOW}[REPLACE]${NC} Symlink points elsewhere: $target"
            ((changes++))
        fi
    elif [ -f "$dest" ]; then
        # Destination is a regular file
        if diff -q "$src" "$dest" > /dev/null 2>&1; then
            echo -e "${YELLOW}[CONVERT]${NC} Identical file → will become symlink"
            ((changes++))
        else
            echo -e "${RED}[DIFFERS]${NC} Local file has different content"
            ((changes++))
            ((warnings++))
            # Show a brief diff summary
            local lines_added=$(diff "$src" "$dest" 2>/dev/null | grep -c "^>" || echo "0")
            local lines_removed=$(diff "$src" "$dest" 2>/dev/null | grep -c "^<" || echo "0")
            printf "%-30s   └─ Local has +%s/-%s lines vs repo\n" "" "$lines_added" "$lines_removed"
        fi
    elif [ -d "$dest" ]; then
        echo -e "${RED}[CONFLICT]${NC} Is a directory, not a file"
        ((warnings++))
    else
        echo -e "${RED}[UNKNOWN]${NC} Unknown file type"
        ((warnings++))
    fi
}

echo "Git Configuration"
echo "-----------------"
compare_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig" "~/.gitconfig"

if [ -f "$HOME/.gitconfig.local" ]; then
    printf "%-30s ${BLUE}[OK]${NC} Exists (machine-specific)\n" "~/.gitconfig.local"
else
    printf "%-30s ${YELLOW}[MISSING]${NC} Create from git/gitconfig.local.template\n" "~/.gitconfig.local"
    ((warnings++))
fi

echo ""
echo "Shell Configuration"
echo "-------------------"
compare_file "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc" "~/.zshrc"

if [ -f "$HOME/.zshrc.local" ]; then
    printf "%-30s ${BLUE}[OK]${NC} Exists (machine-specific)\n" "~/.zshrc.local"
else
    printf "%-30s ${BLUE}[SKIP]${NC} Not present (optional)\n" "~/.zshrc.local"
fi

echo ""
echo "SSH Configuration"
echo "-----------------"
compare_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config" "~/.ssh/config"

if [ -f "$HOME/.ssh/config.local" ]; then
    printf "%-30s ${BLUE}[OK]${NC} Exists (machine-specific)\n" "~/.ssh/config.local"
else
    printf "%-30s ${BLUE}[SKIP]${NC} Not present (optional)\n" "~/.ssh/config.local"
fi

echo ""
echo "======================================"

if [ $warnings -gt 0 ]; then
    echo -e "${RED}Warnings: $warnings${NC} (review items marked [DIFFERS] or [MISSING])"
fi

if [ $changes -eq 0 ]; then
    echo -e "${GREEN}No changes needed - everything is in sync!${NC}"
else
    echo -e "Changes pending: $changes"
    echo ""
    echo "To see file differences:"
    echo "  diff ~/Developer/dotfiles/shell/zshrc ~/.zshrc"
    echo ""
    echo "To apply changes:"
    echo "  ./install.sh"
fi
