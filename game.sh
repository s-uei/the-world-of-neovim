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
LANG_MODE="en"  # "en" or "ja"

# ─────────────────────────────────────────
# Language selection
# ─────────────────────────────────────────
select_language() {
    clear
    echo ""
    echo -e "${BYELLOW}  ═══════════════════════════════════════${RESET}"
    echo -e "${BYELLOW}    The World of Neovim  /  Neovimの世界${RESET}"
    echo -e "${BYELLOW}  ═══════════════════════════════════════${RESET}"
    echo ""
    echo -e "  ${WHITE}Select language / 言語を選択してください:${RESET}"
    echo ""
    echo -e "  ${WHITE}  1) English${RESET}"
    echo -e "  ${WHITE}  2) 日本語 (Japanese)${RESET}"
    echo ""
    printf "  Choice / 選択: "
    read -r lang_choice
    echo ""
    case "$lang_choice" in
        2) LANG_MODE="ja" ;;
        *) LANG_MODE="en" ;;
    esac
    export LANG_MODE
}

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
        if [[ "$LANG_MODE" == "ja" ]]; then
            echo -e "${BRED}エラー: 必要なツールがありません:${RESET}"
            for dep in "${missing[@]}"; do
                echo -e "  ${RED}• $dep${RESET}"
            done
            echo ""
            echo -e "${YELLOW}不足しているツールをインストールしてから再試行してください。${RESET}"
        else
            echo -e "${BRED}ERROR: Missing required tools:${RESET}"
            for dep in "${missing[@]}"; do
                echo -e "  ${RED}• $dep${RESET}"
            done
            echo ""
            echo -e "${YELLOW}Please install the missing tools and try again.${RESET}"
        fi
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
    if [[ "$LANG_MODE" == "ja" ]]; then
        cat << 'TAGLINE'
    ─────────────────────────────────────────────────────────────────────────
         Neovim、tmux、LazyVimをマスターするRPGアドベンチャー
         「キーボードはあなたの剣。  ターミナルはあなたの領土。」
    ─────────────────────────────────────────────────────────────────────────
TAGLINE
    else
        cat << 'TAGLINE'
    ─────────────────────────────────────────────────────────────────────────
         An RPG Adventure to Master Neovim, tmux, and LazyVim
         "The keyboard is your sword.  The terminal is your realm."
    ─────────────────────────────────────────────────────────────────────────
TAGLINE
    fi
    echo -e "${RESET}"
    echo ""

    # Show chapter map
    if [[ "$LANG_MODE" == "ja" ]]; then
        echo -e "  ${BYELLOW}⚔  冒険の旅路:${RESET}"
        echo ""
        echo -e "  ${CYAN}  第1章${RESET}  ${WHITE}🏘  ヴィムの村           ${DIM}(移動)${RESET}"
        echo -e "  ${CYAN}  第2章${RESET}  ${WHITE}🔮  カーソルの洞窟       ${DIM}(挿入モード)${RESET}"
        echo -e "  ${CYAN}  第3章${RESET}  ${WHITE}👻  幽霊の写本室         ${DIM}(削除)${RESET}"
        echo -e "  ${CYAN}  第4章${RESET}  ${WHITE}🔭  神託の峰             ${DIM}(検索と置換)${RESET}"
        echo -e "  ${CYAN}  第5章${RESET}  ${WHITE}🗼  Tmuxの塔             ${DIM}(tmux基礎)${RESET}"
        echo -e "  ${CYAN}  第6章${RESET}  ${WHITE}🏰  LazyVimの城塞        ${DIM}(LazyVim + 最終決戦)${RESET}"
    else
        echo -e "  ${BYELLOW}⚔  THE ADVENTURE:${RESET}"
        echo ""
        echo -e "  ${CYAN}  Chapter 1${RESET}  ${WHITE}🏘  The Village of Vim       ${DIM}(Movement)${RESET}"
        echo -e "  ${CYAN}  Chapter 2${RESET}  ${WHITE}🔮  The Cave of Cursors      ${DIM}(Insert Mode)${RESET}"
        echo -e "  ${CYAN}  Chapter 3${RESET}  ${WHITE}👻  The Haunted Scriptorium  ${DIM}(Deletion)${RESET}"
        echo -e "  ${CYAN}  Chapter 4${RESET}  ${WHITE}🔭  The Oracle's Peak        ${DIM}(Search & Replace)${RESET}"
        echo -e "  ${CYAN}  Chapter 5${RESET}  ${WHITE}🗼  The Tmux Tower           ${DIM}(tmux Basics)${RESET}"
        echo -e "  ${CYAN}  Chapter 6${RESET}  ${WHITE}🏰  The LazyVim Citadel      ${DIM}(LazyVim + Final Battle)${RESET}"
    fi
    echo ""
    separator
    echo ""
}

