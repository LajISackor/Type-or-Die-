# ⌨️ Type or Die — Typing Defense Game

> Words fall from the top. Type them before they hit the ground. Miss too many and it's game over!

Built with **Godot 4.6.2| GDScript

---

## 🎮 Game Overview

**Type or Die** is a fast-paced typing defense game where words rain down from the sky. Players must type each word correctly before it reaches the bottom of the screen. As the game progresses, words fall faster and get longer. Survive as long as you can!

### Core Features (MVP)
- Words spawn at the top and fall downward
- Player types words to destroy them before they land
- Score system (points per word destroyed)
- Health system (lose HP when words hit the ground)
- Game over screen with final score
- Main menu

### Stretch Goals
- Difficulty scaling (speed + word length increase over time)
- Accuracy statistics
- Word categories (animals, tech, food, etc.)
- Multiplayer race mode

---

## 👥 Team

| Name | Role | GitHub Username |
|------|------|-----------------|
<<<<<<< HEAD
| **Laji** | Team Lead / Core Systems | `@TODO` |
=======
| **Laji** | Team Lead / Core Systems | `LajISackor` |
>>>>>>> d84283e9e7abe703ff63e55448a0923ae1155d41
| **Joel** | Gameplay / UI | `@TODO` |
| **Mesa** | Assets / Polish | `@TODO` |

> **TODO:** Replace `@TODO` with actual GitHub usernames after team members join.

---

## 🛠️ Setup Instructions

### Prerequisites
1. Install [Godot 4.x](https://godotengine.org/download/) (standard version, not .NET)
2. Install [Git](https://git-scm.com/downloads)
3. Have a GitHub account

### Getting Started
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/type-or-die.git

# Open in Godot
# 1. Launch Godot
# 2. Click "Import"
# 3. Navigate to the cloned folder
# 4. Select project.godot
# 5. Click "Import & Edit"
```

### Git Workflow
We use a **branch-per-feature** workflow:
```bash
# Always pull latest changes before starting work
git pull origin main

# Create a branch for your task
git checkout -b feature/your-task-name

# Make your changes, then commit
git add .
git commit -m "Brief description of what you did"

# Push your branch
git push origin feature/your-task-name

# Then open a Pull Request on GitHub for review
```

**Branch naming convention:**
- `feature/word-spawner` — new features
- `fix/score-bug` — bug fixes
- `ui/main-menu` — UI work
- `asset/background-art` — asset additions

---

## 📁 Project Structure

```
type-or-die/
├── project.godot          # Godot project config
├── scenes/                # All .tscn scene files
│   ├── main_menu.tscn     # Title screen
│   ├── game.tscn          # Main gameplay scene
│   ├── game_over.tscn     # Game over screen
│   └── falling_word.tscn  # Individual word object
├── scripts/               # All .gd script files
│   ├── main_menu.gd
│   ├── game_manager.gd    # Core game loop & state
│   ├── word_spawner.gd    # Spawns words at intervals
│   ├── falling_word.gd    # Word movement & matching
│   ├── typing_input.gd    # Handles keyboard input
│   ├── score_manager.gd   # Score & health tracking
│   ├── hud.gd             # Heads-up display
│   └── game_over.gd
├── assets/
│   ├── fonts/             # .ttf or .otf font files
│   ├── sounds/            # SFX and music
│   └── sprites/           # Background, UI elements
└── word_lists/            # .txt files with words
    └── default.txt
```

---

## 📋 Task Assignments

See [TASKS.md](TASKS.md) for the full task breakdown and who's doing what.

See the **GitHub Issues** tab for trackable tasks — each issue is labeled and assigned.

---

## 📜 License

This project is for educational purposes.
