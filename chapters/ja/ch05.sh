#!/usr/bin/env bash
# chapters/ja/ch05.sh — 第5章: Tmuxの塔 (tmux基礎)

source "$(dirname "$0")/../../lib/ui.sh"
source "$(dirname "$0")/../../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ja/ch05.txt"
TASK_FILE="/tmp/neovim_rpg_ch05.txt"
CHAPTER_NUM=5

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "Tmuxの塔" "クエスト: 多重化された領域を制御せよ"

    echo -e "${BCYAN}"
    cat << 'ASCIIART'
            ___________
           |  T M U X  |
           |    の 塔   |
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
         多重化された領域
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "神託の峰を降り、巨大な塔の麓に到着しました。"
    narrate "その壁は無数の端末画面で覆われており、"
    narrate "それぞれが同時に現実の異なる側面を映し出しています！"
    echo ""
    say "塔の守護者マルチプレックス" "$BCYAN" "止まれ！Tmuxの塔に近づくとは大胆だな？"
    say "塔の守護者マルチプレックス" "$BCYAN" "プレフィックスを使える者だけが入れる！"
    say "塔の守護者マルチプレックス" "$BCYAN" "プレフィックスは Ctrl-b だ — 押して離してからコマンドを入力する。"
    say "塔の守護者マルチプレックス" "$BCYAN" "4つの試練を突破すれば、塔はあなたのものだ！"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}このチャプターは少し違います！${RESET}"
    echo -e "  ${WHITE}まず、Neovimでレッスンの巻物を読んでください。${RESET}"
    echo -e "  ${WHITE}次に、ゲームがtmuxの4つの試練を導いてくれます。${RESET}"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}Neovimで塔のマニュアルを開いています...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

# ─────────────────────────────────────────
# tmux チャレンジ (インタラクティブ)
# ─────────────────────────────────────────

challenge_session() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   試練1: tmuxセッションを作成する         ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "マルチプレックス" "$BCYAN" "最初の試練: 名前付きtmuxセッションを作成せよ！"
    echo ""
    echo -e "  ${WHITE}新しいターミナルタブまたはウィンドウを開いて実行してください:${RESET}"
    echo ""
    echo -e "  ${BGREEN}  tmux new -s vim-tower${RESET}"
    echo ""
    echo -e "  ${WHITE}デタッチするには:  ${BGREEN}Ctrl-b  その後  d${RESET}"
    echo -e "  ${WHITE}を押して、ここに戻って確認してください。${RESET}"
    echo ""
    show_hint "既にtmux内にいる場合は: tmux new -s vim-tower -d を実行してください"
    echo ""
    press_enter_msg "セッションを作成してデタッチしたら ENTER を押してください"

    if tmux has-session -t vim-tower 2>/dev/null; then
        show_success "'vim-tower' セッションを検出しました！試練1クリア！"
        return 0
    else
        show_failure "'vim-tower' セッションが見つかりません。"
        echo ""
        show_hint "試してみてください: tmux new -s vim-tower -d"
        echo ""
        press_enter_msg "ENTER を押して再確認する"
        if tmux has-session -t vim-tower 2>/dev/null; then
            show_success "'vim-tower' セッションを検出しました！試練1クリア！"
            return 0
        else
            show_failure "まだ見つかりません。試練1をスキップします..."
            return 1
        fi
    fi
}

challenge_split() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   試練2: ペインに分割する                 ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "マルチプレックス" "$BCYAN" "第二の試練: 画面を分割せよ！"
    echo ""
    echo -e "  ${WHITE}tmuxセッション内でペインを分割してください:${RESET}"
    echo ""
    echo -e "  ${BGREEN}  Ctrl-b  その後  %    (縦分割 — 左右に並ぶ)${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  その後  \"    (横分割 — 上下に並ぶ)${RESET}"
    echo ""
    echo -e "  ${WHITE}ペイン間の移動:${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  その後  矢印キー${RESET}"
    echo ""
    echo -e "  ${DIM}両方の方法を試してみてください！Ctrl-b x でペインを閉じられます。${RESET}"
    echo ""
    press_enter_msg "ペインの分割を試したら ENTER を押してください"
    show_success "素晴らしい！ペイン分割をマスターしました！"
    return 0
}

