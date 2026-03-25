#!/usr/bin/env bash
# game.sh — The World of Neovim: An RPG Adventure
# Learn Neovim, tmux, and LazyVim through an epic RPG journey!

set -euo pipefail

GAME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/ui.sh
source "${GAME_DIR}/lib/ui.sh"
# shellcheck source=lib/progress.sh
source "${GAME_DIR}/lib/progress.sh"

TOTAL_CHAPTERS=6

# ─────────────────────────────────────────
# Dependency checks
# ─────────────────────────────────────────
check_deps() {
    local missing=()
    if ! command -v nvim &>/dev/null; then
        missing+=("nvim (Neovim)")
    fi
    if ! command -v tmux &>/dev/null; then
        missing+=("tmux")
    fi

    if (( ${#missing[@]} > 0 )); then
        echo -e "${BRED}ERROR: Missing required tools:${RESET}"
        for dep in "${missing[@]}"; do
            echo -e "  ${RED}• $dep${RESET}"
        done
        echo ""
        echo -e "${YELLOW}Please install the missing tools and try again.${RESET}"
        echo ""
        echo -e "  ${DIM}Neovim:  https://neovim.io/doc/user/nvim.html${RESET}"
        echo -e "  ${DIM}tmux:    https://github.com/tmux/tmux/wiki/Installing${RESET}"
        echo ""
        exit 1
    fi
}

# ─────────────────────────────────────────
# Title screen
# ─────────────────────────────────────────
show_title() {
    clear
    echo ""
    echo -e "${BMAGENTA}"
    cat << 'TITLE'
  ████████╗██╗  ██╗███████╗    ██╗    ██╗ ██████╗ ██████╗ ██╗     ██████╗
  ╚══██╔══╝██║  ██║██╔════╝    ██║    ██║██╔═══██╗██╔══██╗██║     ██╔══██╗
     ██║   ███████║█████╗      ██║ █╗ ██║██║   ██║██████╔╝██║     ██║  ██║
     ██║   ██╔══██║██╔══╝      ██║███╗██║██║   ██║██╔══██╗██║     ██║  ██║
     ██║   ██║  ██║███████╗    ╚███╔███╔╝╚██████╔╝██║  ██║███████╗██████╔╝
     ╚═╝   ╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝
TITLE
    echo -e "${RESET}"
    echo -e "${BYELLOW}"
    cat << 'SUBTITLE'
                  ██████╗ ███████╗    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
                  ██╔═══██╗██╔════╝    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
                  ██║   ██║█████╗      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
                  ██║   ██║██╔══╝      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
                  ╚██████╔╝██║         ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
                   ╚═════╝ ╚═╝         ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
SUBTITLE
    echo -e "${RESET}"

    echo -e "${CYAN}"
    cat << 'TAGLINE'
    ─────────────────────────────────────────────────────────────────────────
         An RPG Adventure to Master Neovim, tmux, and LazyVim
         "The keyboard is your sword.  The terminal is your realm."
    ─────────────────────────────────────────────────────────────────────────
TAGLINE
    echo -e "${RESET}"
    echo ""

    # Show chapter map
    echo -e "  ${BYELLOW}⚔  THE ADVENTURE:${RESET}"
    echo ""
    echo -e "  ${CYAN}  Chapter 1${RESET}  ${WHITE}🏘  The Village of Vim       ${DIM}(Movement)${RESET}"
    echo -e "  ${CYAN}  Chapter 2${RESET}  ${WHITE}🔮  The Cave of Cursors      ${DIM}(Insert Mode)${RESET}"
    echo -e "  ${CYAN}  Chapter 3${RESET}  ${WHITE}👻  The Haunted Scriptorium  ${DIM}(Deletion)${RESET}"
    echo -e "  ${CYAN}  Chapter 4${RESET}  ${WHITE}🔭  The Oracle's Peak        ${DIM}(Search & Replace)${RESET}"
    echo -e "  ${CYAN}  Chapter 5${RESET}  ${WHITE}🗼  The Tmux Tower           ${DIM}(tmux Basics)${RESET}"
    echo -e "  ${CYAN}  Chapter 6${RESET}  ${WHITE}🏰  The LazyVim Citadel      ${DIM}(LazyVim + Final Battle)${RESET}"
    echo ""
    separator
    echo ""
}

# ─────────────────────────────────────────
# Main menu
# ─────────────────────────────────────────
main_menu() {
    load_progress

    echo -e "  ${BYELLOW}MAIN MENU${RESET}"
    echo ""
    echo -e "  ${WHITE}  1) New Game${RESET}"
    echo -e "  ${WHITE}  2) Continue  ${DIM}(Chapter ${SAVE_CHAPTER})${RESET}"
    echo -e "  ${WHITE}  3) Chapter Select${RESET}"
    echo -e "  ${WHITE}  4) How to Play${RESET}"
    echo -e "  ${WHITE}  5) Reset Progress${RESET}"
    echo -e "  ${WHITE}  q) Quit${RESET}"
    echo ""
    printf "  Your choice: "
    read -r choice
    echo ""

    case "$choice" in
        1) new_game ;;
        2) continue_game ;;
        3) chapter_select ;;
        4) how_to_play ;;
        5) confirm_reset ;;
        q|Q) quit_game ;;
        *) echo -e "  ${RED}Unknown choice.${RESET}"; sleep 1; main_menu ;;
    esac
}

