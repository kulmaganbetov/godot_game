# Changelog

All notable changes to COBRA FPS Feel Kit will be documented in this file.

---

## Unreleased — Pause Menu, Target Respawn & Kill Counter

### Added

- **ESC pause menu** (`scenes/ui/PauseMenu.tscn`): pressing Escape pauses the
  game, frees the mouse and shows a styled panel with **Продолжить (Resume)**
  and **Выйти (Quit)** buttons (animated fade-in + button hover scale). Added
  to FeelShowcase, MagicShowcase, TestRange and WW2Bootcamp. Resolves not
  being able to exit the game.

- **Target respawn**: destroyed `TrainingTarget`s now reappear after a
  configurable delay (default **5s**, `respawn_delay` / `auto_respawn`) with a
  small pop-in, instead of being gone for good. `Damageable._handle_death()`
  is now overridable, so the base behavior (e.g. the Dummy) is unchanged.

- **Kill counter**: prominent `KILLS: N` HUD readout that pops on every kill
  and keeps counting across respawns (alongside the existing Targets/Streak/
  Accuracy stats).

---

## Unreleased — Visual Pass: Environment, Models & Glow

### Added

- **AK-style rifle viewmodel** (`RifleModel.tscn`) rebuilt from a flat 3-box
  shape into a recognizable silhouette: receiver, dust cover, wood handguard
  and stock, curved (banana) magazine, pistol grip, forward-facing barrel
  with front/rear sights.

- **New pistol model** (`PistolModel.tscn`): compact handgun silhouette
  (slide, frame, angled grip, trigger guard, muzzle). Displayed on a pedestal
  in the FPS showcase alongside the rifle.

- **Materials**: `Weapon_Wood_Default`, `Weapon_Mag_Default`,
  `Target_Skin_Default` for the new models and humanoid targets.

### Changed

- **Human-shaped targets**: `TrainingTarget` and `Dummy` rebuilt from stacked
  boxes into clear humanoid figures (legs, hips, torso, shoulders, arms,
  hands, neck, rounded head). Collision shapes and the hit-flash `FrontPanel`
  node are unchanged, so gameplay/scoring behave exactly as before.

- **More realistic environment** in FeelShowcase, MagicShowcase and TestRange:
  graded procedural sky, ACES tonemapping, **bloom/glow**, SSAO, light depth
  fog, and subtle contrast/saturation grading. MagicShowcase uses a moodier
  dusk palette with stronger glow.

- **Emissive VFX bloom**: muzzle flash, bullet impacts and the fireball now
  push past the HDR glow threshold so they actually light up the scene.

---

## Unreleased — Movement & HUD Feel Polish

### Changed

- **Smooth acceleration/deceleration** for player movement. Horizontal
  velocity now ramps up and slows down (ground and air rates) instead of
  snapping instantly, removing the "wooden" stop/start feel. Rates are
  per-profile tunable on `PlayerFeelConfig` (`ground_acceleration`,
  `ground_deceleration`, `air_acceleration`, `air_deceleration`) and tuned
  distinctly for Twitchy / WW2 / Arcade / Exploration.

- **Forgiving jumps** via coyote time and jump buffering
  (`coyote_time`, `jump_buffer_time` on `PlayerFeelConfig`), so jumps still
  register just after leaving a ledge or just before landing.

### Added

- **Landing camera impact**: hard drops produce a subtle camera shake
  (`land_shake_threshold` / `land_shake_scale` on `FeelPlayer`) via a new
  reusable `RecoilController.add_shake()` hook.

- **HUD juice (Tween-driven, no per-frame cost)**: hitmarker now punches and
  fades, kills pop the Targets/Best-Streak readouts, reloads pulse the ammo
  label (which also turns red when low), and the title/prompt text eases in.

---

## v0.4.0 — Initial Public Feel Kit

**Release Date:** 2025

Packaged COBRA as a standalone FPS feel kit for Godot 4.

### Added

- **FeelShowcase demo scene** (`scenes/demo/FeelShowcase.tscn`): Primary demo showcasing feel profiles (Twitchy / WW2 / Arcade), FeelPlayer, HUD, and training targets.

- **TestRange reference scene** (`scenes/TestRange.tscn`): Minimal shooting range for quick testing.

- **PlayerFeelConfig presets**:
  - `Feel_Twitchy.tres` — Fast, responsive arena-style feel.
  - `Feel_WW2.tres` — Heavy, deliberate WW2-style feel.
  - `Feel_Arcade.tres` — Balanced arcade-style feel.

- **WeaponConfig presets** (Rifle, SMG, Shotgun × Twitchy/WW2/Arcade):
  - Multiple weapon types with tuned damage, spread, recoil, and fire rates.
  - Each preset matched to corresponding feel profile.

- **CrosshairConfig presets** (`Crosshair_Twitchy.tres`, `Crosshair_WW2.tres`, `Crosshair_Arcade.tres`):
  - Dynamic crosshair styles tuned for each feel profile.

- **Integration documentation**:
  - `docs/integration-modes.md` — Complete guide for integrating COBRA into your project (Mode A: Drop-in FeelPlayer, Mode B: Use WeaponRig in your own character).
  - `docs/weapon-system-overview.md` — Detailed weapon system documentation.
  - `docs/weapon-feel-presets.md` — Feel preset tuning guide.

- **Enemies & Damageable integration**:
  - `Damageable` script for custom enemies and targets.
  - Signal pipeline documentation (WeaponBase → Damageable → HUD).

### Core Systems

- **FeelPlayer** (`scenes/FeelPlayer.tscn`): First-person controller with movement, camera, ADS, recoil, and head bob.

- **WeaponRig** (`scripts/player/weapon_rig.gd`): Viewmodel system with ADS state and weapon sway.

- **WeaponBase** (`scripts/weapons/weapon_base.gd`): Hitscan weapon system with spread, recoil patterns, ammo, and damage.

- **RecoilController** (`scripts/player/recoil_controller.gd`): Camera recoil and optional shake.

- **HUD** (`scenes/HUD.tscn`): Dynamic crosshair, hitmarkers, kill markers, ammo display, and range stats.

- **MeleeWeapon** (`scripts/weapons/melee_weapon.gd`): Melee system using same Damageable pipeline.

---



