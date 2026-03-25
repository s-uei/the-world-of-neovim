#!/usr/bin/env bash
# chapters/ja/ch04.sh — 第4章: 神託の峰 (検索と置換)

source "$(dirname "$0")/../../lib/ui.sh"
source "$(dirname "$0")/../../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ja/ch04.txt"
TASK_FILE="/tmp/neovim_rpg_ch04.txt"
CHAPTER_NUM=4

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "神託の峰" "クエスト: 預言を解読せよ"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
                /\
               /  \
              / 🔭 \        神  託  の
             /      \
            /  峰    \      峰
           /~~~~~~~~~~\
          /  🌙  ☁️  🌙 \
         /              \   「真実は偽りの言葉の
        /    ~~霧~~      \   裏に隠れている...」
       /__________________\
             |  |
             |  |
      ███████████████████
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "霧深い階段を登り、頂上に出ました。"
    narrate "水晶の球が古代の光で脈打っています。神託が語りかけます:"
    echo ""
    say "神託" "$BYELLOW" "戦士よ...あなたが来ることは見えていた。"
    say "神託" "$BYELLOW" "しかしGUIの魔法使いが私の預言を混乱させてしまった！"
    say "神託" "$BYELLOW" "真実は偽りの言葉の裏に隠されている。"
    say "神託" "$BYELLOW" "検索と置換の術を使ってそれを明らかにせよ！"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}あなたのクエスト:${RESET}"
    echo -e "  ${WHITE}巻物を開き、ENCODED PROPHECY (暗号化された預言) セクションで"
    echo -e "  以下の置換を行い、神託の真の言葉を明らかにせよ:${RESET}"
    echo ""
    echo -e "  ${YELLOW}  KEYBOARD → SWORD${RESET}"
    echo -e "  ${YELLOW}  NORMAL   → PEACE${RESET}"
    echo -e "  ${YELLOW}  INSERT   → CREATION${RESET}"
    echo -e "  ${YELLOW}  /SEARCH  → WISDOM${RESET}"
    echo -e "  ${YELLOW}  NEOVIM   → DESTINY${RESET}"
    echo ""
    show_hint ":s/KEYBOARD/SWORD/g を使って該当行で置換するか、"
    show_hint ":%s/KEYBOARD/SWORD/g でファイル全体を置換できます"
    show_hint "ENCODED PROPHECY セクションは --- マーカーの間にあります"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}神託の巻物をNeovimで開いています...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    local pass=true
    local msgs=()

    local prophecy_section
    prophecy_section=$(awk '/--- ENCODED PROPHECY/,/--- END OF ENCODED PROPHECY/' "$TASK_FILE" 2>/dev/null)

    echo "$prophecy_section" | grep -q "SWORD" || \
        { pass=false; msgs+=("KEYBOARDがSWORDに置換されていません"); }

    echo "$prophecy_section" | grep -q "PEACE" || \
        { pass=false; msgs+=("NORMALがPEACEに置換されていません"); }

    echo "$prophecy_section" | grep -q "CREATION" || \
        { pass=false; msgs+=("INSERTがCREATIONに置換されていません"); }

    echo "$prophecy_section" | grep -q "WISDOM" || \
        { pass=false; msgs+=("/SEARCHがWISDOMに置換されていません"); }

    echo "$prophecy_section" | grep -q "DESTINY" || \
        { pass=false; msgs+=("NEOVIMがDESTINYに置換されていません"); }

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
    chapter_banner "$CHAPTER_NUM" "神託の峰" "クエスト完了！"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
    ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦

       神託の真の預言が明らかになった:

       「SWORDの力が稲妻のように指先から流れる。
        戦士が剣を収めるように、PEACEに戻れ。
        CREATIONモードで、デジタルの領域に意志を刻め。
        WISDOMが灯籠のように闇の中を導いてくれる。
        DESTINYとは現代の光の中で生まれ変わった古代の術だ。」

    ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦ ✦
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "水晶の球が黄金の光で輝きます。"
    narrate "神託の真の預言が霧深い山頂にこだまします。"
    echo ""
    say "神託" "$BYELLOW" "そうだ！偽りの中に真実を見つけたな！"
    say "神託" "$BYELLOW" "次の試練は遠くに見える — Tmuxの塔だ！"
    say "神託" "$BYELLOW" "そこでは複数の領域を同時に支配することを学ばなければならない。"
    say "神託" "$BYELLOW" "プレフィックス Ctrl-b がその全ての力の鍵となる。"
    echo ""
    show_reward "300" "検索と置換習得 (/パターン, :s, :%s, n, N, *)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}解読された預言を検証しています...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "神託の預言が正常に解読されました！"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "預言にまだ暗号化された言葉が残っています！もう一度挑戦！"
            echo ""
            if (( attempts == 1 )); then
                show_hint "--- ENCODED PROPHECY --- マーカーの間の行を編集してください"
                show_hint "試してみてください: :%s/KEYBOARD/SWORD/g (その後各単語ペアで繰り返す)"
                show_hint "/SEARCHについて: :%s/\\/SEARCH/WISDOM/g (スラッシュをエスケープする)"
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
