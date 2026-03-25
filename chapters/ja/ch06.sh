#!/usr/bin/env bash
# chapters/ja/ch06.sh — 第6章: LazyVimの城塞 (LazyVim + 最終決戦)

source "$(dirname "$0")/../../lib/ui.sh"
source "$(dirname "$0")/../../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ja/ch06.txt"
TASK_FILE="/tmp/neovim_rpg_ch06.txt"
CHAPTER_NUM=6

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "LazyVimの城塞" "クエスト: GUIの魔法使いを倒せ"

    echo -e "${BMAGENTA}"
    cat << 'ASCIIART'
    ████████████████████████████████████████████████████
    █                                                  █
    █     🏰  LazyVimの城塞                            █
    █                                                  █
    █  ⚔️  最終決戦が近づいている！  ⚔️                  █
    █                                                  █
    ████████████████████████████████████████████████████

          🐉 LazyVimドラゴンが降臨！ 🐉

       /\     /\
      /  \___/  \
     / ◉       ◉ \      「乗り手よ！私はLazyVim —
    |   _______   |      燃えるNeovimドラゴンだ！
    |  /       \  |      共にGUIの魔法使いを
     \/  🔥🔥🔥  \/      打ち砕こう！」
          |||
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "あなたはそびえ立つLazyVimの城塞の前に立っています。"
    narrate "その壁はプラグインの力とLSP診断で輝いています。"
    narrate "そして — 轟音が空を揺るがします！"
    echo ""
    say "LazyVimドラゴン" "$BMAGENTA" "グオォォォ！戦士よ！あなたを待っていた！"
    say "LazyVimドラゴン" "$BMAGENTA" "私はLazyVim、最強のNeovimディストリビューションだ！"
    say "LazyVimドラゴン" "$BMAGENTA" "共に、GUIの魔法使いの支配を終わらせよう！"
    say "LazyVimドラゴン" "$BMAGENTA" "しかしまず — 私の力を理解していることを証明せよ！"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}あなたのクエスト:${RESET}"
    echo -e "  ${WHITE}ドラゴンの巻物を開き、キーマップ対応表を完成させよ。"
    echo -e "  各キーバインドを正しい説明 (A〜E) に対応させよ。${RESET}"
    echo ""
    show_hint "答えはレッスンの巻物に書かれています — 注意深く読んでください！"
    show_hint "各 ??? を一文字 A、B、C、D、E のどれかで置き換えてください"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BMAGENTA}ドラゴンの巻物をNeovimで開いています...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    local pass=true
    local msgs=()

    local line1 line2 line3 line4 line5
    line1=$(grep "\[1\].*Space + e" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line2=$(grep "\[2\].*Space + Space" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line3=$(grep "\[3\].*Space + g + g" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line4=$(grep "\[4\].*g + d" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')
    line5=$(grep "\[5\].*Ctrl-/" "$TASK_FILE" 2>/dev/null | tail -1 | sed 's/.*→[[:space:]]*//' | tr -d ' \r\n')

    [[ "${line1^^}" == "A" ]] || { pass=false; msgs+=("[1] Space + e → A のはず (ファイルエクスプローラーを開く)"); }
    [[ "${line2^^}" == "B" ]] || { pass=false; msgs+=("[2] Space + Space → B のはず (ファジーファインダーでファイルを検索)"); }
    [[ "${line3^^}" == "E" ]] || { pass=false; msgs+=("[3] Space + g + g → E のはず (Lazygitを開く)"); }
    [[ "${line4^^}" == "D" ]] || { pass=false; msgs+=("[4] g + d → D のはず (定義に移動)"); }
    [[ "${line5^^}" == "C" ]] || { pass=false; msgs+=("[5] Ctrl-/ → C のはず (フローティングターミナルのトグル)"); }

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
    █         ⚔️   最終決戦！   ⚔️                      █
    ████████████████████████████████████████████████████

       GUIの魔法使いが現れた！

       .---.
      /  👁️ \       「愚か者め！GUIの力に
     | 🖱️💻🖱️|        勝てるはずがない！
      \  ^  /         クリック。ドラッグ。ドロップ。
       '---'          メニューが全てを支配する！」
        |||
       _|||_
ASCIIART
    echo -e "${RESET}"

    echo ""
    say "GUIの魔法使い" "$BRED" "キーストロークだけで私に挑むとは！"
    say "GUIの魔法使い" "$BRED" "私のマウス軍団があなたを圧倒するだろう！"
    echo ""
    sleep 1

    echo -e "${BMAGENTA}"
    cat << 'ASCIIART'
       🐉 LazyVimドラゴンが攻撃！ 🐉

            /\   グオォォォ！   /\
           /  \             /  \
          / 🔥  \___________/  🔥\
         /        レーザービーム！  \
        |   >>>>>>>>>>>>>>>>>>>    |
         \                       /
          \_____________________ /
ASCIIART
    echo -e "${RESET}"
    echo ""

    echo -e "  ${BCYAN}あなたは使う:  Space + Space  →  ファジーファイル検索！${RESET}"
    sleep 0.5
    echo -e "  ${BGREEN}  💥  ヒット！魔法使いがよろめく！${RESET}"
    sleep 1

    echo -e "  ${BCYAN}あなたは使う:  g + d          →  定義に移動！${RESET}"
    sleep 0.5
    echo -e "  ${BGREEN}  💥  クリティカルヒット！魔法使いの呪文が崩れる！${RESET}"
    sleep 1

    echo -e "  ${BCYAN}あなたは使う:  Ctrl-/         →  フローティングターミナル！${RESET}"
    sleep 0.5
    echo -e "  ${BGREEN}  💥  ターミナルが魔法使いを包み込む！${RESET}"
    sleep 1

    echo -e "  ${BCYAN}最終奥義:  :%s/GUI/NEOVIM/g  →  全体置換！${RESET}"
    sleep 0.5
    echo -e "  ${BYELLOW}  ★★★  KO！GUIの魔法使いが敗北した！  ★★★${RESET}"
    sleep 1

    echo ""
}

show_outro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "LazyVimの城塞" "勝利！"

    echo -e "${BYELLOW}"
    cat << 'ASCIIART'
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║   ★  ★  ★   勝 利 ！   ★  ★  ★                      ║
    ║                                                          ║
    ║   GUIの魔法使いが打ち倒された！                          ║
    ║   Neovimの世界は解放された！                             ║
    ║                                                          ║
    ║   ターミナルエディタが再び君臨する。                     ║
    ║   ヴィム村の住民たちが家を再建している。                 ║
    ║   幽霊の写本室は浄化された。                             ║
    ║   神託は霧の中で微笑んでいる。                           ║
    ║   Tmuxの塔が多重化された星の下で輝く。                   ║
    ║   LazyVimドラゴンが勝利の中で休む。                      ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "Neovimの世界が救われました。しかしそれよりも大切なことが..."
    narrate "あなたは本物のNeovim戦士となったのです。"
    echo ""
    say "長老ヴィムズワース" "$BWHITE" "古代の術を習得したな！本当に誇りに思う。"
    say "LazyVimドラゴン" "$BMAGENTA" "乗り手よ、いつでも私の背に乗ってくれ！"
    say "マルチプレックス" "$BCYAN" "Tmuxの塔の門は永遠にあなたに開かれている。"
    say "魔法使いアイシャ" "$BBLUE" "挿入モード、削除、検索...全てあなたの命令に従う。"
    say "神託" "$BYELLOW" "Vim戦士としてのあなたの運命は今ここに果たされた。"
    echo ""
    separator
    echo ""
    echo -e "  ${BYELLOW}🏆  最終スコア:${RESET}"
    echo -e "  ${YELLOW}  第1章 - 移動術:                    150 XP${RESET}"
    echo -e "  ${YELLOW}  第2章 - 挿入モード習得:            200 XP${RESET}"
    echo -e "  ${YELLOW}  第3章 - 削除術:                    250 XP${RESET}"
    echo -e "  ${YELLOW}  第4章 - 検索と置換:                300 XP${RESET}"
    echo -e "  ${YELLOW}  第5章 - tmux習得:                  350 XP${RESET}"
    echo -e "  ${YELLOW}  第6章 - LazyVimの城塞:             500 XP${RESET}"
    echo ""
    echo -e "  ${BYELLOW}  ★  合計: 1750 XP  —  称号: VIMの伝説  ★${RESET}"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}さらに学ぶには:${RESET}"
    echo -e "  ${WHITE}  • https://www.lazyvim.org でLazyVimの詳細を見る${RESET}"
    echo -e "  ${WHITE}  • Neovimで :Tutor を実行してさらに練習する${RESET}"
    echo -e "  ${WHITE}  • vimgolf.com でスピードチャレンジに挑戦する${RESET}"
    echo -e "  ${WHITE}  • https://neovim.io/doc/ で完全なドキュメントを読む${RESET}"
    echo ""
    show_reward "500" "LazyVim習得 + VIMの伝説 称号"
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
        echo -e "  ${BMAGENTA}ドラゴンがあなたの答えを確認しています...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "ドラゴンが承認の雄叫びをあげた！全キーマップが正しくマッピングされました！"
            sleep 1
            show_final_battle
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "キーマップが一部間違っています。ドラゴンが首を横に振っています..."
            echo ""
            if (( attempts == 1 )); then
                show_hint "回答の形式: [1] Space + e  → A   (1文字だけ)"
                show_hint "ワードバンクを注意深く読み、レッスンの「重要キーマップ」と照合してください"
            fi
            echo ""
            echo -e "  ${YELLOW}選択してください:${RESET}"
            echo -e "  ${WHITE}  r) もう一度挑戦${RESET}"
            echo -e "  ${WHITE}  s) 最終決戦にスキップ (ネタバレモード)${RESET}"
            echo ""
            printf "  選択: "
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
