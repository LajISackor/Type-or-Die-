# 📋 Task Assignments — Type or Die

## How to Use This File
- Find your name below to see your assigned tasks
- Each task maps to a **GitHub Issue** (create these after repo setup)
- Mark tasks ✅ when your Pull Request is merged
- If you're blocked, post in the group chat or tag the team lead

---

## 🔴 Phase 1 — Core MVP (Week 1)

### Laji (Team Lead / Core Systems)
- [ ] **Task 1: Game Manager** — `game_manager.gd` + `game.tscn`
  - Create the main game scene
  - Manage game states: PLAYING, PAUSED, GAME_OVER
  - Connect word spawner, input handler, and score manager together
  - Handle pause (Escape key) and restart logic
  - *Branch:* `feature/game-manager`

- [ ] **Task 2: Word Spawner** — `word_spawner.gd`
  - Load words from `word_lists/default.txt`
  - Spawn `falling_word` scenes at random X positions along the top
  - Use a Timer node to control spawn rate
  - Start with one word every 2–3 seconds
  - *Branch:* `feature/word-spawner`

- [ ] **Task 3: Typing Input System** — `typing_input.gd`
  - Capture keyboard input character by character
  - Match typed text against active falling words
  - Highlight the word currently being targeted
  - Clear input when a word is completed or mismatched
  - *Branch:* `feature/typing-input`

### Joel (Gameplay / UI)
- [ ] **Task 4: Falling Word Scene** — `falling_word.gd` + `falling_word.tscn`
  - Create a Label node that moves downward each frame
  - Configurable fall speed and word text
  - Emit signal when word reaches the bottom (missed)
  - Emit signal when word is typed correctly (destroyed)
  - Visual feedback: highlight matched letters in a different color
  - *Branch:* `feature/falling-word`

- [ ] **Task 5: HUD (Heads-Up Display)** — `hud.gd`
  - Display current score at top-right
  - Display health bar or hearts at top-left
  - Show the current text being typed at the bottom of the screen
  - Update in real time as the player types
  - *Branch:* `ui/hud`

- [ ] **Task 6: Main Menu** — `main_menu.gd` + `main_menu.tscn`
  - Game title "TYPE OR DIE"
  - "Start Game" button → transitions to game scene
  - "Quit" button → exits the application
  - Clean, readable layout
  - *Branch:* `ui/main-menu`

### Mesa (Assets / Polish)
- [ ] **Task 7: Game Over Screen** — `game_over.gd` + `game_over.tscn`
  - Show "GAME OVER" text
  - Display final score
  - "Play Again" button → restarts game scene
  - "Main Menu" button → returns to main menu
  - *Branch:* `ui/game-over`

- [ ] **Task 8: Score & Health Manager** — `score_manager.gd`
  - Track score (e.g., +10 per word, bonus for long words)
  - Track health (start at 5 HP, lose 1 per missed word)
  - Emit signal when health reaches 0 → trigger game over
  - *Branch:* `feature/score-manager`

- [ ] **Task 9: Word List + Assets**
  - Create `word_lists/default.txt` with 100+ words (easy to hard)
  - Find or create a clean monospace font for the falling words
  - Add basic sound effects: key press, word complete, word missed, game over
  - *Branch:* `asset/words-and-sounds`

---

## 🟡 Phase 2 — Polish & Extensions (Week 2+)

### All Team Members
- [ ] **Difficulty Scaling** — Words fall faster and spawn more frequently over time
- [ ] **Accuracy Stats** — Track correct vs. incorrect keystrokes, show at game over
- [ ] **Word Categories** — Let players pick themes (animals, code keywords, food, etc.)
- [ ] **Visual Effects** — Particles when a word is destroyed, screen shake on miss
- [ ] **Background Music** — Looping track that intensifies with difficulty
- [ ] **High Score System** — Save/load best scores locally

### Bonus (If Time Allows)
- [ ] **Multiplayer Race Mode** — Split screen, first to clear X words wins
- [ ] **Power-ups** — Slow time, clear all words, bonus points

---

## 🔗 GitHub Issues Template

When creating issues on GitHub, use this format:

**Title:** `[TASK #] Brief description`
**Labels:** `feature`, `ui`, `asset`, `bug`, `enhancement`
**Assignee:** Team member's GitHub username

Example:
> **Title:** [Task 4] Falling Word Scene
> **Labels:** `feature`
> **Assignee:** Joel
> **Description:** Create the falling_word.tscn scene and falling_word.gd script. The word should fall from the top of the screen and emit signals when destroyed or missed. See TASKS.md for details.
