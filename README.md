# The World of Neovim 🗡️

> **An RPG adventure game to master Neovim, tmux, and LazyVim — terminal-style!**

```
  ████████╗██╗  ██╗███████╗    ██╗    ██╗ ██████╗ ██████╗ ██╗     ██████╗
     ██║   ███████║█████╗      ██║ █╗ ██║██║   ██║██████╔╝██║     ██║  ██║
     ██║   ██╔══██║██╔══╝      ██║███╗██║██║   ██║██╔══██╗██║     ██║  ██║
     ██║   ██║  ██║███████╗    ╚███╔███╔╝╚██████╔╝██║  ██║███████╗██████╔╝
     ╚═╝   ╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝
                 O F   N E O V I M
   "The keyboard is your sword.  The terminal is your realm."
```

## About

**The World of Neovim** is a `vimtutor`-style RPG game played entirely in your
terminal.  You learn real Neovim, tmux, and LazyVim commands by completing
quests in an epic fantasy adventure — with ASCII art bosses, story cutscenes,
and XP rewards!

The evil **GUI Sorcerer** threatens the World of Neovim.  Only a warrior who
masters the ancient arts of text editing can save it.  That warrior is **you**.

## Requirements

| Tool   | Version | Install |
|--------|---------|---------|
| **Neovim** | ≥ 0.9 | https://neovim.io |
| **tmux**   | ≥ 3.0 | https://github.com/tmux/tmux/wiki/Installing |
| **Bash**   | ≥ 4.0 | Included on Linux/macOS |

## Quick Start

```bash
git clone https://github.com/s-uei/the-world-of-neovim.git
cd the-world-of-neovim
bash game.sh
```

## The Adventure

| Chapter | Location | Topic |
|---------|----------|-------|
| **1** | 🏘 The Village of Vim | Movement — `hjkl`, `w`, `b`, `e`, `0`, `$`, `gg`, `G` |
| **2** | 🔮 The Cave of Cursors | Insert Mode — `i`, `a`, `o`, `I`, `A`, `O`, `Esc` |
| **3** | 👻 The Haunted Scriptorium | Deletion — `x`, `dd`, `dw`, `d$`, `diw`, `u` |
| **4** | 🔭 The Oracle's Peak | Search & Replace — `/pattern`, `:s`, `:%s`, `n`, `N` |
| **5** | 🗼 The Tmux Tower | tmux — sessions, panes, windows, detach/attach |
| **6** | 🏰 The LazyVim Citadel | LazyVim — keymaps, plugins, LSP, file finder |

## How It Works

1. The game displays a story scene with ASCII art and narrative.
2. A **lesson file** opens in Neovim (like `vimtutor`).
3. You read the lesson and complete an editing task.
4. Save and quit (`:wq`) to return to the game.
5. The game verifies your work and advances the story!

## File Structure

```
the-world-of-neovim/
├── game.sh          # Main launcher — start here!
├── lib/
│   ├── ui.sh        # Terminal display utilities (colors, ASCII art)
│   └── progress.sh  # Save/load game progress
├── chapters/
│   ├── ch01.sh      # Chapter 1: Movement
│   ├── ch02.sh      # Chapter 2: Insert Mode
│   ├── ch03.sh      # Chapter 3: Deletion
│   ├── ch04.sh      # Chapter 4: Search & Replace
│   ├── ch05.sh      # Chapter 5: tmux
│   └── ch06.sh      # Chapter 6: LazyVim
└── lessons/
    ├── ch01.txt     # Lesson scroll — opened in Neovim
    ├── ch02.txt
    ├── ch03.txt
    ├── ch04.txt
    ├── ch05.txt
    └── ch06.txt
```

## Tips

- **Stuck in Neovim?** Press `Esc` then type `:q!` and Enter to quit without saving.
- **Made a mistake?** Press `u` in Normal mode to undo.
- **Want to retry?** Chapters can be replayed from the Chapter Select menu.
- **Progress** is saved automatically to `~/.neovim_rpg_save`.

## License

MIT — see [LICENSE](LICENSE)

