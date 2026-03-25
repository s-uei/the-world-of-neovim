#!/usr/bin/env bash
# chapters/ja/ch01.sh — 第1章: ヴィムの村 (移動の基礎)

# shellcheck source=../../lib/ui.sh
source "$(dirname "$0")/../../lib/ui.sh"
# shellcheck source=../../lib/progress.sh
source "$(dirname "$0")/../../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ja/ch01.txt"
TASK_FILE="/tmp/neovim_rpg_ch01.txt"
CHAPTER_NUM=1

# ─────────────────────────────────────────
# イントロシーケンス
# ─────────────────────────────────────────
show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "ヴィムの村" "クエスト: 燃える村からの脱出"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
         _______
        /       \         🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥
       | 🏠 ヴィム|
       |  の村   |        炎が広がっていく！
        \_______/
           |||             あなたはNeovimの古代の力を
        ///|||\\\\           発見したばかりの
       🔥🔥🔥🔥🔥🔥         若き冒険者です。
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "平和なヴィムの村が攻撃を受けています！"
    narrate "GUIの魔法使いが火を吐くマウスを送り込んできました。"
    narrate "炎が長老の小屋に迫る中、老いた魔法使いがあなたに駆け寄ってきます..."
    echo ""
    say "長老ヴィムズワース" "$BWHITE" "若き戦士よ！逃げるのだ — しかし道は険しい！"
    say "長老ヴィムズワース" "$BWHITE" "脱出の方法はただ一つ、Neovimの移動術を習得することだ。"
    say "長老ヴィムズワース" "$BWHITE" "この巻物を持って行け！  h j k l で動き、"
    say "長老ヴィムズワース" "$BWHITE" "w b e 0 \$ gg G で素早く移動するのだ。  走れ！"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}あなたのクエスト:${RESET}"
    echo -e "  ${WHITE}Neovimで巻物を開き、移動コマンドを学び、"
    echo -e "  村の地図に隠された3つのルーンワードを見つけて記入せよ。${RESET}"
    echo ""
    show_hint "Neovimで G (大文字のG) を押すとファイルの末尾にある"
    show_hint "回答セクションに移動できます。"
    echo ""
    press_enter
}

# ─────────────────────────────────────────
# Neovimでレッスンファイルを開く
# ─────────────────────────────────────────
run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}古代の巻物をNeovimで開いています...${RESET}"
    echo -e "  ${DIM}(巻物の場所: $TASK_FILE)${RESET}"
    echo ""
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

# ─────────────────────────────────────────
# ユーザーの編集内容を検証する
# ─────────────────────────────────────────
verify() {
    local rune1 rune2 rune3
    rune1=$(grep -i "^  Rune 1:" "$TASK_FILE" 2>/dev/null | head -1 | sed 's/.*Rune 1:[[:space:]]*//' | tr -d '\r\n ')
    rune2=$(grep -i "^  Rune 2:" "$TASK_FILE" 2>/dev/null | head -1 | sed 's/.*Rune 2:[[:space:]]*//' | tr -d '\r\n ')
    rune3=$(grep -i "^  Rune 3:" "$TASK_FILE" 2>/dev/null | head -1 | sed 's/.*Rune 3:[[:space:]]*//' | tr -d '\r\n ')

    local pass=true
    local msgs=()

    [[ "${rune1^^}" == "EMBER"  ]] || { pass=false; msgs+=("ルーン1はEMBERのはず (入力値: '${rune1}')"); }
    [[ "${rune2^^}" == "SHADOW" ]] || { pass=false; msgs+=("ルーン2はSHADOWのはず (入力値: '${rune2}')"); }
    [[ "${rune3^^}" == "MOTION" ]] || { pass=false; msgs+=("ルーン3はMOTIONのはず (入力値: '${rune3}')"); }

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
# アウトロ — 成功シーケンス
# ─────────────────────────────────────────
show_outro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "ヴィムの村" "クエスト完了！"

    echo -e "${BGREEN}"
    cat << 'ASCIIART'
    ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★

       燃える村からの脱出に成功！

       3つのルーン — EMBER、SHADOW、MOTION — を手に、
       炎をくぐり抜けて森の端まで駆け抜けた。

    ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "あなたの背後で村が崩れ落ちる。しかし、あなたは生きている。"
    narrate "ルーンが手の中で輝き、一つの鍵となっていく..."
    echo ""
    say "長老ヴィムズワース" "$BWHITE" "やったな！移動の術はもうあなたの中にある。"
    say "長老ヴィムズワース" "$BWHITE" "しかし旅はまだ始まったばかりだ — より暗い試練が待っている。"
    say "長老ヴィムズワース" "$BWHITE" "前方にカーソルの洞窟がある。次は挿入モードをマスターせよ！"
    echo ""
    show_reward "150" "移動術習得 (hjkl, w, b, e, 0, \$, gg, G)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

# ─────────────────────────────────────────
# メイン
# ─────────────────────────────────────────
main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}巻物を確認しています...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "3つのルーンが正しく刻まれました！"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "ルーンが正しくありません。もう一度挑戦！"
            echo ""
            if (( attempts == 1 )); then
                show_hint "村の地図セクションに移動して [RUNE-X] → の後の単語を読んでください"
                show_hint "次に回答セクション (G を押して移動) で ??? を正しい単語に置き換えてください。"
            fi
            echo ""
            echo -e "  ${YELLOW}選択してください:${RESET}"
            echo -e "  ${WHITE}  r) もう一度挑戦 — 巻物を再び開く${RESET}"
            echo -e "  ${WHITE}  s) このチャプターをスキップ (XPなし)${RESET}"
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
