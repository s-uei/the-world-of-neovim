#!/usr/bin/env bash
# chapters/ch02.sh — Chapter 2: The Cave of Cursors (Insert Mode)

source "$(dirname "$0")/../lib/ui.sh"
source "$(dirname "$0")/../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ch02.txt"
TASK_FILE="/tmp/neovim_rpg_ch02.txt"
CHAPTER_NUM=2

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE CAVE OF CURSORS" "Quest: Inscribe the Magic Runes"

    echo -e "${BBLUE}"
    cat << 'ASCIIART'
                  ___
                 /   \
    ____________/ 🔮  \____________
   |                              |
   |   C A V E   O F              |
   |   C U R S O R S              |
   |   ~  ~  ~  ~  ~             |
   |    A dark cavern sealed      |
   |    by an ancient stone door  |
   |______________________________|
         |             |
         |   ENTER?    |
         |_____________|
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "You push through the dark forest and find a massive stone door."
    narrate "Five rune slots are carved into its surface, each one empty."
    narrate "Ancient script glows faintly:"
    echo ""
    say "Stone Door" "$BBLUE" "Only one who can WRITE in the darkness may pass."
    say "Stone Door" "$BBLUE" "Insert the five sacred words... or remain outside forever."
    echo ""
    narrate "A cloaked figure emerges from the shadows beside you."
    echo ""
    say "Mage Aixa" "$BMAGENTA" "Greetings, young warrior.  I am Aixa, mistress of Insert Mode."
    say "Mage Aixa" "$BMAGENTA" "Let me teach you the sacred art of writing within Neovim."
    say "Mage Aixa" "$BMAGENTA" "Press  i  to insert BEFORE cursor,  a  to insert AFTER cursor."
    say "Mage Aixa" "$BMAGENTA" "Press  o  to open a new line below.  And always  Esc  to finish!"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}Your quest:${RESET}"
    echo -e "  ${WHITE}Open the scroll.  Find the five rune slots marked  [ INSERT: WORD ]"
    echo -e "  and replace them with the actual words.${RESET}"
    echo ""
    show_hint "Position cursor on '[' then use  dt]  (delete till ]) or select with v and replace"
    show_hint "Or use  ciW  (change inner WORD) on each word inside the brackets"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}Opening the Cave Scroll in Neovim...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    # Check that the 5 rune slot lines contain the correct words
    # and do NOT contain the [ INSERT: ... ] brackets
    local pass=true
    local msgs=()

    local content
    content=$(cat "$TASK_FILE" 2>/dev/null)

    # Check each required word is present in context
    grep -q "Knock three times and say: OPEN$" "$TASK_FILE" || \
    grep -q "Knock three times and say: OPEN " "$TASK_FILE" || \
        { pass=false; msgs+=("Rune Slot 1: 'OPEN' not found correctly after 'say:'"); }

    grep -q "Speak against the darkness: LUMINOS" "$TASK_FILE" || \
        { pass=false; msgs+=("Rune Slot 2: 'LUMINOS' not found correctly"); }

    grep -q "Declare your title boldly: CURSOR" "$TASK_FILE" || \
        { pass=false; msgs+=("Rune Slot 3: 'CURSOR' not found correctly"); }

    grep -q "What keeps the cursor steady: NORMAL" "$TASK_FILE" || \
        { pass=false; msgs+=("Rune Slot 4: 'NORMAL' not found correctly"); }

    grep -q "The source of all power: NEOVIM" "$TASK_FILE" || \
        { pass=false; msgs+=("Rune Slot 5: 'NEOVIM' not found correctly"); }

    # Ensure the [ INSERT: ... ] markers are gone from the rune slots
    if grep -q "\[ INSERT:" "$TASK_FILE"; then
        pass=false
        msgs+=("Some [ INSERT: ... ] markers remain — please remove all brackets too!")
    fi

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
    chapter_banner "$CHAPTER_NUM" "THE CAVE OF CURSORS" "Quest Complete!"

    echo -e "${BBLUE}"
    cat << 'ASCIIART'
    ╔════════════════════════════════════════════╗
    ║                                            ║
    ║   OPEN! LUMINOS! CURSOR! NORMAL! NEOVIM!  ║
    ║                                            ║
    ║   The stone door SHUDDERS... and opens!    ║
    ║                                            ║
    ║       RUMBLE...  CRACK...  BOOM!           ║
    ║                                            ║
    ║   Beyond lies a vast, dimly lit library.   ║
    ║   The Haunted Scriptorium awaits...        ║
    ║                                            ║
    ╚════════════════════════════════════════════╝
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "The stone door grinds open, revealing a vast cavern of shelves"
    narrate "stretching into infinite darkness.  Books float through the air,"
    narrate "their pages rustling like whispering ghosts."
    echo ""
    say "Mage Aixa" "$BMAGENTA" "You have mastered Insert Mode!  Well done, warrior."
    say "Mage Aixa" "$BMAGENTA" "But the Scriptorium ahead is corrupted by dark magic."
    say "Mage Aixa" "$BMAGENTA" "You must learn to DELETE the darkness next..."
    echo ""
    show_reward "200" "Insert Mode Mastery (i, a, o, I, A, O, Esc)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}Checking the rune slots...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "All five runes have been correctly inscribed!"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "Some rune slots are not correct.  Try again!"
            echo ""
            if (( attempts == 1 )); then
                show_hint "Go to each RUNE SLOT line and remove the [ INSERT: WORD ] text"
                show_hint "Replace it with just the word (e.g., OPEN, LUMINOS, etc.)"
                show_hint "The word to use for each slot is inside the brackets"
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
