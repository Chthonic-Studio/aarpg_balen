# Legacy of Isvagar

"Your teachings are their shield, your wisdom is their sword."

Forge a Legacy. Shape a Generation.

Legacy of Isvagar is a 2D semi-open world Action RPG with a 32-bit pixel art style. Players take on the role of a new professor at a magical military academy in a medieval fantasy world. The core experience revolves around balancing duties as a mentor—lecturing, tutoring students, and shaping the next generation of heroes—with personal progression, thrilling exploration, and fast-paced AARPG combat.

## Project Details

*   **Platform**: PC (Initial Commercial Release)
*   **Engine**: Godot 4.4
*   **Genre**: AARPG, Professor Sim, Narrative RPG, Semi-Open World
*   **Target Release**: Q3 2026

---

## Gameplay Pillars

These are the core tenets that guide all development decisions for the game.

*   **The Influential Mentor**: The player's primary role is that of a professor. Gameplay systems will empower the player to feel that their teaching, guidance, and personal attention have a tangible and rewarding impact on their students' skills and futures.

*   **A World Shaped by Choice**: The narrative is reactive, especially concerning the "named" students who are key historical figures. Player choices in tutoring and quests will have a visible impact on the story and the world state across the game's three acts.

*   **Deep Arcane Combat**: Combat is fast, responsive, and action-oriented, inspired by classics like Diablo. Players will master a wide variety of magic schools, allowing for diverse and visually spectacular playstyles.

*   **Rewarding Exploration**: The semi-open world, inspired by the feel of Dragon Age: Inquisition, invites players to explore forests, mountains, and isles. Exploration is a key secondary focus, yielding resources, new quests, and deep lore about the world of Balen.

---

## Narrative Overview

The game is set in the Academy of Isvagar within the Kingdom of Vaelris. This magical military academy trains the nation's arcanists and soldiers. The player, a commoner sponsored by a noble house, is appointed as a new professor.

*   **Act 1**: The player arrives at the academy, facing discrimination due to their lowborn status. They establish themselves as a capable professor, build relationships (including potential romance), and earn a full-time position.

*   **Act 2**: The player rises through the ranks, with the opportunity to become a Head Professor or even Headmaster. They continue to mentor a new generation of students, with their choices having larger consequences. Romances can deepen, potentially leading to children.

*   **Act 3**: The player is an established and influential figure. They must use their power, knowledge, and the skills of their former students to save the academy from a great threat. If the player had children, they will now be students at the academy.

---

## Visuals

*   **Art Style**: A 32-bit 2D top-down pixel art style, aiming for detailed environments and expressive character sprites.
*   **World Feel**: While pixelated, the world's tone and feel are inspired by the serious, high-fantasy settings of games like Dragon Age and Mass Effect.
*   **UI/UX**: Clean, readable interface that is easy to navigate but fits the fantasy aesthetic.

---

## Target Audience

*   **Age**: 20s to 40s
*   **Player Profile**: Enthusiasts of deep, narrative-driven RPGs (Fire Emblem: Three Houses, Dragon Age, Mass Effect) who also enjoy the gameplay loop and character-building of Action RPGs.
*   **Values**: They appreciate rich lore, meaningful character development, and complex gameplay systems. They are not afraid of a challenge and enjoy seeing their choices have long-term consequences.
*   **How to Find Them**: Communities on Reddit (r/rpg_gamers, r/patientgamers), Discord servers dedicated to narrative RPGs and AARPGs, and fans of the inspirational titles mentioned.

---

## Highlighted Inspirations

*   **Fire Emblem: Three Houses**: A direct inspiration for the lecturing, tutoring, and social-simulation aspects of the professor system.
*   **Dragon Age: Inquisition / Mass Effect**: Inspirations for the world feel, branching narrative choices, and the sense of a large, explorable world with a core cast of important characters.
*   **Diablo / Path of Exile**: Benchmarks for the fast-paced, ability-driven AARPG combat system.

---
## Scripts and Systems Overview

This section details the core scripts and architectural patterns used in the project.

### Global Managers (Autoloads)

These scripts manage the game's state and core systems, accessible globally.

*   **`scripts/globals/global_player_manager.gd`**:
    *   **Description**: Manages the player character's existence across all scenes. It ensures the player persists during level transitions and holds a central reference to the player node.
    *   **Key Functions**:
        *   `add_player_instance()`: Instantiates and adds the player scene to the `PlayerManager`.
        *   `set_player_position()`: Sets the player's global position, used after loading or transitioning scenes.

*   **`scripts/globals/global_level_manager.gd`**:
    *   **Description**: Handles scene transitions, including fade effects and positioning the player correctly in the new level. It also manages the boundaries of the current level's tilemap.
    *   **Key Functions**:
        *   `load_new_level()`: Manages the entire process of switching from one level scene to another.
        *   `ChangeTilemapBounds()`: Receives and stores the tilemap boundaries, emitting a signal for other nodes (like the camera) to update.

