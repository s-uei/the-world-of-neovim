#!/usr/bin/env bash
# chapters/ch05.sh — Chapter 5: The Tmux Tower (tmux basics)

source "$(dirname "$0")/../lib/ui.sh"
source "$(dirname "$0")/../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ch05.txt"
TASK_FILE="/tmp/neovim_rpg_ch05.txt"
CHAPTER_NUM=5

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE TMUX TOWER" "Quest: Control the Multiplexed Realm"

    echo -e "${BCYAN}"
    cat << 'ASCIIART'
            ___________
           |  T M U X  |
           |  T O W E R|
           |___________|
          /|           |\
         / |  [WIN 1]  | \
        /  |  [WIN 2]  |  \
       /   |  [WIN 3]  |   \
      _____|___________|_____
     |  PANE 1  |  PANE 2   |
     |          |            |
     |  PANE 3  |  PANE 4   |
     |__________|____________|
         THE MULTIPLEXED REALM
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "You descend from the Oracle's Peak and reach the base of an"
    narrate "enormous tower.  Its walls are covered in terminal screens,"
    narrate "each showing a different view of reality — all at once!"
    echo ""
    say "Tower Guardian Multiplex" "$BCYAN" "HALT!  You dare approach the Tmux Tower?"
    say "Tower Guardian Multiplex" "$BCYAN" "Only those who can wield the PREFIX shall enter!"
    say "Tower Guardian Multiplex" "$BCYAN" "The prefix is  Ctrl-b  — press and RELEASE, then command."
    say "Tower Guardian Multiplex" "$BCYAN" "Pass my four challenges, and the Tower is yours!"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}This chapter is different!${RESET}"
    echo -e "  ${WHITE}First, read the lesson scroll in Neovim.${RESET}"
    echo -e "  ${WHITE}Then, the game will guide you through FOUR tmux challenges.${RESET}"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}Opening the Tower Manual in Neovim...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

# ─────────────────────────────────────────
# tmux challenges (interactive)
# ─────────────────────────────────────────

challenge_session() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   CHALLENGE 1: Create a tmux Session      ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "Multiplex" "$BCYAN" "First challenge: Create a named tmux session!"
    echo ""
    echo -e "  ${WHITE}Open a NEW terminal tab or window and run:${RESET}"
    echo ""
    echo -e "  ${BGREEN}  tmux new -s vim-tower${RESET}"
    echo ""
    echo -e "  ${WHITE}Then detach from it with:  ${BGREEN}Ctrl-b  then  d${RESET}"
    echo -e "  ${WHITE}And return here to verify.${RESET}"
    echo ""
    show_hint "If you are already inside tmux, you can also run: tmux new -s vim-tower -d"
    echo ""
    press_enter_msg "Press ENTER once you have created and detached from the session"

    # Verify session exists
    if tmux has-session -t vim-tower 2>/dev/null; then
        show_success "Session 'vim-tower' detected!  Challenge 1 complete!"
        return 0
    else
        # Give a second chance
        show_failure "Session 'vim-tower' not found."
        echo ""
        show_hint "Try running:  tmux new -s vim-tower -d"
        echo ""
        press_enter_msg "Press ENTER to re-check"
        if tmux has-session -t vim-tower 2>/dev/null; then
            show_success "Session 'vim-tower' detected!  Challenge 1 complete!"
            return 0
        else
            show_failure "Still not found.  Skipping challenge 1..."
            return 1
        fi
    fi
}

challenge_split() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   CHALLENGE 2: Split into Panes           ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "Multiplex" "$BCYAN" "Second challenge: Split your screen!"
    echo ""
    echo -e "  ${WHITE}Inside your tmux session, split the pane:${RESET}"
    echo ""
    echo -e "  ${BGREEN}  Ctrl-b  then  %    (vertical split — side by side)${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  then  \"    (horizontal split — top and bottom)${RESET}"
    echo ""
    echo -e "  ${WHITE}Navigate between panes with:${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  then  Arrow key${RESET}"
    echo ""
    echo -e "  ${DIM}Try splitting both ways!  Use  Ctrl-b x  to close a pane.${RESET}"
    echo ""
    press_enter_msg "Press ENTER when you have tried splitting panes"
    show_success "Excellent!  Pane splitting mastered!"
    return 0
}

