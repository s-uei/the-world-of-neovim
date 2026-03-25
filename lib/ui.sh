#!/usr/bin/env bash
# lib/ui.sh — Terminal UI utilities for The World of Neovim

# ─────────────────────────────────────────
# Colors
# ─────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Bright variants
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BMAGENTA='\033[1;35m'
BCYAN='\033[1;36m'
BWHITE='\033[1;37m'

# ─────────────────────────────────────────
# Screen helpers
# ─────────────────────────────────────────
clear_screen() {
    clear
    echo ""
}

press_enter() {
    echo ""
    echo -e "${DIM}  [ Press ENTER to continue ]${RESET}"
    read -r
}

press_enter_msg() {
    echo ""
    echo -e "${DIM}  [ $1 — Press ENTER ]${RESET}"
    read -r
}

# ─────────────────────────────────────────
# Typewriter effect
# ─────────────────────────────────────────
type_text() {
    local text="$1"
    local delay="${2:-0.03}"
    local i len
    len="${#text}"
    for (( i=0; i<len; i++ )); do
        printf '%s' "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Print a line of narrative with leading indent and color
narrate() {
    local line="$1"
    echo -e "  ${CYAN}${line}${RESET}"
    sleep 0.04
}

say() {
    # Character dialogue: say <name> <color> <text>
    local name="$1" color="$2" text="$3"
    echo -e "  ${color}${BOLD}${name}:${RESET} ${WHITE}${text}${RESET}"
    sleep 0.05
}

# ─────────────────────────────────────────
# Separator / Box drawing
# ─────────────────────────────────────────
separator() {
    echo -e "${DIM}  ════════════════════════════════════════════════════════${RESET}"
}

thin_sep() {
    echo -e "${DIM}  ────────────────────────────────────────────────────────${RESET}"
}

print_box() {
    # print_box <title> <color>
    local title="$1" color="${2:-$CYAN}"
    local width=58
    local pad=$(( (width - ${#title}) / 2 ))
    local line
    printf -v line '%*s' "$width" '' ; line="${line// /═}"
    echo -e ""
    echo -e "  ${color}╔${line}╗${RESET}"
    printf "  ${color}║%*s%s%*s║${RESET}\n" "$pad" "" "$title" "$(( width - pad - ${#title} ))" ""
    echo -e "  ${color}╚${line}╝${RESET}"
    echo ""
}

# ─────────────────────────────────────────
# Status bar (HP / XP)
# ─────────────────────────────────────────
show_status() {
    local chapter="$1" total="$2"
    local filled=$(( chapter * 8 / total ))
    local empty=$(( 8 - filled ))
    local bar=""
    local i
    for (( i=0; i<filled; i++ )); do bar+="█"; done
    for (( i=0; i<empty; i++ )); do bar+="░"; done
    echo -e "  ${YELLOW}Progress: [${bar}] Chapter ${chapter}/${total}${RESET}"
}

# ─────────────────────────────────────────
# Success / Failure messages
# ─────────────────────────────────────────
show_success() {
    echo ""
    echo -e "  ${BGREEN}✔  QUEST COMPLETE!${RESET}"
    echo -e "  ${GREEN}$1${RESET}"
    echo ""
}

show_failure() {
    echo ""
    echo -e "  ${BRED}✘  QUEST FAILED${RESET}"
    echo -e "  ${RED}$1${RESET}"
    echo ""
}

show_hint() {
    echo -e "  ${YELLOW}💡 Hint: $1${RESET}"
}

# ─────────────────────────────────────────
# Chapter title banner
# ─────────────────────────────────────────
chapter_banner() {
    local num="$1" title="$2" subtitle="$3"
    echo ""
    echo -e "${BMAGENTA}  ╔══════════════════════════════════════════════════════╗${RESET}"
    printf "${BMAGENTA}  ║  ${BYELLOW}%-52s${BMAGENTA}  ║${RESET}\n" "CHAPTER ${num}: ${title}"
    printf "${BMAGENTA}  ║  ${CYAN}%-52s${BMAGENTA}  ║${RESET}\n" "${subtitle}"
    echo -e "${BMAGENTA}  ╚══════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

# ─────────────────────────────────────────
# Reward display
# ─────────────────────────────────────────
show_reward() {
    local xp="$1" item="$2"
    echo ""
    echo -e "  ${BYELLOW}★  REWARD EARNED!${RESET}"
    echo -e "  ${YELLOW}  + ${xp} XP${RESET}"
    echo -e "  ${CYAN}  + New Skill: ${item}${RESET}"
    echo ""
}
