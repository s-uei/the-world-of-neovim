#!/usr/bin/env bash
# chapters/ch03.sh — Chapter 3: The Haunted Scriptorium (Deletion)

source "$(dirname "$0")/../lib/ui.sh"
source "$(dirname "$0")/../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ch03.txt"
TASK_FILE="/tmp/neovim_rpg_ch03.txt"
CHAPTER_NUM=3

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE HAUNTED SCRIPTORIUM" "Quest: Purge the Dark Scrolls"

    echo -e "${BMAGENTA}"
    cat << 'ASCIIART'
    👻  👻  👻  👻  👻  👻  👻  👻  👻  👻

         T H E   H A U N T E D
         S C R I P T O R I U M

    📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚
    📖            📖        📖          📖
       👁️  THE SCROLLS ARE CORRUPTED! 👁️
    📖            📖        📖          📖
    📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚

    👻  👻  👻  👻  👻  👻  👻  👻  👻  👻
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "You enter the vast Haunted Scriptorium — an endless library"
    narrate "where every scroll floats through the air, pages rustling."
    narrate "But something is horribly wrong.  Dark ink bleeds through the pages."
    echo ""
    say "Ghost Librarian" "$BWHITE" "Psssst!  Young warrior, over here!"
    say "Ghost Librarian" "$BWHITE" "The GUI Sorcerer's minions have defiled our sacred prophecy!"
    say "Ghost Librarian" "$BWHITE" "Cursed words and corrupted lines have been INSERTED."
    say "Ghost Librarian" "$BWHITE" "You must DELETE them to restore the truth!"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}Your quest:${RESET}"
    echo -e "  ${WHITE}Open the scroll.  Delete all lines marked  <<DELETE THIS LINE>>"
    echo -e "  and remove the words marked with  --CURSED--  from each line.${RESET}"
    echo ""
    show_hint "To delete a whole line:  dd"
    show_hint "To delete a word under cursor:  dw  or  diw"
    show_hint "To find next occurrence:  /CURSED  then  n"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}Opening the Corrupted Scroll in Neovim...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    local pass=true
    local msgs=()

    # Must NOT contain the corruption markers
    if grep -q "<<DELETE THIS LINE>>" "$TASK_FILE"; then
        pass=false
        msgs+=("Some <<DELETE THIS LINE>> markers still remain — use dd to delete those lines!")
    fi

    if grep -q -- "--CURSED--" "$TASK_FILE"; then
        pass=false
        msgs+=("Some --CURSED-- words still remain — use dw or diw to delete them!")
    fi

    # Must still contain the prophecy text (key phrases)
    grep -q "hero shall rise from the east" "$TASK_FILE" || \
        { pass=false; msgs+=("The prophecy line about 'hero shall rise' is missing — don't delete too much!"); }

    grep -q "wielding the sacred" "$TASK_FILE" || \
        { pass=false; msgs+=("The prophecy line about 'wielding the sacred' is missing!"); }

    grep -q "Vim Warrior fights with keystrokes" "$TASK_FILE" || \
        { pass=false; msgs+=("The final prophecy line about 'Vim Warrior' is missing!"); }

    if $pass; then
        return 0
    else
        for msg in "${msgs[@]}"; do
            show_hint "$msg"
        done
        return 1
    fi
}

show_outro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE HAUNTED SCRIPTORIUM" "Quest Complete!"

    echo -e "${BGREEN}"
    cat << 'ASCIIART'
    ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨

       THE PROPHECY IS RESTORED!

       The hero shall rise from the east,
       wielding the sacred editor of light.
       The GUI Sorcerer shall tremble at the sight,
       of fingers dancing swift across the keys.
       No mouse shall bind them, no GUI hold sway,
       for the Vim Warrior fights with keystrokes every day.

    ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "The dark ink dissolves.  The scrolls glow with pure golden light."
    narrate "The Ghost Librarian weeps tears of joy (sort of — ghosts are weird)."
    echo ""
    say "Ghost Librarian" "$BWHITE" "Magnificent!  You have purified the prophecy!"
    say "Ghost Librarian" "$BWHITE" "The deletion arts are powerful — but use them wisely."
    say "Ghost Librarian" "$BWHITE" "A hidden staircase to the Oracle's Peak is now open!"
    echo ""
    show_reward "250" "Deletion Mastery (x, dd, dw, d\$, diw, u, Ctrl-r)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}Inspecting the scroll for corruption...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "The scroll has been completely purified!"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "Corruption remains in the scroll!  Keep deleting!"
            echo ""
            if (( attempts == 1 )); then
                show_hint "Search for  <<DELETE  and delete those lines with  dd"
                show_hint "Search for  --CURSED--  with  /--CURSED--  and delete with  dw  (repeat for each)"
                show_hint "Or use  :%g/DELETE THIS LINE/d  to delete all marked lines at once!"
            fi
            echo ""
            echo -e "  ${YELLOW}Options:${RESET}"
            echo -e "  ${WHITE}  r) Try again${RESET}"
            echo -e "  ${WHITE}  s) Skip this chapter${RESET}"
            echo ""
            printf "  Your choice: "
            read -r choice
            case "$choice" in
                s|S) echo -e "  ${DIM}Skipping chapter...${RESET}"; break ;;
                *)   ;;
            esac
        fi
    done
}

main
