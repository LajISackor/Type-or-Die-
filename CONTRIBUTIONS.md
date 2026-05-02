# Contributions — Who Worked on What

## Laji Sackor — Team Lead / Core Systems & Visual Effects

Laji set up the project infrastructure including the GitHub repository, Godot project structure, task breakdown, and documentation. He then built all five core systems that make the game run.

**Scripts authored:**
- `game_manager.gd` — Main game loop, state management, difficulty scaling, combo system, signal routing between all subsystems
- `word_spawner.gd` — Word loading, difficulty pool sorting, timed spawning, smart positioning, spawn animations
- `typing_input.gd` — Keyboard input capture, word matching, auto-targeting, backspace support, keystroke signals
- `background_fx.gd` — Animated starfield background, gradient sky, twinkling stars, pulsing danger zone
- `vfx_manager.gd` — Particle explosions, screen shake, floating score popups, level-up effects, camera management

**Other contributions:**
- Created the initial project structure and all scene files (game.tscn, main_menu.tscn, falling_word.tscn)
- Wrote the README, TASKS.md, and word list (default.txt with 120 words)
- Set up GitHub with .gitignore, issue templates, and PR templates
- Reviewed and merged all pull requests from Joel and Sarah
- Debugged and fixed viewport errors, camera positioning, background rendering, and Git conflicts

## Joel Mesa — Gameplay & UI Polish

Joel took the working base versions of three gameplay and UI scripts and polished them with animations, visual effects, and styling to make the game feel professional.

**Scripts modified:**
- `falling_word.gd` — Added pop-in scale animation on spawn, yellow next-letter highlighting, visual state differentiation (idle/targeted/matched)
- `hud.gd` — Added score and level pulse animations, health flash red effect on damage, styled typing display with cursor
- `main_menu.gd` — Built typing animation for title text, styled buttons with hover effects, starfield background, decorative falling words

**Pull requests:**
- PR #1: Polish falling word — pop-in animation, yellow next letter highlight (merged)
- PR #2: Polish HUD — score/level pulse animation, health flash red, styled typing display (merged)
- PR #3: Polish main menu — typing animation, styled buttons, starfield, falling words (merged)

## Sarah Jorgensen — Assets & Polish

Sarah added audio feedback, enhanced the scoring system, and built the game over screen to complete the player experience.

**Scripts authored/modified:**
- Added sound effects for key presses, word completions, missed words, and game over using AudioStreamPlayer nodes
- `score_manager.gd` — Enhanced to track highest combo achieved during each game session
- `game_over.gd` + `game_over.tscn` — Built standalone game over scene with animated score results that count up from zero, color-coded stats, and styled buttons

**Pull requests:**
- PR #4: Added sound effects (merged)
- PR #5: Add highest combo tracker (merged)
- PR #6: UI game over screen with animated score results, color-coded stats, styled buttons (merged)
