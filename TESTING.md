# Testing Procedure

This document describes the manual testing procedure for Type or Die. Each test lists the actions to perform and the expected result.

## Prerequisites

1. Install Godot Engine 4.6.2 (standard version, not .NET)
2. Clone the repository: `git clone https://github.com/LajISackor/Type-or-Die-.git`
3. Open the project in Godot by importing the `project.godot` file
4. Press the Play button (▶) or F5 to run the game

---

## Test 1: Main Menu

**Actions:**
1. Launch the game

**Expected Results:**
- The main menu appears with the title "TYPE OR DIE" displayed with a typing animation
- A starfield background is visible with falling decorative words
- "Start Game" and "Quit" buttons are visible and styled
- Hovering over buttons shows a hover effect

---

## Test 2: Start Game

**Actions:**
1. From the main menu, click "Start Game"

**Expected Results:**
- The scene transitions to the gameplay screen
- The starfield background fills the entire screen with twinkling stars
- A red pulsing danger zone is visible at the bottom
- The HUD displays: health hearts (5), "Level 1", and "Score: 0"
- Words begin falling from the top of the screen within 2-3 seconds

---

## Test 3: Typing a Word Correctly

**Actions:**
1. Start a game
2. Wait for a word to appear (e.g., "star")
3. Type the word correctly on the keyboard

**Expected Results:**
- The word becomes highlighted (targeted) when the first letter matches
- Each correctly typed letter turns green on the falling word
- The next letter to type is highlighted in yellow
- The bottom of the screen shows what you are currently typing with a cursor
- When the word is fully typed, it disappears with a green particle explosion
- A floating score popup appears (e.g., "+40")
- The score in the HUD increases
- A small screen shake occurs

---

## Test 4: Missing a Word

**Actions:**
1. Start a game
2. Let a word fall all the way to the bottom without typing it

**Expected Results:**
- The word disappears when it reaches the danger zone
- A red particle burst appears at the bottom of the screen
- The screen shakes
- One health heart disappears from the HUD
- The health display flashes red

---

## Test 5: Mistyping

**Actions:**
1. Start a game
2. Wait for a word to appear
3. Start typing it correctly, then press a wrong letter

**Expected Results:**
- The targeting resets — the green highlighting on the word clears
- The typed text display at the bottom clears
- The player can start typing a new word immediately

---

## Test 6: Backspace

**Actions:**
1. Start a game
2. Begin typing a word (type 2-3 correct letters)
3. Press Backspace

**Expected Results:**
- The last typed character is removed
- The green highlighting on the word updates to show one fewer matched letter
- The typed text display at the bottom updates accordingly
- The word remains targeted

---

## Test 7: Auto-Targeting (Most Urgent Word)

**Actions:**
1. Start a game
2. Wait until multiple words are on screen at different heights
3. Type the first letter of a word that appears in two words (e.g., "s" when both "star" and "snow" are falling)

**Expected Results:**
- The game targets the word that is closest to the bottom (most urgent)
- That word shows the highlighting, not the one higher up

---

## Test 8: Combo System

**Actions:**
1. Start a game
2. Type 3 or more words correctly in a row without missing any

**Expected Results:**
- After the 3rd consecutive word, the score popup shows a combo multiplier (e.g., "+60 x3")
- The score awarded is multiplied by the combo bonus
- At 5+ combo, particle explosions change color to gold
- Missing a word resets the combo to 0

---

## Test 9: Difficulty Scaling

**Actions:**
1. Start a game
2. Play for at least 30 seconds (survive through 2 difficulty increases)

**Expected Results:**
- After ~15 seconds, the HUD updates to "Level 2"
- Gold particles shower across the screen on level up
- A small screen shake occurs
- Words fall noticeably faster
- Words spawn more frequently
- After another ~15 seconds, "Level 3" appears with the same effects
- Longer and harder words begin appearing at higher levels

---

## Test 10: Game Over

**Actions:**
1. Start a game
2. Let 5 words hit the bottom without typing them (lose all health)

**Expected Results:**
- All remaining words on screen explode with red particles
- A large screen shake occurs
- The game over screen appears after a brief delay showing:
  - Final score
  - Words typed
  - Words missed
  - Accuracy percentage
  - Level reached
  - Highest combo
- Score results animate by counting up from zero
- Stats are color-coded
- "Play Again" and "Main Menu" buttons are visible

---

## Test 11: Play Again

**Actions:**
1. Reach the game over screen
2. Click "Play Again"

**Expected Results:**
- The game resets completely
- Score returns to 0, health returns to 5 hearts, level returns to 1
- Words begin spawning again
- The combo counter resets

---

## Test 12: Return to Main Menu

**Actions:**
1. Reach the game over screen
2. Click "Main Menu"

**Expected Results:**
- The scene transitions back to the main menu
- The typing animation and falling decorative words are visible
- Clicking "Start Game" begins a fresh game

---

## Test 13: Pause

**Actions:**
1. Start a game
2. Press the Escape key

**Expected Results:**
- The game pauses — words stop falling, the timer stops
- A pause overlay appears with "PAUSED" text
- "Resume" and "Main Menu" buttons are visible
- Pressing Escape again or clicking "Resume" unpauses the game
- Words resume falling from where they were

---

## Test 14: Sound Effects

**Actions:**
1. Start a game
2. Type a word correctly
3. Let a word miss
4. Lose all health

**Expected Results:**
- A sound plays on each key press
- A sound plays when a word is completed
- A sound plays when a word is missed
- A sound plays on game over

---

## Test 15: Word Spawning — No Duplicates

**Actions:**
1. Start a game
2. Observe the falling words over 30+ seconds

**Expected Results:**
- No two identical words should be on screen at the same time
- Words spawn at varied X positions across the screen width
- Words do not stack directly on top of each other
