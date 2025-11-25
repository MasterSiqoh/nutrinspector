# NutriInspector - Game Setup Instructions

## Setup Steps

### 1. Add SaveSystem as Autoload
1. Go to **Project → Project Settings → Autoload**
2. Click the folder icon and select `script/SaveSystem.gd`
3. Name it `SaveSystem`
4. Click **Add**

### 2. Set Main Menu as Starting Scene
1. Go to **Project → Project Settings → Application → Run**
2. Set Main Scene to `res://scene/MainMenu.tscn`

## New Features Added

### Main Menu
- **New Game**: Start fresh game with save slot selection
- **Load Game**: Load from one of 3 save slots
- **Continue**: Automatically load most recent save
- **Exit**: Quit game

### Save System
- 3 save slots available
- Saves: Day, Money, Inspections, Upgrades
- Auto-save before each new day

### Pause Menu (Press ESC)
- Resume game
- Save current progress
- Return to main menu
- Exit game

### Game Mechanics
- **Money**: Start with $100
- **Days**: Start from Day 1
- **Inspections**: 3 per day
- **Correct Prediction**: +$20
- **Wrong Prediction**: $0
- **Daily Expense**: -$20 (at end of day)
- **Game Over**: If money < $20

### Upgrade Shop
- **Faster Inspection**: $50
  - Makes loading bar 2x faster (1.5 seconds instead of 3)
  - Permanent upgrade
  - Accessible after each day

### Day Flow
1. Start day with 3 inspections
2. Make predictions (Approve/Disapprove)
3. After 3 inspections → Day Summary
4. Pay $20 daily expense
5. If enough money → Upgrade Shop
6. Start next day

## Game Controls
- **ESC**: Open pause menu
- **Mouse**: Click buttons to interact

## File Structure
```
scene/
  - MainMenu.tscn (Main menu screen)
  - Main.tscn (Game scene)
  - FoodInfo.tscn (Food inspection details)
  - DaySummary.tscn (End of day summary)
  - UpgradeShop.tscn (Upgrade purchase screen)
  - PauseMenu.tscn (Pause overlay)

script/
  - SaveSystem.gd (Save/Load system)
  - MainMenu.gd (Main menu logic)
  - Main.gd (Game scene UI updates)
  - PauseMenu.gd (Pause menu logic)
  - DaySummary.gd (Day summary logic)
  - UpgradeShop.gd (Shop logic)
  - StartButton.gd (Start inspection)
  - LoyangButton.gd (Check food info)
  - ApproveButton.gd (Approve food)
  - DisapproveButton.gd (Disapprove food)
  - FoodInfo.gd (Display food info)
```

## Save Files Location
- Windows: `%APPDATA%\Godot\app_userdata\[ProjectName]\saves\`
- Saves stored as: `save_0.json`, `save_1.json`, `save_2.json`
