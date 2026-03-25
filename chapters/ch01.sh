#!/usr/bin/env bash
# chapters/ch01.sh — Chapter 1: The Village of Vim (Basic Movement)

# shellcheck source=../lib/ui.sh
source "$(dirname "$0")/../lib/ui.sh"
# shellcheck source=../lib/progress.sh
source "$(dirname "$0")/../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ch01.txt"
TASK_FILE="/tmp/neovim_rpg_ch01.txt"
CHAPTER_NUM=1

# ─────────────────────────────────────────
# Intro sequence
# ─────────────────────────────────────────
show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE VILLAGE OF VIM" "Quest: Escape the Burning Village"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
         _______
        /       \         🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥
       | 🏠 VIM |
       |  VILLAGE|        THE FLAMES SPREAD FAST!
        \_______/
           |||             You are a young adventurer
        ///|||\\\\           who just discovered the
       🔥🔥🔥🔥🔥🔥         ancient power of Neovim.
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "The peaceful Village of Vim is under attack!"
    narrate "The GUI Sorcerer has sent his fire-breathing mice to destroy it."
    narrate "Flames lick at the elder's hut as the old wizard runs toward you..."
    echo ""
    say "Elder Vimsworth" "$BWHITE" "Young warrior! You must escape — but the path is treacherous!"
    say "Elder Vimsworth" "$BWHITE" "The only way out is to master the Movement Arts of Neovim."
    say "Elder Vimsworth" "$BWHITE" "Take this scroll and go!  Use  h j k l  to navigate, and"
    say "Elder Vimsworth" "$BWHITE" "w b e 0 \$ gg G  for swift movement.  Now RUN!"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}Your quest:${RESET}"
    echo -e "  ${WHITE}Open the scroll in Neovim, learn the movement commands,"
    echo -e "  and fill in the three RUNE WORDS found on the village map.${RESET}"
    echo ""
    show_hint "Use  G  (capital G) in Neovim to jump to the bottom of the file"
    show_hint "where the ANSWER SECTION is located."
    echo ""
    press_enter
}

# ─────────────────────────────────────────
# Launch Neovim with the lesson file
# ─────────────────────────────────────────
run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}Opening the Ancient Scroll in Neovim...${RESET}"
    echo -e "  ${DIM}(The scroll is at: $TASK_FILE)${RESET}"
    echo ""
    sleep 1
    # Open with line numbers visible
    nvim "+set number" "$TASK_FILE"
}

# ─────────────────────────────────────────
# Verify the user's edits
# ─────────────────────────────────────────
verify() {
    # Expected: The three rune words from the map:
    #   Rune 1: EMBER
    #   Rune 2: SHADOW
    #   Rune 3: MOTION
    local rune1 rune2 rune3
    rune1=$(grep -i "^  Rune 1:" "$TASK_FILE" 2>/dev/null | head -1 | sed 's/.*Rune 1:[[:space:]]*//' | tr -d '\r\n ')
    rune2=$(grep -i "^  Rune 2:" "$TASK_FILE" 2>/dev/null | head -1 | sed 's/.*Rune 2:[[:space:]]*//' | tr -d '\r\n ')
    rune3=$(grep -i "^  Rune 3:" "$TASK_FILE" 2>/dev/null | head -1 | sed 's/.*Rune 3:[[:space:]]*//' | tr -d '\r\n ')

    local pass=true
    local msgs=()

    [[ "${rune1^^}" == "EMBER"  ]] || { pass=false; msgs+=("Rune 1 should be EMBER (found: '${rune1}')"); }
    [[ "${rune2^^}" == "SHADOW" ]] || { pass=false; msgs+=("Rune 2 should be SHADOW (found: '${rune2}')"); }
    [[ "${rune3^^}" == "MOTION" ]] || { pass=false; msgs+=("Rune 3 should be MOTION (found: '${rune3}')"); }

    if $pass; then
        return 0
    else
        for msg in "${msgs[@]}"; do
            show_hint "$msg"
        done
        return 1
    fi
}

# ─────────────────────────────────────────
# Outro — success sequence
# ─────────────────────────────────────────
show_outro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE VILLAGE OF VIM" "Quest Complete!"

    echo -e "${BGREEN}"
    cat << 'ASCIIART'
    ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★

       YOU ESCAPED THE BURNING VILLAGE!

       Armed with the three runes — EMBER, SHADOW, MOTION —
       you dash through the flames and reach the forest edge.

    ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "Behind you, the village crumbles.  But you are alive."
    narrate "The runes glow in your hands, forming a key..."
    echo ""
    say "Elder Vimsworth" "$BWHITE" "You did it!  The Movement Arts are within you now."
    say "Elder Vimsworth" "$BWHITE" "But your journey has just begun — darker trials await."
    say "Elder Vimsworth" "$BWHITE" "The Cave of Cursors lies ahead.  Master INSERT mode next!"
    echo ""
    show_reward "150" "Movement Mastery (hjkl, w, b, e, 0, \$, gg, G)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

# ─────────────────────────────────────────
# Main
# ─────────────────────────────────────────
main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}Checking your scroll...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "The three runes have been correctly inscribed!"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "The runes are not quite right.  Try again!"
            echo ""
            if (( attempts == 1 )); then
                show_hint "Navigate to the VILLAGE MAP section and read the words after each [RUNE-X] →"
                show_hint "Then scroll to the ANSWER SECTION (press G) and replace the ??? with those words."
            fi
            echo ""
            echo -e "  ${YELLOW}Options:${RESET}"
            echo -e "  ${WHITE}  r) Try again — reopen the scroll${RESET}"
            echo -e "  ${WHITE}  s) Skip this chapter (no XP awarded)${RESET}"
            echo ""
            printf "  Your choice: "
            read -r choice
            case "$choice" in
                s|S) echo -e "  ${DIM}Skipping chapter...${RESET}"; break ;;
                *)   ;;  # retry
            esac
        fi
    done
}

main
