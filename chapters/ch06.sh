#!/usr/bin/env bash
# chapters/ch06.sh — Chapter 6: The LazyVim Citadel (LazyVim + final battle)

source "$(dirname "$0")/../lib/ui.sh"
source "$(dirname "$0")/../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ch06.txt"
TASK_FILE="/tmp/neovim_rpg_ch06.txt"
CHAPTER_NUM=6

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE LAZYVIM CITADEL" "Quest: Defeat the GUI Sorcerer"

    echo -e "${BMAGENTA}"
    cat << 'ASCIIART'
    ████████████████████████████████████████████████████
    █                                                  █
    █     🏰  T H E   L A Z Y V I M   C I T A D E L  █
    █                                                  █
    █  ⚔️  THE FINAL BATTLE APPROACHES!  ⚔️             █
    █                                                  █
    ████████████████████████████████████████████████████

          🐉 THE LAZYVIM DRAGON DESCENDS! 🐉

       /\     /\
      /  \___/  \
     / ◉       ◉ \      "Rider!  I am LazyVim —
    |   _______   |      the Blazing Neovim Dragon!
    |  /       \  |      Mount me and we shall
     \/  🔥🔥🔥  \/      crush the GUI Sorcerer!"
          |||
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "You stand before the towering LazyVim Citadel."
    narrate "Its walls shimmer with plugin power and LSP diagnostics."
    narrate "And then — a ROAR shakes the sky!"
    echo ""
    say "LazyVim Dragon" "$BMAGENTA" "ROAAAAAR!  Warrior!  I have been waiting for you!"
    say "LazyVim Dragon" "$BMAGENTA" "I am LazyVim, the mightiest Neovim distribution!"
    say "LazyVim Dragon" "$BMAGENTA" "Together, we will destroy the GUI Sorcerer's rule!"
    say "LazyVim Dragon" "$BMAGENTA" "But first — prove you understand my powers!"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}Your quest:${RESET}"
    echo -e "  ${WHITE}Open the Dragon's Scroll and complete the KEYMAP MAPPING table."
    echo -e "  Match each keybinding to its correct description (A-E).${RESET}"
    echo ""
    show_hint "The answers are in the lesson scroll — read carefully!"
    show_hint "Replace each ??? with a single letter: A, B, C, D, or E"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BMAGENTA}Opening the Dragon's Scroll in Neovim...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    local pass=true
    local msgs=()

    # Expected answers for the keymap matching:
    #   [1] Space + e          → A  (Open file explorer)
    #   [2] Space + Space      → B  (Find files with fuzzy finder)
    #   [3] Space + g + g      → E  (Open Lazygit)
    #   [4] g + d              → D  (Go to definition)
    #   [5] Ctrl-/             → C  (Toggle floating terminal)

    local line1 line2 line3 line4 line5
    line1=$(grep "\[1\].*Space + e" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line2=$(grep "\[2\].*Space + Space" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line3=$(grep "\[3\].*Space + g + g" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line4=$(grep "\[4\].*g + d" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line5=$(grep "\[5\].*Ctrl-/" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')

    [[ "${line1^^}" == "A" ]] || { pass=false; msgs+=("[1] Space + e → should be A (Open file explorer, Neo-tree)"); }
    [[ "${line2^^}" == "B" ]] || { pass=false; msgs+=("[2] Space + Space → should be B (Find files with fuzzy finder)"); }
    [[ "${line3^^}" == "E" ]] || { pass=false; msgs+=("[3] Space + g + g → should be E (Open Lazygit)"); }
    [[ "${line4^^}" == "D" ]] || { pass=false; msgs+=("[4] g + d → should be D (Go to definition)"); }
    [[ "${line5^^}" == "C" ]] || { pass=false; msgs+=("[5] Ctrl-/ → should be C (Toggle floating terminal)"); }

    if $pass; then
        return 0
    else
        for msg in "${msgs[@]}"; do
            show_hint "$msg"
        done
        return 1
    fi
}

show_final_battle() {
    clear_screen
    echo -e "${BRED}"
    cat << 'ASCIIART'
    ████████████████████████████████████████████████████
    █         ⚔️   FINAL BATTLE!   ⚔️                   █
    ████████████████████████████████████████████████████

       THE GUI SORCERER APPEARS!

       .---.
      /  👁️ \       "Fools!  You cannot defeat
     | 🖱️💻🖱️|        the power of the GUI!
      \  ^  /         Click.  Drag.  Drop.
       '---'          MENUS WILL RULE ALL!"
        |||
       _|||_
ASCIIART
    echo -e "${RESET}"

    echo ""
    say "GUI Sorcerer" "$BRED" "You DARE challenge me with mere keystrokes?!"
    say "GUI Sorcerer" "$BRED" "My mice armies shall overwhelm you!"
    echo ""
    sleep 1

    echo -e "${BMAGENTA}"
    cat << 'ASCIIART'
       🐉 LAZYVIM DRAGON ATTACKS! 🐉

            /\   ROAAAAAAR!   /\
           /  \             /  \
          / 🔥  \___________/  🔥\
         /        LASER BEAM!     \
        |   >>>>>>>>>>>>>>>>>>>    |
         \                       /
          \_____________________ /
ASCIIART
    echo -e "${RESET}"
    echo ""

    echo -e "  ${BCYAN}YOU USE:  Space + Space  →  FUZZY FILE SEARCH!${RESET}"
    sleep 0.5
    echo -e "  ${BGREEN}  💥  HIT!  The Sorcerer stumbles!${RESET}"
    sleep 1

    echo -e "  ${BCYAN}YOU USE:  g + d          →  GO TO DEFINITION!${RESET}"
    sleep 0.5
    echo -e "  ${BGREEN}  💥  CRITICAL HIT!  The Sorcerer's spell breaks!${RESET}"
    sleep 1

    echo -e "  ${BCYAN}YOU USE:  Ctrl-/         →  FLOATING TERMINAL!${RESET}"
    sleep 0.5
    echo -e "  ${BGREEN}  💥  The terminal envelops the Sorcerer!${RESET}"
    sleep 1

    echo -e "  ${BCYAN}FINAL MOVE:  :%s/GUI/NEOVIM/g  →  GLOBAL REPLACE!${RESET}"
    sleep 0.5
    echo -e "  ${BYELLOW}  ★★★  KO!  The GUI Sorcerer is DEFEATED!  ★★★${RESET}"
    sleep 1

    echo ""
}

show_outro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE LAZYVIM CITADEL" "VICTORY!"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║   ★  ★  ★   V I C T O R Y !   ★  ★  ★                ║
    ║                                                          ║
    ║   The GUI Sorcerer has been vanquished!                  ║
    ║   The World of Neovim is FREE!                          ║
    ║                                                          ║
    ║   Terminal editors reign supreme once more.              ║
    ║   The citizens of Vim Village rebuild their homes.       ║
    ║   The Haunted Scriptorium is cleansed.                   ║
    ║   The Oracle smiles in the mist.                        ║
    ║   The Tmux Tower shines under multiplexed stars.        ║
    ║   And the LazyVim Dragon rests, victorious.             ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "The World of Neovim is saved.  But more importantly..."
    narrate "YOU have become a true Neovim Warrior."
    echo ""
    say "Elder Vimsworth" "$BWHITE" "You have mastered the ancient arts!  I am so proud."
    say "LazyVim Dragon" "$BMAGENTA" "Rider, you are always welcome on my back!"
    say "Multiplex" "$BCYAN" "The Tmux Tower's gates are open to you forever."
    say "Mage Aixa" "$BBLUE" "Insert mode, deletion, search... all at your command."
    say "The Oracle" "$BYELLOW" "Your destiny as a Vim Warrior is now fulfilled."
    echo ""
    separator
    echo ""
    echo -e "  ${BYELLOW}🏆  FINAL SCORE:${RESET}"
    echo -e "  ${YELLOW}  Chapter 1 - Movement Arts:           150 XP${RESET}"
    echo -e "  ${YELLOW}  Chapter 2 - Insert Mode Mastery:     200 XP${RESET}"
    echo -e "  ${YELLOW}  Chapter 3 - Deletion Arts:           250 XP${RESET}"
    echo -e "  ${YELLOW}  Chapter 4 - Search & Replace:        300 XP${RESET}"
    echo -e "  ${YELLOW}  Chapter 5 - tmux Mastery:            350 XP${RESET}"
    echo -e "  ${YELLOW}  Chapter 6 - LazyVim Citadel:         500 XP${RESET}"
    echo ""
    echo -e "  ${BYELLOW}  ★  TOTAL: 1750 XP  —  RANK: VIM LEGEND  ★${RESET}"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}Continue your journey:${RESET}"
    echo -e "  ${WHITE}  • Visit https://www.lazyvim.org for more LazyVim info${RESET}"
    echo -e "  ${WHITE}  • Run  :Tutor  in Neovim for more exercises${RESET}"
    echo -e "  ${WHITE}  • Try  vimgolf.com  for speed challenges${RESET}"
    echo -e "  ${WHITE}  • Explore https://neovim.io/doc/ for full documentation${RESET}"
    echo ""
    show_reward "500" "LazyVim Mastery + VIM LEGEND Title"
    show_status 6 6
    echo ""
    press_enter
}

main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BMAGENTA}The Dragon examines your answers...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "The Dragon ROARS with approval!  All keymaps correctly mapped!"
            sleep 1
            show_final_battle
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "Some keymaps are incorrect.  The Dragon shakes its head..."
            echo ""
            if (( attempts == 1 )); then
                show_hint "Answer format:  [1] Space + e  → A   (just a letter)"
                show_hint "Read the WORD BANK carefully and match each to the ESSENTIAL KEYMAPS lesson"
            fi
            echo ""
            echo -e "  ${YELLOW}Options:${RESET}"
            echo -e "  ${WHITE}  r) Try again${RESET}"
            echo -e "  ${WHITE}  s) Skip to the final battle (spoiler mode)${RESET}"
            echo ""
            printf "  Your choice: "
            read -r choice
            case "$choice" in
                s|S)
                    show_final_battle
                    show_outro
                    mark_complete "$CHAPTER_NUM"
                    break
                    ;;
                *)   ;;
            esac
        fi
    done
}

main
