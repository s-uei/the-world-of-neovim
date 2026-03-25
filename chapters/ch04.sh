#!/usr/bin/env bash
# chapters/ch04.sh — Chapter 4: The Oracle's Peak (Search & Replace + Commands)

source "$(dirname "$0")/../lib/ui.sh"
source "$(dirname "$0")/../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ch04.txt"
TASK_FILE="/tmp/neovim_rpg_ch04.txt"
CHAPTER_NUM=4

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE ORACLE'S PEAK" "Quest: Decipher the Prophecy"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
                /\
               /  \
              / 🔭 \        T H E   O R A C L E ' S
             /      \
            /  PEAK  \      P  E  A  K
           /~~~~~~~~~~\
          /  🌙  ☁️  🌙 \
         /              \   "The truth hides behind
        /    ~~MIST~~    \   false words..."
       /__________________\
             |  |
             |  |
      ███████████████████
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "You climb the misty staircase and emerge at the summit."
    narrate "A crystalline sphere pulses with ancient light.  The Oracle speaks:"
    echo ""
    say "The Oracle" "$BYELLOW" "Warrior... I have foreseen your coming."
    say "The Oracle" "$BYELLOW" "But the GUI Sorcerer has scrambled my prophecy!"
    say "The Oracle" "$BYELLOW" "The truth is hidden behind false words."
    say "The Oracle" "$BYELLOW" "Use your SEARCH and REPLACE arts to reveal it!"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}Your quest:${RESET}"
    echo -e "  ${WHITE}Open the scroll.  In the ENCODED PROPHECY section, perform these"
    echo -e "  substitutions to reveal the true words of the Oracle:${RESET}"
    echo ""
    echo -e "  ${YELLOW}  KEYBOARD → SWORD${RESET}"
    echo -e "  ${YELLOW}  NORMAL   → PEACE${RESET}"
    echo -e "  ${YELLOW}  INSERT   → CREATION${RESET}"
    echo -e "  ${YELLOW}  /SEARCH  → WISDOM${RESET}"
    echo -e "  ${YELLOW}  NEOVIM   → DESTINY${RESET}"
    echo ""
    show_hint "Use  :s/KEYBOARD/SWORD/g  on the relevant line, or"
    show_hint "Use  :%s/KEYBOARD/SWORD/g  to replace in the whole file"
    show_hint "The ENCODED PROPHECY section is between the --- markers"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}Opening the Oracle's Scroll in Neovim...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    local pass=true
    local msgs=()

    # The encoded prophecy section should have the replaced words
    # Check between the --- ENCODED PROPHECY --- markers
    local prophecy_section
    prophecy_section=$(awk '/--- ENCODED PROPHECY/,/--- END OF ENCODED PROPHECY/' "$TASK_FILE" 2>/dev/null)

    echo "$prophecy_section" | grep -q "SWORD" || \
        { pass=false; msgs+=("KEYBOARD was not replaced with SWORD in the prophecy"); }

    echo "$prophecy_section" | grep -q "PEACE" || \
        { pass=false; msgs+=("NORMAL was not replaced with PEACE in the prophecy"); }

    echo "$prophecy_section" | grep -q "CREATION" || \
        { pass=false; msgs+=("INSERT was not replaced with CREATION in the prophecy"); }

    echo "$prophecy_section" | grep -q "WISDOM" || \
        { pass=false; msgs+=("/SEARCH was not replaced with WISDOM in the prophecy"); }

    echo "$prophecy_section" | grep -q "DESTINY" || \
        { pass=false; msgs+=("NEOVIM was not replaced with DESTINY in the prophecy"); }

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
    chapter_banner "$CHAPTER_NUM" "THE ORACLE'S PEAK" "Quest Complete!"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
    ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦

       THE ORACLE'S TRUE PROPHECY REVEALED:

       "The power of SWORD flows through your fingers like lightning.
        Return to PEACE as a warrior sheathes their blade.
        In CREATION mode, inscribe your will upon the digital realm.
        Let WISDOM guide you through darkness like a lantern.
        For DESTINY is the ancient art, reborn in modern light."

    ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "The crystal sphere blazes with golden light."
    narrate "The Oracle's true prophecy echoes across the misty mountaintop."
    echo ""
    say "The Oracle" "$BYELLOW" "Yes!  You have found the truth within the falsehood!"
    say "The Oracle" "$BYELLOW" "Your next trial lies in the distance — the Tmux Tower!"
    say "The Oracle" "$BYELLOW" "There you must learn to rule MULTIPLE REALMS at once."
    say "The Oracle" "$BYELLOW" "The prefix Ctrl-b is the key to all its power."
    echo ""
    show_reward "300" "Search & Replace Mastery (/pattern, :s, :%s, n, N, *)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}Verifying the deciphered prophecy...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "The Oracle's prophecy has been successfully deciphered!"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "Some words in the prophecy are still encoded!  Try again!"
            echo ""
            if (( attempts == 1 )); then
                show_hint "Make sure to edit the lines between --- ENCODED PROPHECY --- markers"
                show_hint "Try:  :%s/KEYBOARD/SWORD/g  (then repeat for each word pair)"
                show_hint "For /SEARCH: use  :%s/\\/SEARCH/WISDOM/g  (escape the slash)"
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