# ─────────────────────────────────────────
# New game
# ─────────────────────────────────────────
new_game() {
    clear_screen
    echo -e "${BYELLOW}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║           A NEW ADVENTURE BEGINS!         ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"

    if load_progress && [[ -n "$SAVE_COMPLETED" ]]; then
        echo -e "  ${YELLOW}Warning: You have existing progress!${RESET}"
        echo -e "  ${WHITE}Starting a new game will reset it.${RESET}"
        echo ""
        printf "  Continue? (y/N): "
        read -r yn
        [[ "${yn,,}" == "y" ]] || { main_menu; return; }
        reset_progress
    fi

    echo ""
    narrate "Your adventure in the World of Neovim begins..."
    narrate "You are a young warrior who has just discovered"
    narrate "the ancient power of text editing."
    echo ""
    press_enter
    run_chapter 1
}

# ─────────────────────────────────────────
# Continue game
# ─────────────────────────────────────────
continue_game() {
    load_progress
    if [[ -z "$SAVE_COMPLETED" ]]; then
        echo -e "  ${YELLOW}No save found.  Starting new game...${RESET}"
        sleep 1
        new_game
        return
    fi
    # If all chapters complete, show the chapter select instead
    if is_complete "$TOTAL_CHAPTERS"; then
        echo -e "  ${BGREEN}You have completed all chapters!  Replaying from Chapter Select...${RESET}"
        sleep 2
        chapter_select
        return
    fi
    run_chapter "$SAVE_CHAPTER"
}

# ─────────────────────────────────────────
# Chapter select
# ─────────────────────────────────────────
chapter_select() {
    clear_screen
    load_progress

    print_box "CHAPTER SELECT" "$BCYAN"
    echo -e "  ${WHITE}Unlocked chapters (up to Chapter ${SAVE_CHAPTER}):${RESET}"
    echo ""

    local chapters=(
        "1:🏘  The Village of Vim       (Movement)"
        "2:🔮  The Cave of Cursors      (Insert Mode)"
        "3:👻  The Haunted Scriptorium  (Deletion)"
        "4:🔭  The Oracle's Peak        (Search & Replace)"
        "5:🗼  The Tmux Tower           (tmux)"
        "6:🏰  The LazyVim Citadel      (LazyVim)"
    )

    for entry in "${chapters[@]}"; do
        local num="${entry%%:*}"
        local title="${entry#*:}"
        local status=""
        if is_complete "$num"; then
            status="${BGREEN}[✔ DONE]${RESET}"
        elif (( num <= SAVE_CHAPTER )); then
            status="${YELLOW}[UNLOCKED]${RESET}"
        else
            status="${DIM}[LOCKED]${RESET}"
        fi
        printf "  %s  Chapter %s  %s  %b\n" "" "$num" "$title" "$status"
    done

    echo ""
    echo -e "  ${WHITE}Enter chapter number (1-${TOTAL_CHAPTERS}) or  q  to go back:${RESET}"
    printf "  Choice: "
    read -r ch
    echo ""

    case "$ch" in
        q|Q) show_title; main_menu; return ;;
        [1-6])
            if (( ch <= SAVE_CHAPTER )); then
                run_chapter "$ch"
            else
                echo -e "  ${RED}That chapter is locked!  Complete earlier chapters first.${RESET}"
                sleep 2
                chapter_select
            fi
            ;;
        *) echo -e "  ${RED}Invalid choice.${RESET}"; sleep 1; chapter_select ;;
    esac
}