*   **`scripts/globals/global_save_manager.gd`**:
    *   **Description**: Manages all save and load operations. It collects data from other managers (like PlayerManager) and serializes it to a file.
    *   **Key Functions**:
        *   `save_game()`: Gathers current game state and writes it to a save file.
        *   `load_game()`: Reads a save file and applies the saved state to the game.

### Player Systems

These scripts define the player character's behavior and state management.

*   **`player/scripts/player.gd`**:
    *   **Description**: The central script for the player `CharacterBody2D`. It handles movement input, health, invulnerability, and emits signals related to player state changes. It delegates state-specific logic to the `PlayerStateMachine`.
    *   **Key Functions**:
        *   `_process()`: Gathers player input for movement.
        *   `_take_damage()`: Called when the player's `HitBox` is damaged. Reduces HP and triggers the hit state.
        *   `update_hp()`: Safely modifies the player's HP and updates the HUD.
        *   `SetDirection()`: Calculates the player's cardinal direction based on input and emits `DirectionChanged` if it changes.

*   **`player/scripts/state_machine/player_state_machine.gd`**:
    *   **Description**: A generic state machine that manages the player's current state (e.g., Idle, Walk, Attack). It routes engine callbacks (`_process`, `_physics_process`, `_unhandled_input`) to the active state.
    *   **Key Functions**:
        *   `Initialize()`: Finds all child `State` nodes and sets up the initial state.
        *   `ChangeState()`: Transitions from the current state to a new one, calling `Exit()` on the old state and `Enter()` on the new one.

*   **`player/scripts/state_machine/state.gd`**:
    *   **Description**: The base class for all player states. It defines the functions that every state must implement (`Enter`, `Exit`, `Process`, etc.).
    *   **Key Functions**: `Enter()`, `Exit()`, `Process()`, `Physics()`, `HandleInput()`.

### Enemy Systems

These scripts define enemy behavior using a state machine architecture similar to the player's.

*   **`enemies/enemy.gd`**:
    *   **Description**: The base script for all enemy `CharacterBody2D`s. It handles health, movement, and animations, delegating complex AI logic to its `EnemyStateMachine`.
    *   **Key Functions**:
        *   `_take_damage()`: Reduces HP when its `HitBox` is damaged and emits signals for being damaged or destroyed.
        *   `SetDirection()`: Sets the enemy's facing direction.
        *   `UpdateAnimation()`: Plays an animation based on the current state and direction.

*   **`enemies/enemy_state_machine.gd`**:
    *   **Description**: Manages the enemy's current AI state (e.g., Idle, Wander, Hit).
    *   **Key Functions**:
        *   `Initialize()`: Gathers all `EnemyState` children and sets the initial state.
        *   `ChangeState()`: Transitions the enemy to a new state.

*   **`enemies/states/enemy_state.gd`**:
    *   **Description**: The base class for all enemy states, defining the core AI logic interface.
    *   **Key Functions**: `enter()`, `exit()`, `process()`, `physics()`.

### Core Gameplay Mechanics

These are general-purpose scripts that form the foundation of key gameplay systems.

*   **`general/hitbox/hit_box.gd` & `general/hurtbox/hurt_box.gd`**:
    *   **Description**: A decoupled system for damage detection. `HurtBox`es represent areas that can deal damage (like a sword swing), and `HitBox`es represent areas that can receive damage (a character's body). When a `HurtBox` enters a `HitBox`, the `HitBox` emits a `Damaged` signal with a reference to the `HurtBox`.
    *   **Key Signals**: `HitBox.Damaged(hurt_box)`

*   **`scenes/levels/level_transition.gd`**:
    *   **Description**: An `Area2D` that triggers a level change when the player enters it. It communicates with the `LevelManager` to load the target scene and position the player correctly.
    *   **Key Functions**:
        *   `_player_entered()`: The function connected to the `body_entered` signal, which initiates the level transition.

*   **`items/scripts/item_data.gd`**:
    *   **Description**: A custom `Resource` for defining item properties like name, description, and texture. This allows for creating and managing items as data assets in the editor.

### UI Systems

Scripts related to the game's User Interface.

*   **`GUI/pause_menu/pause_menu.gd`**:
    *   **Description**: Manages the pause menu's visibility and functionality. It pauses/unpauses the game and connects UI buttons to the appropriate managers (e.g., `SaveManager`).
    *   **Key Functions**:
        *   `show_pause_menu()` / `hide_pause_menu()`: Toggles the menu's visibility and the game's paused state.

*   **`GUI/pause_menu/inventory/scripts/inventory_data.gd`**:
    *   **Description**: A custom `Resource` that holds an array of `SlotData`, representing the entire inventory.
*   **`GUI/pause_menu/inventory/scripts/slot_data.gd`**:
    *   **Description**: A custom `Resource` that represents a single inventory slot, containing an `ItemData` resource and a quantity.
*   **`GUI/pause_menu/inventory/scripts/inventory_ui.gd`**:
    *   **Description**: The control script for the main inventory panel. It dynamically creates `InventorySlotUI` instances based on the `InventoryData` resource.
    *   **Key Functions**:
        *   `update_inventory()`: Clears and repopulates the inventory display with the latest data.
