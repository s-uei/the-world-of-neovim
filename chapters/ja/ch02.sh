#!/usr/bin/env bash
# chapters/ja/ch02.sh — 第2章: カーソルの洞窟 (挿入モード)

source "$(dirname "$0")/../../lib/ui.sh"
source "$(dirname "$0")/../../lib/progress.sh"

GAME_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LESSON_SRC="${GAME_DIR}/lessons/ja/ch02.txt"
TASK_FILE="/tmp/neovim_rpg_ch02.txt"
CHAPTER_NUM=2

show_intro() {
    clear_screen
    chapter_banner "$CHAPTER_NUM" "カーソルの洞窟" "クエスト: 魔法のルーンを刻め"

    echo -e "${BBLUE}"
    cat << 'ASCIIART'
                  ___
                 /   \
    ____________/ 🔮  \____________
   |                              |
   |   カーソルの洞窟              |
   |   C U R S O R S              |
   |   ~  ~  ~  ~  ~             |
   |    古代の石の扉で             |
   |    封じられた暗い洞窟         |
   |______________________________|
         |             |
         |   入るか？  |
         |_____________|
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "暗い森を抜け、巨大な石の扉にたどり着きました。"
    narrate "5つのルーンの穴が表面に刻まれており、それぞれが空のままです。"
    narrate "古代の文字がかすかに輝いています:"
    echo ""
    say "石の扉" "$BBLUE" "闇の中で書ける者だけが通れる。"
    say "石の扉" "$BBLUE" "5つの神聖な言葉を刻め...さもなくばここに留まれ。"
    echo ""
    narrate "そのとき、隣の影から謎めいた人物が現れました。"
    echo ""
    say "魔法使いアイシャ" "$BMAGENTA" "ようこそ、若き戦士よ。私はアイシャ、挿入モードの達人だ。"
    say "魔法使いアイシャ" "$BMAGENTA" "Neovimの中で書く聖なる術を教えてあげよう。"
    say "魔法使いアイシャ" "$BMAGENTA" "i でカーソルの前に挿入、a でカーソルの後に挿入する。"
    say "魔法使いアイシャ" "$BMAGENTA" "o で下に新しい行を開く。終わったら必ず Esc を押すのだ！"
    echo ""
    separator
    echo ""
    echo -e "  ${BCYAN}あなたのクエスト:${RESET}"
    echo -e "  ${WHITE}巻物を開き、[ INSERT: 単語 ] と書かれた5つのルーンの穴を"
    echo -e "  正しい単語に置き換えよ。${RESET}"
    echo ""
    show_hint "カーソルを '[' に合わせ dt] (]まで削除) を使う方法や"
    show_hint "各括弧内の単語で ciW (内側の単語を変更) を使う方法があります"
    echo ""
    press_enter
}

run_lesson() {
    cp "$LESSON_SRC" "$TASK_FILE"
    clear_screen
    echo -e "  ${BGREEN}洞窟の巻物をNeovimで開いています...${RESET}"
    sleep 1
    nvim "+set number" "$TASK_FILE"
}

verify() {
    local pass=true
    local msgs=()

    grep -q "Knock three times and say: OPEN$" "$TASK_FILE" || \
    grep -q "Knock three times and say: OPEN " "$TASK_FILE" || \
        { pass=false; msgs+=("ルーンスロット1: 'say:' の後に 'OPEN' が見つかりません"); }

    grep -q "Speak against the darkness: LUMINOS" "$TASK_FILE" || \
        { pass=false; msgs+=("ルーンスロット2: 'LUMINOS' が正しく入力されていません"); }

    grep -q "Declare your title boldly: CURSOR" "$TASK_FILE" || \
        { pass=false; msgs+=("ルーンスロット3: 'CURSOR' が正しく入力されていません"); }

    grep -q "What keeps the cursor steady: NORMAL" "$TASK_FILE" || \
        { pass=false; msgs+=("ルーンスロット4: 'NORMAL' が正しく入力されていません"); }

    grep -q "The source of all power: NEOVIM" "$TASK_FILE" || \
        { pass=false; msgs+=("ルーンスロット5: 'NEOVIM' が正しく入力されていません"); }

    if grep -q "\[ INSERT:" "$TASK_FILE"; then
        pass=false
        msgs+=("[ INSERT: ... ] マーカーが残っています — 全ての括弧も削除してください！")
    fi

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
    chapter_banner "$CHAPTER_NUM" "カーソルの洞窟" "クエスト完了！"

    echo -e "${BBLUE}"
    cat << 'ASCIIART'
    ╔════════════════════════════════════════════╗
    ║                                            ║
    ║   OPEN! LUMINOS! CURSOR! NORMAL! NEOVIM!  ║
    ║                                            ║
    ║   石の扉がガタガタと動き... 開いた！       ║
    ║                                            ║
    ║       ゴゴゴ...  ガキッ...  ドーン！       ║
    ║                                            ║
    ║   奥には広大な薄暗い図書館が広がっている。 ║
    ║   幽霊の写本室が待ち受けている...          ║
    ║                                            ║
    ╚════════════════════════════════════════════╝
ASCIIART
    echo -e "${RESET}"

    echo ""
    narrate "石の扉が軋みながら開き、果てしなく広がる暗い棚の洞窟が現れました。"
    narrate "本が空中を漂い、ページが囁く幽霊のようにざわめきます。"
    echo ""
    say "魔法使いアイシャ" "$BMAGENTA" "挿入モードをマスターした！よくやったぞ、戦士よ。"
    say "魔法使いアイシャ" "$BMAGENTA" "しかし前方の写本室は黒魔法に汚染されている。"
    say "魔法使いアイシャ" "$BMAGENTA" "次は闇を削除する術を学ばなければならない..."
    echo ""
    show_reward "200" "挿入モード習得 (i, a, o, I, A, O, Esc)"
    show_status "$CHAPTER_NUM" 6
    press_enter
}

main() {
    show_intro
    local attempts=0
    while true; do
        run_lesson
        clear_screen
        echo -e "  ${BCYAN}ルーンスロットを確認しています...${RESET}"
        echo ""
        sleep 0.5

        if verify; then
            show_success "5つのルーンが全て正しく刻まれました！"
            sleep 1
            show_outro
            mark_complete "$CHAPTER_NUM"
            break
        else
            (( attempts++ ))
            show_failure "ルーンスロットが正しくありません。もう一度挑戦！"
            echo ""
            if (( attempts == 1 )); then
                show_hint "RUNE SLOTの行にある [ INSERT: 単語 ] のテキストを削除してください"
                show_hint "括弧内の単語 (OPEN、LUMINOSなど) だけで置き換えてください"
                show_hint "括弧内の単語が置き換えるべき単語です"
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