# ─────────────────────────────────────────
# How to play
# ─────────────────────────────────────────
how_to_play() {
    clear_screen
    print_box "HOW TO PLAY" "$BYELLOW"

    cat << EOF

  ${BOLD}The World of Neovim${RESET} is a terminal RPG where you learn
  Neovim, tmux, and LazyVim by completing quests.

  ${BYELLOW}Gameplay Loop:${RESET}
  ${WHITE}  1. Read the story and learn the commands in the game.${RESET}
  ${WHITE}  2. The game opens a LESSON FILE in Neovim (nvim).${RESET}
  ${WHITE}  3. Read the instructions inside the file.${RESET}
  ${WHITE}  4. Complete the editing task described in the file.${RESET}
  ${WHITE}  5. Save and quit Neovim (:wq) to return to the game.${RESET}
  ${WHITE}  6. The game verifies your work and advances the story!${RESET}

  ${BYELLOW}Key Neovim Basics (always useful):${RESET}
  ${CYAN}  Esc        ${WHITE}Return to Normal mode${RESET}
  ${CYAN}  :wq        ${WHITE}Save and quit${RESET}
  ${CYAN}  :q!        ${WHITE}Quit without saving (if stuck)${RESET}
  ${CYAN}  u          ${WHITE}Undo${RESET}
  ${CYAN}  Ctrl-r     ${WHITE}Redo${RESET}

  ${BYELLOW}Tips:${RESET}
  ${WHITE}  • If you make a mistake in Neovim, press  u  to undo.${RESET}
  ${WHITE}  • If you are completely lost, press  Esc  then  :q!  to${RESET}
  ${WHITE}    quit without saving and try the chapter again.${RESET}
  ${WHITE}  • Each chapter can be retried as many times as needed.${RESET}

EOF

    press_enter
    show_title
    main_menu
}

# ─────────────────────────────────────────
# Reset progress
# ─────────────────────────────────────────
confirm_reset() {
    echo -e "  ${BRED}Are you sure you want to reset ALL progress? (yes/N)${RESET}"
    printf "  Confirm: "
    read -r yn
    if [[ "${yn,,}" == "yes" ]]; then
        reset_progress
        echo -e "  ${GREEN}Progress reset.${RESET}"
    else
        echo -e "  ${DIM}Cancelled.${RESET}"
    fi
    sleep 1
    show_title
    main_menu
}

# ─────────────────────────────────────────
# Quit
# ─────────────────────────────────────────
quit_game() {
    clear_screen
    echo -e "${BYELLOW}"
    cat << 'ASCII'
    ╔══════════════════════════════════════════════╗
    ║                                              ║
    ║   "May your keystrokes be swift,             ║
    ║    your buffers always saved,                ║
    ║    and your terminal ever multiplexed."      ║
    ║                                              ║
    ║            — Elder Vimsworth                 ║
    ║                                              ║
    ╚══════════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    echo -e "  ${CYAN}Thanks for playing The World of Neovim!${RESET}"
    echo ""
    exit 0
}

# ─────────────────────────────────────────
# Run a chapter
# ─────────────────────────────────────────
run_chapter() {
    local ch="$1"
    local script="${GAME_DIR}/chapters/ch0${ch}.sh"

    if [[ ! -f "$script" ]]; then
        echo -e "  ${RED}Error: Chapter $ch script not found: $script${RESET}"
        sleep 2
        show_title
        main_menu
        return
    fi

    chmod +x "$script"
    bash "$script"

    # After chapter completes, show next-chapter prompt
    load_progress
    local next=$(( ch + 1 ))

    clear_screen

    if (( next <= TOTAL_CHAPTERS )); then
        echo -e "  ${BGREEN}Chapter $ch complete!${RESET}"
        echo ""
        show_status "$ch" "$TOTAL_CHAPTERS"
        echo ""
        echo -e "  ${WHITE}  1) Continue to Chapter $next${RESET}"
        echo -e "  ${WHITE}  2) Return to Main Menu${RESET}"
        echo ""
        printf "  Choice: "
        read -r choice
        case "$choice" in
            1) run_chapter "$next" ;;
            *) show_title; main_menu ;;
        esac
    else
        # Game complete
        echo -e "${BYELLOW}"
        cat << 'ASCII'
    ╔══════════════════════════════════════════════════════╗
    ║                                                      ║
    ║   🏆  CONGRATULATIONS!  YOU COMPLETED THE GAME!  🏆  ║
    ║                                                      ║
    ║   You are now a certified Vim Legend!                ║
    ║   The World of Neovim is safe forever.               ║
    ║                                                      ║
    ╚══════════════════════════════════════════════════════╝
ASCII
        echo -e "${RESET}"
        echo ""
        press_enter
        show_title
        main_menu
    fi
}

# ─────────────────────────────────────────
# Entry point
# ─────────────────────────────────────────
main() {
    check_deps
    show_title
    main_menu
}

main