challenge_window() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   試練3: ウィンドウを作成して名前を付ける ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "マルチプレックス" "$BCYAN" "第三の試練: 'vim-realm' という名前のウィンドウを作成せよ！"
    echo ""
    echo -e "  ${WHITE}tmuxセッション内で:${RESET}"
    echo ""
    echo -e "  ${BGREEN}  Ctrl-b  その後  c    (新しいウィンドウを作成)${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  その後  ,    (現在のウィンドウの名前を変更)${RESET}"
    echo -e "  ${BGREEN}  vim-realm と入力して Enter を押す${RESET}"
    echo ""
    echo -e "  ${WHITE}ウィンドウ間の切り替え:${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  その後  n    (次のウィンドウ)${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  その後  p    (前のウィンドウ)${RESET}"
    echo ""
    press_enter_msg "'vim-realm' ウィンドウを作成して名前を付けたら ENTER を押してください"

    if tmux list-windows -t vim-tower 2>/dev/null | grep -q "vim-realm"; then
        show_success "vim-towerセッションに 'vim-realm' ウィンドウが見つかりました！試練3クリア！"
        return 0
    else
        show_failure "vim-towerセッションに 'vim-realm' ウィンドウが見つかりません。"
        show_hint "vim-towerセッション内にいて、ウィンドウ名が正確に vim-realm であることを確認してください"
        press_enter_msg "ENTER を押して再確認する"
        if tmux list-windows -t vim-tower 2>/dev/null | grep -q "vim-realm"; then
            show_success "'vim-realm' ウィンドウが見つかりました！試練3クリア！"
            return 0
        else
            show_failure "試練3をスキップします..."
            return 1
        fi
    fi
}

challenge_detach() {
    clear_screen
    echo -e "${BCYAN}"
    cat << 'ASCII'
    ╔═══════════════════════════════════════════╗
    ║   試練4: デタッチと再アタッチ             ║
    ╚═══════════════════════════════════════════╝
ASCII
    echo -e "${RESET}"
    echo ""
    say "マルチプレックス" "$BCYAN" "最後の試練: セッションの永続性をマスターせよ！"
    echo ""
    echo -e "  ${WHITE}セッションからデタッチする:${RESET}"
    echo -e "  ${BGREEN}  Ctrl-b  その後  d${RESET}"
    echo ""
    echo -e "  ${WHITE}全セッションを一覧表示する:${RESET}"
    echo -e "  ${BGREEN}  tmux ls${RESET}"
    echo ""
    echo -e "  ${WHITE}再アタッチする:${RESET}"
    echo -e "  ${BGREEN}  tmux attach -t vim-tower${RESET}"
    echo ""
    echo -e "  ${DIM}これがtmuxの超能力: セッションはターミナルを閉じても生き残る！${RESET}"
    echo ""
    press_enter_msg "デタッチ/再アタッチを練習したら ENTER を押してください"
    show_success "セッション管理をマスターしました！塔があなたに頭を下げる！"
    return 0
}

show_outro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "Tmuxの塔" "クエスト完了！"

    echo -e "${BCYAN}"
    cat << 'ASCIIART'
    ╔═══════════════════════════════════════════════════════╗
    ║                                                       ║
    ║   ★  Tmuxの塔がひれ伏した！  ★                       ║
    ║                                                       ║
    ║   セッション: ✓   ペイン: ✓   ウィンドウ: ✓          ║
    ║   デタッチ: ✓                                         ║
    ║                                                       ║
    ║   これで複数の領域を同時に制御できるようになった！     ║
    ║   世界はターミナル多重化の意志に従う！                 ║
    ║                                                       ║
    ╚═══════════════════════════════════════════════════════╝
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "守護者マルチプレックスが敬意を表してひれ伏します。"
    echo ""
    say "マルチプレックス" "$BCYAN" "信じられない！多重化された領域をマスターしたな！"
    say "マルチプレックス" "$BCYAN" "最後の試練が一つだけ残っている: LazyVimの城塞だ。"
    say "マルチプレックス" "$BCYAN" "GUIの魔法使いが最後の敗北を待っている。行け、戦士よ！"
    echo ""
    show_reward "350" "tmux習得 (セッション, ペイン, ウィンドウ, デタッチ/アタッチ)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    run_lesson

    clear_screen
    echo -e "  ${BCYAN}塔の守護者が試練を待ち構えています...${RESET}"
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