# ─────────────────────────────────────────
# Main menu
# ─────────────────────────────────────────
main_menu() {
    load_progress

    if [[ "$LANG_MODE" == "ja" ]]; then
        echo -e "  ${BYELLOW}メインメニュー${RESET}"
        echo ""
        echo -e "  ${WHITE}  1) 新しいゲーム${RESET}"
        echo -e "  ${WHITE}  2) 続きから  ${DIM}(第${SAVE_CHAPTER}章)${RESET}"
        echo -e "  ${WHITE}  3) チャプター選択${RESET}"
        echo -e "  ${WHITE}  4) 遊び方${RESET}"
        echo -e "  ${WHITE}  5) 進行状況リセット${RESET}"
        echo -e "  ${WHITE}  q) 終了${RESET}"
        echo ""
        printf "  選択してください: "
    else
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
    fi
    read -r choice
    echo ""

    case "$choice" in
        1) new_game ;;
        2) continue_game ;;
        3) chapter_select ;;
        4) how_to_play ;;
        5) confirm_reset ;;
        q|Q) quit_game ;;
        *) if [[ "$LANG_MODE" == "ja" ]]; then
               echo -e "  ${RED}無効な選択です。${RESET}"
           else
               echo -e "  ${RED}Unknown choice.${RESET}"
           fi
           sleep 1; main_menu ;;
    esac
}

