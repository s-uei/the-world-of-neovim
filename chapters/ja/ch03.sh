#!/usr/bin/env bash
# chapters/ja/ch03.sh — 第3章: 幽霊の写本室 (削除)

source "$(dirname "$0")/../../lib/ui.sh"
source "$(dirname "$0")/../../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ja/ch03.txt"
TASK_FILE="/tmp/neovim_rpg_ch03.txt"
CHAPTER_NUM=3

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "幽霊の写本室" "クエスト: 呪われた巻物を浄化せよ"

    echo -e "${BMAGENTA}"
    cat << 'ASCIIART'
    👻  👻  👻  👻  👻  👻  👻  👻  👻  👻

         幽  霊  の
         写  本  室

    📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚
    📖            📖        📖          📖
       👁️  巻物が汚染されている！ 👁️
    📖            📖        📖          📖
    📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚📚

    👻  👻  👻  👻  👻  👻  👻  👻  👻  👻
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "あなたは広大な幽霊の写本室に入りました — 巻物が空中を漂う"
    narrate "果てしない図書館です。しかし何かがひどく間違っています。"
    narrate "暗いインクがページを浸しています。"
    echo ""
    say "幽霊司書" "$BWHITE" "シーッ！若き戦士よ、こっちだ！"
    say "幽霊司書" "$BWHITE" "GUIの魔法使いの手下どもが聖なる預言を汚染した！"
    say "幽霊司書" "$BWHITE" "呪われた言葉と腐敗した行が挿入されているのだ。"
    say "幽霊司書" "$BWHITE" "それらを削除して真実を復元しなければならない！"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}あなたのクエスト:${RESET}"
    echo -e "  ${WHITE}巻物を開き、<<DELETE THIS LINE>> と書かれた行を全て削除し、"
    echo -e "  各行から --CURSED-- と書かれた単語を取り除け。${RESET}"
    echo ""
    show_hint "行全体を削除するには: dd"
    show_hint "カーソル下の単語を削除するには: dw または diw"
    show_hint "次の出現箇所を検索するには: /CURSED で検索してから n"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}汚染された巻物をNeovimで開いています...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    local pass=true
    local msgs=()

    if grep -q "<<DELETE THIS LINE>>" "$TASK_FILE"; then
        pass=false
        msgs+=("<<DELETE THIS LINE>> マーカーがまだ残っています — dd でその行を削除してください！")
    fi

    if grep -q -- "--CURSED--" "$TASK_FILE"; then
        pass=false
        msgs+=("--CURSED-- という単語がまだ残っています — dw または diw で削除してください！")
    fi

    grep -q "hero shall rise from the east" "$TASK_FILE" || \
        { pass=false; msgs+=("'hero shall rise' の行が見つかりません — 削除しすぎないように！"); }

    grep -q "wielding the sacred" "$TASK_FILE" || \
        { pass=false; msgs+=("'wielding the sacred' の行が見つかりません！"); }

    grep -q "Vim Warrior fights with keystrokes" "$TASK_FILE" || \
        { pass=false; msgs+=("'Vim Warrior' の最終預言行が見つかりません！"); }

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
    chapter_banner "$CHAPTER_NUM" "幽霊の写本室" "クエスト完了！"

    echo -e "${BGREEN}"
    cat << 'ASCIIART'
    ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨

       預言が復元された！

       英雄は東から現れ、
       光の聖なるエディタを手に持つ。
       GUIの魔法使いはその姿に戦慄する、
       鍵盤の上で舞う指を見て。
       マウスも、GUIも彼を縛れない、
       Vimの戦士はキーストロークで戦い続ける。

    ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨ ✨
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "暗いインクが消え去ります。巻物が純粋な黄金の光で輝きます。"
    narrate "幽霊司書が喜びの涙を流します (幽霊はちょっと変わっていますが)。"
    echo ""
    say "幽霊司書" "$BWHITE" "素晴らしい！預言を浄化してくれた！"
    say "幽霊司書" "$BWHITE" "削除の術は強力だ — しかし賢く使うのだ。"
    say "幽霊司書" "$BWHITE" "神託の峰への隠し階段が開いた！"
    echo ""
    show_reward "250" "削除術習得 (x, dd, dw, d\$, diw, u, Ctrl-r)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}巻物の汚染を調べています...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "巻物は完全に浄化されました！"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "巻物にまだ汚染が残っています！削除を続けてください！"
            echo ""
            if (( attempts == 1 )); then
                show_hint "<<DELETE を検索し、その行を dd で削除してください"
                show_hint "--CURSED-- を /--CURSED-- で検索し、dw で削除してください (各出現ごとに繰り返す)"
                show_hint "または :%g/DELETE THIS LINE/d でマークされた行をすべて一度に削除できます！"
            fi
            echo ""
            echo -e "  ${YELLOW}選択してください:${RESET}"
            echo -e "  ${WHITE}  r) もう一度挑戦${RESET}"
            echo -e "  ${WHITE}  s) このチャプターをスキップ${RESET}"
            echo ""
            printf "  選択: "
            read -r choice
            case "$choice" in
                s|S) echo -e "  ${DIM}チャプターをスキップ中...${RESET}"; break ;;
                *)   ;;
            esac
        fi
    done
}

main
