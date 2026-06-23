extends Node3D

# Drives a timed level: counts down, tracks kills from the spawner, and shows
# the result screen when time runs out. Level parameters come from GameState
# based on which level the player picked in the level select.

@export var spawner_path: NodePath
@export var level_hud_path: NodePath
@export var hud_path: NodePath

var _spawner: LevelSpawner
var _level_hud: LevelHUD
var _time_left: float = 0.0
var _kills: int = 0
var _stars: Array = []
var _level: int = 1
var _running: bool = false


func _ready() -> void:
	_level = GameState.selected_level
	var cfg: Dictionary = GameState.get_config(_level)
	_time_left = cfg["time"]
	_stars = cfg["stars"]

	_spawner = get_node(spawner_path) as LevelSpawner
	_spawner.max_alive = cfg["max_alive"]
	_spawner.respawn_delay = cfg["interval"]
	_spawner.target_killed.connect(_on_kill)

	_level_hud = get_node(level_hud_path) as LevelHUD
	_level_hud.set_level_name(cfg["name"])
	_level_hud.set_score(0)
	_level_hud.set_time(_time_left)

	# Keep the gunplay HUD (crosshair/ammo) but hide its stats panel.
	var hud := get_node_or_null(hud_path)
	if hud and hud.has_method("set_stats_visible"):
		hud.set_stats_visible(false)

	# Wait a frame so the weapon is initialized, then wire it to the HUD
	# (hitmarkers + ammo) and start the round.
	await get_tree().process_frame
	var player := get_node_or_null("FeelPlayer") as FeelPlayer
	if player and player.weapon_rig and player.weapon_rig.active_weapon:
		if hud and hud.has_method("connect_weapon"):
			hud.connect_weapon(player.weapon_rig.active_weapon)
	_spawner.start()
	_running = true


func _process(delta: float) -> void:
	if not _running:
		return
	_time_left = max(_time_left - delta, 0.0)
	_level_hud.set_time(_time_left)
	if _time_left <= 0.0:
		_end_level()


func _on_kill() -> void:
	_kills += 1
	_level_hud.set_score(_kills)


func _end_level() -> void:
	_running = false
	_spawner.stop()
	var stars := 0
	for threshold in _stars:
		if _kills >= int(threshold):
			stars += 1
	GameState.set_best(_level, _kills)
	_level_hud.show_result(_kills, stars, GameState.get_best(_level))
