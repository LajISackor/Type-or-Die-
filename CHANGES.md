# Changes Overview

This document summarizes all changes made to the Type or Die project, organized by development phase.

## Phase 1 — Project Setup

- Created the Godot 4.6.2 project structure with organized folders for scenes, scripts, assets, and word lists
- Set up the GitHub repository with a .gitignore tailored for Godot, issue templates, and a pull request template
- Created a default word list with 120 words sorted from easy (3-4 letters) to hard (7+ letters)
- Wrote the README with setup instructions, git workflow guide, and project structure documentation
- Created TASKS.md with a full task breakdown and assignments for all three team members

## Phase 2 — Core Systems (Laji)

- **game_manager.gd** — Built the main game loop managing three states: PLAYING, PAUSED, and GAME_OVER. Connects all subsystems together through Godot signals. Implements difficulty scaling that increases word fall speed and spawn rate every 15 seconds. Includes a combo system that tracks consecutive correct words and applies score multipliers (1.5x at 3 combo, 2x at 5, 3x at 10).

- **word_spawner.gd** — Loads words from a text file and sorts them into three difficulty pools based on word length. Spawns falling word scenes on a timer with configurable interval. Uses smart X-positioning that tests multiple random positions and picks the one most spread out from existing words. Words animate in with a scale and fade tween. Tracks active words to prevent duplicate spawns.

- **typing_input.gd** — Captures keyboard input through Godot's _unhandled_input system. Automatically targets the word closest to the bottom of the screen that matches the player's current input. Updates matched character count on the targeted word for visual feedback. Supports backspace to correct mistakes. Emits signals for correct and incorrect keystrokes that other systems can respond to.

- **background_fx.gd** — Animated background rendered as a CanvasLayer with an inner Control node that draws a gradient sky (dark blue to purple), 120 twinkling stars with randomized size, speed, brightness, and twinkle rate, and a pulsing red danger zone at the bottom of the screen.

- **vfx_manager.gd** — Manages a Camera2D for screen shake with configurable intensity and decay. Spawns particle explosions with physics (gravity, drag) when words are destroyed or missed. Renders floating score popup text that rises and fades. Triggers gold particle showers on level-up events. All particles are drawn manually using Godot's _draw() system.

## Phase 3 — UI & Polish (Joel)

- **falling_word.gd** — Added pop-in scale animation using tweens when words spawn. Implemented yellow highlighting for the next letter the player needs to type. Words now visually differentiate between three states: idle (gray), targeted (white), and matched (green for typed letters).

- **hud.gd** — Added pulse animations on the score and level labels that trigger on every value change. Health display flashes red when the player takes damage. Styled the typing input display at the bottom of the screen with a cursor indicator.

- **main_menu.gd** — Built a complete title screen with a character-by-character typing animation for the game title. Added styled buttons with hover effects. Included a starfield background and decorative falling words that drift down behind the menu for visual atmosphere.

## Phase 4 — Assets & Scoring (Sarah)

- **Sound effects** — Added audio feedback for four game events: key presses, word completions, missed words, and game over. Integrated AudioStreamPlayer nodes that trigger on the appropriate signals.

- **Combo tracker** — Enhanced the scoring system to track and display the highest combo achieved during each game session. The value persists through the game and displays on the game over screen.

- **Game over screen** — Built a standalone game over scene with animated score results that count up from zero. Stats are color-coded by category. Displays final score, accuracy percentage, words typed, words missed, level reached, and highest combo. Includes styled Play Again and Main Menu buttons matching Joel's button style from the main menu.

## Bug Fixes

- Fixed viewport function errors by replacing get_viewport_rect() with get_viewport().get_visible_rect() for compatibility with all node types
- Fixed background only rendering in 25% of the screen by converting from Node2D to CanvasLayer for camera-independent rendering
- Fixed words only spawning in the bottom-right corner by centering the Camera2D at position (400, 300) instead of the default (0, 0)
- Fixed type mismatch error by removing the Node2D type hint on the background variable in game_manager.gd
- Resolved multiple Git merge conflicts between skeleton scripts and completed versions

## Changes Considered But Not Implemented

- **Multiplayer race mode** — We discussed a split-screen mode where two players compete to clear words fastest, but decided it was too complex for the project timeline
- **Word categories** — We planned to let players choose themed word lists (animals, tech, food) but prioritized core gameplay polish instead
- **High score persistence** — Saving scores to disk between sessions was considered but not implemented since the game resets on close
- **Power-ups** — Items like slow-time or clear-all-words were discussed early on but cut to focus on the core typing experience