# ─────────────────────────────────────────
# New game
# ─────────────────────────────────────────
new_game() {
    clear_screen
    echo -e "${BYELLOW}"
    if [[ "$LANG_MODE" == "ja" ]]; then
        cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║         新たなる冒険が始まる！            ║
    ╚═══════════════════════════════════════════╝
ASCII
    else
        cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║           A NEW ADVENTURE BEGINS!         ║
    ╚═══════════════════════════════════════════╝
ASCII
    fi
    echo -e "${RESET}"

    if load_progress && [[ -n "$SAVE_COMPLETED" ]]; then
        if [[ "$LANG_MODE" == "ja" ]]; then
            echo -e "  ${YELLOW}警告: 既存の進行状況があります！${RESET}"
            echo -e "  ${WHITE}新しいゲームを始めると、進行状況がリセットされます。${RESET}"
            echo ""
            printf "  続けますか？ (y/N): "
        else
            echo -e "  ${YELLOW}Warning: You have existing progress!${RESET}"
            echo -e "  ${WHITE}Starting a new game will reset it.${RESET}"
            echo ""
            printf "  Continue? (y/N): "
        fi
        read -r yn
        [[ "${yn,,}" == "y" ]] || { main_menu; return; }
        reset_progress
    fi

    echo ""
    if [[ "$LANG_MODE" == "ja" ]]; then
        narrate "Neovimの世界での冒険が始まります..."
        narrate "あなたはテキスト編集の古代の力を発見した"
        narrate "若き戦士です。"
    else
        narrate "Your adventure in the World of Neovim begins..."
        narrate "You are a young warrior who has just discovered"
        narrate "the ancient power of text editing."
    fi
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
        if [[ "$LANG_MODE" == "ja" ]]; then
            echo -e "  ${YELLOW}セーブデータがありません。新しいゲームを始めます...${RESET}"
        else
            echo -e "  ${YELLOW}No save found.  Starting new game...${RESET}"
        fi
        sleep 1
        new_game
        return
    fi
    # If all chapters complete, show the chapter select instead
    if is_complete "$TOTAL_CHAPTERS"; then
        if [[ "$LANG_MODE" == "ja" ]]; then
            echo -e "  ${BGREEN}全チャプターを完了しました！チャプター選択に移動します...${RESET}"
        else
            echo -e "  ${BGREEN}You have completed all chapters!  Replaying from Chapter Select...${RESET}"
        fi
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

    if [[ "$LANG_MODE" == "ja" ]]; then
        print_box "チャプター選択" "$BCYAN"
        echo -e "  ${WHITE}解放済みチャプター (第${SAVE_CHAPTER}章まで):${RESET}"
        echo ""

        local chapters=(
            "1:🏘  ヴィムの村           (移動)"
            "2:🔮  カーソルの洞窟       (挿入モード)"
            "3:👻  幽霊の写本室         (削除)"
            "4:🔭  神託の峰             (検索と置換)"
            "5:🗼  Tmuxの塔             (tmux)"
            "6:🏰  LazyVimの城塞        (LazyVim)"
        )

        for entry in "${chapters[@]}"; do
            local num="${entry%%:*}"
            local title="${entry#*:}"
            local status=""
            if is_complete "$num"; then
                status="${BGREEN}[✔ 完了]${RESET}"
            elif (( num <= SAVE_CHAPTER )); then
                status="${YELLOW}[解放済み]${RESET}"
            else
                status="${DIM}[ロック中]${RESET}"
            fi
            printf "  %s  第%s章  %s  %b\n" "" "$num" "$title" "$status"
        done

        echo ""
        echo -e "  ${WHITE}チャプター番号を入力 (1-${TOTAL_CHAPTERS}) または q で戻る:${RESET}"
        printf "  選択: "
    else
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
    fi
    read -r ch
    echo ""

    case "$ch" in
        q|Q) show_title; main_menu; return ;;
        [1-6])
            if (( ch <= SAVE_CHAPTER )); then
                run_chapter "$ch"
            else
                if [[ "$LANG_MODE" == "ja" ]]; then
                    echo -e "  ${RED}そのチャプターはロックされています！先に前のチャプターを完了してください。${RESET}"
                else
                    echo -e "  ${RED}That chapter is locked!  Complete earlier chapters first.${RESET}"
                fi
                sleep 2
                chapter_select
            fi
            ;;
        *)
            if [[ "$LANG_MODE" == "ja" ]]; then
                echo -e "  ${RED}無効な選択です。${RESET}"
            else
                echo -e "  ${RED}Invalid choice.${RESET}"
            fi
            sleep 1; chapter_select ;;
    esac
}

# ─────────────────────────────────────────
# How to play
# ─────────────────────────────────────────
how_to_play() {
    clear_screen
    if [[ "$LANG_MODE" == "ja" ]]; then
        print_box "遊び方" "$BYELLOW"
        cat << EOF

  ${BOLD}Neovimの世界${RESET} は、クエストを通じて
  Neovim、tmux、LazyVimを学ぶターミナルRPGです。

  ${BYELLOW}ゲームの流れ:${RESET}
  ${WHITE}  1. ゲーム内でストーリーを読み、コマンドを学びましょう。${RESET}
  ${WHITE}  2. ゲームがNeovimでレッスンファイルを開きます。${RESET}
  ${WHITE}  3. ファイル内の指示を読んでください。${RESET}
  ${WHITE}  4. ファイルに書かれた編集タスクを完成させましょう。${RESET}
  ${WHITE}  5. Neovimを保存して終了 (:wq) するとゲームに戻ります。${RESET}
  ${WHITE}  6. ゲームがあなたの作業を検証し、ストーリーが進みます！${RESET}

  ${BYELLOW}Neovimの基本 (常に役立つ):${RESET}
  ${CYAN}  Esc        ${WHITE}ノーマルモードに戻る${RESET}
  ${CYAN}  :wq        ${WHITE}保存して終了${RESET}
  ${CYAN}  :q!        ${WHITE}保存せずに強制終了${RESET}
  ${CYAN}  u          ${WHITE}元に戻す (Undo)${RESET}
  ${CYAN}  Ctrl-r     ${WHITE}やり直し (Redo)${RESET}

  ${BYELLOW}ヒント:${RESET}
  ${WHITE}  • Neovimでミスをしたら、u キーで元に戻せます。${RESET}
  ${WHITE}  • 完全に迷ったら Esc を押してから :q! で保存せずに${RESET}
  ${WHITE}    終了し、もう一度チャプターに挑戦できます。${RESET}
  ${WHITE}  • 各チャプターは何度でも再挑戦できます。${RESET}

EOF
    else
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
    fi

    press_enter
    show_title
    main_menu
}

