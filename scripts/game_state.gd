extends Node

# Persistent game state (autoload singleton). Survives scene changes so the
# level select, the level itself and the result screen all agree on which
# level is being played and what the best score is.

const LEVELS := {
	1: {"name": "Разминка", "time": 60.0, "interval": 1.2, "max_alive": 4, "stars": [10, 20, 30]},
	2: {"name": "Тир", "time": 45.0, "interval": 0.9, "max_alive": 6, "stars": [15, 30, 45]},
	3: {"name": "Хаос", "time": 30.0, "interval": 0.55, "max_alive": 8, "stars": [20, 40, 60]},
}

var selected_level: int = 1
var _best_kills: Dictionary = {}


func get_config(level: int) -> Dictionary:
	return LEVELS.get(level, LEVELS[1])


func level_count() -> int:
	return LEVELS.size()


func set_best(level: int, kills: int) -> void:
	if kills > get_best(level):
		_best_kills[level] = kills


func get_best(level: int) -> int:
	return int(_best_kills.get(level, 0))
