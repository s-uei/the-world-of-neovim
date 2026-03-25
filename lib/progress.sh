#!/usr/bin/env bash
# lib/progress.sh — Save/load game progress for The World of Neovim

PROGRESS_FILE="${HOME}/.neovim_rpg_save"
TOTAL_CHAPTERS=6

# ─────────────────────────────────────────
# Save progress
# ─────────────────────────────────────────
save_progress() {
    local chapter="$1"   # highest chapter unlocked
    local completed="$2" # space-separated list of completed chapter numbers
    cat > "$PROGRESS_FILE" <<EOF
CHAPTER=${chapter}
COMPLETED="${completed}"
EOF
}

# ─────────────────────────────────────────
# Load progress  (sets globals SAVE_CHAPTER, SAVE_COMPLETED)
# ─────────────────────────────────────────
load_progress() {
    SAVE_CHAPTER=1
    SAVE_COMPLETED=""
    if [[ -f "$PROGRESS_FILE" ]]; then
        # shellcheck disable=SC1090
        source "$PROGRESS_FILE"
        SAVE_CHAPTER="${CHAPTER:-1}"
        SAVE_COMPLETED="${COMPLETED:-}"
    fi
}

# ─────────────────────────────────────────
# Mark a chapter as complete
# ─────────────────────────────────────────
mark_complete() {
    local ch="$1"
    load_progress
    # add to completed list if not already there
    if [[ ! " $SAVE_COMPLETED " =~ " $ch " ]]; then
        SAVE_COMPLETED="$SAVE_COMPLETED $ch"
    fi
    # unlock next chapter (cap at TOTAL_CHAPTERS so chapter 7 is never saved)
    local next=$(( ch + 1 ))
    if (( next > SAVE_CHAPTER && next <= TOTAL_CHAPTERS )); then
        SAVE_CHAPTER=$next
    fi
    save_progress "$SAVE_CHAPTER" "$SAVE_COMPLETED"
}

# ─────────────────────────────────────────
# Check if a chapter is complete
# ─────────────────────────────────────────
is_complete() {
    local ch="$1"
    load_progress
    [[ " $SAVE_COMPLETED " =~ " $ch " ]]
}

# ─────────────────────────────────────────
# Reset all progress
# ─────────────────────────────────────────
reset_progress() {
    rm -f "$PROGRESS_FILE"
}