challenge_window() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   CHALLENGE 3: Create & Rename a Window   ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "Multiplex" "$BCYAN" "Third challenge: Create a window named 'vim-realm'!"
    echo ""
    echo -e "  ${WHITE}Inside your tmux session:${RESET}"
    echo ""
    echo -e "  ${BGREEN}  Ctrl-b  then  c    (create new window)${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  then  ,    (rename current window)${RESET}"
    echo -e "  ${BGREEN}  Type:  vim-realm   then press Enter${RESET}"
    echo ""
    echo -e "  ${WHITE}Switch between windows with:${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  then  n    (next window)${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  then  p    (previous window)${RESET}"
    echo ""
    press_enter_msg "Press ENTER once you have created and named the window 'vim-realm'"

    # Verify window exists
    if tmux list-windows -t vim-tower 2>/dev/null | grep -q "vim-realm"; then
        show_success "Window 'vim-realm' found in session vim-tower!  Challenge 3 complete!"
        return 0
    else
        show_failure "Window 'vim-realm' not found in vim-tower session."
        show_hint "Make sure you are in the vim-tower session and renamed the window exactly: vim-realm"
        press_enter_msg "Press ENTER to re-check"
        if tmux list-windows -t vim-tower 2>/dev/null | grep -q "vim-realm"; then
            show_success "Window 'vim-realm' found!  Challenge 3 complete!"
            return 0
        else
            show_failure "Skipping challenge 3..."
            return 1
        fi
    fi
}

challenge_detach() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   CHALLENGE 4: Detach & Reattach          ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "Multiplex" "$BCYAN" "Final challenge: Master session persistence!"
    echo ""
    echo -e "  ${WHITE}Detach from the session:${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  then  d${RESET}"
    echo ""
    echo -e "  ${WHITE}List all sessions:${RESET}"
    echo -e "  ${BGREEN}  tmux ls${RESET}"
    echo ""
    echo -e "  ${WHITE}Reattach to it:${RESET}"
    echo -e "  ${BGREEN}  tmux attach -t vim-tower${RESET}"
    echo ""
    echo -e "  ${DIM}This is tmux's superpower: sessions survive terminal closures!${RESET}"
    echo ""
    press_enter_msg "Press ENTER once you have practiced detach/reattach"
    show_success "Session management mastered!  The Tower bows before you!"
    return 0
}

show_outro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "THE TMUX TOWER" "Quest Complete!"

    echo -e "${BCYAN}"
    cat << 'ASCIIART'
    ╔═══════════════════════════════════════════════════════╗
    ║                                                       ║
    ║   ★  THE TMUX TOWER BOWS BEFORE YOU!  ★              ║
    ║                                                       ║
    ║   Sessions: ✓   Panes: ✓   Windows: ✓   Detach: ✓   ║
    ║                                                       ║
    ║   You can now control MULTIPLE REALMS simultaneously! ║
    ║   The world bends to your terminal multiplexing will! ║
    ║                                                       ║
    ╚═══════════════════════════════════════════════════════╝
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "Guardian Multiplex kneels in respect."
    echo ""
    say "Multiplex" "$BCYAN" "Incredible!  You have mastered the Multiplexed Realm!"
    say "Multiplex" "$BCYAN" "Only one final trial awaits you: the LazyVim Citadel."
    say "Multiplex" "$BCYAN" "The GUI Sorcerer awaits his final defeat.  Go, warrior!"
    echo ""
    show_reward "350" "tmux Mastery (sessions, panes, windows, detach/attach)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    run_lesson

    clear_screen
    echo -e "  ${BCYAN}The Tower Guardian awaits your challenges...${RESET}"
    sleep 1

    challenge_session
    sleep 1
    challenge_split
    sleep 1
    challenge_window
    sleep 1
    challenge_detach
    sleep 1

    show_outro
    mark_complete "$CHAPTER_NUM"
}

main