# ─────────────────────────────────────────
# Reset progress
# ─────────────────────────────────────────
confirm_reset() {
    if [[ "$LANG_MODE" == "ja" ]]; then
        echo -e "  ${BRED}本当に全ての進行状況をリセットしますか？ (yes/N)${RESET}"
        printf "  確認: "
    else
        echo -e "  ${BRED}Are you sure you want to reset ALL progress? (yes/N)${RESET}"
        printf "  Confirm: "
    fi
    read -r yn
    if [[ "${yn,,}" == "yes" ]]; then
        reset_progress
        if [[ "$LANG_MODE" == "ja" ]]; then
            echo -e "  ${GREEN}進行状況をリセットしました。${RESET}"
        else
            echo -e "  ${GREEN}Progress reset.${RESET}"
        fi
    else
        if [[ "$LANG_MODE" == "ja" ]]; then
            echo -e "  ${DIM}キャンセルしました。${RESET}"
        else
            echo -e "  ${DIM}Cancelled.${RESET}"
        fi
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
    if [[ "$LANG_MODE" == "ja" ]]; then
        cat << 'ASCII'
    ╔══════════════════════════════════════════════╗
    ║                                              ║
    ║   「キーストロークは迅速に、                 ║
    ║    バッファは常に保存され、                  ║
    ║    ターミナルは永遠に多重化されんことを。」  ║
    ║                                              ║
    ║            — 長老ヴィムズワース              ║
    ║                                              ║
    ╚══════════════════════════════════════════════╝
ASCII
        echo -e "${RESET}"
        echo ""
        echo -e "  ${CYAN}Neovimの世界をプレイしてくれてありがとう！${RESET}"
    else
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
    fi
    echo ""
    exit 0
}

# ─────────────────────────────────────────
# Run a chapter
# ─────────────────────────────────────────
run_chapter() {
    local ch="$1"
    local script
    if [[ "$LANG_MODE" == "ja" ]]; then
        script="${GAME_DIR}/chapters/ja/ch0${ch}.sh"
        # Fall back to English if Japanese script missing
        if [[ ! -f "$script" ]]; then
            script="${GAME_DIR}/chapters/ch0${ch}.sh"
        fi
    else
        script="${GAME_DIR}/chapters/ch0${ch}.sh"
    fi

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
        if [[ "$LANG_MODE" == "ja" ]]; then
            echo -e "  ${BGREEN}第${ch}章クリア！${RESET}"
            echo ""
            show_status "$ch" "$TOTAL_CHAPTERS"
            echo ""
            echo -e "  ${WHITE}  1) 第${next}章へ進む${RESET}"
            echo -e "  ${WHITE}  2) メインメニューへ戻る${RESET}"
            echo ""
            printf "  選択: "
        else
            echo -e "  ${BGREEN}Chapter $ch complete!${RESET}"
            echo ""
            show_status "$ch" "$TOTAL_CHAPTERS"
            echo ""
            echo -e "  ${WHITE}  1) Continue to Chapter $next${RESET}"
            echo -e "  ${WHITE}  2) Return to Main Menu${RESET}"
            echo ""
            printf "  Choice: "
        fi
        read -r choice
        case "$choice" in
            1) run_chapter "$next" ;;
            *) show_title; main_menu ;;
        esac
    else
        # Game complete
        echo -e "${BYELLOW}"
        if [[ "$LANG_MODE" == "ja" ]]; then
            cat << 'ASCII'
    ╔══════════════════════════════════════════════════════╗
    ║                                                      ║
    ║   🏆  おめでとうございます！ゲームクリア！  🏆      ║
    ║                                                      ║
    ║   あなたはVimの伝説となりました！                    ║
    ║   Neovimの世界は永遠に安全です。                     ║
    ║                                                      ║
    ╚══════════════════════════════════════════════════════╝
ASCII
        else
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
        fi
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
    select_language
    show_title
    main_menu
}

main
