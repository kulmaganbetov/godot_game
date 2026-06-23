extends Control

# Level select: one button per level (name, time, best score). Picking a level
# stores it in GameState and loads the timed level scene.

const LEVEL_SCENE := "res://scenes/levels/TimeAttackLevel.tscn"
const MAIN_MENU_SCENE := "res://scenes/ui/MainMenu.tscn"

@onready var _list: VBoxContainer = $Center/VBox/LevelList
@onready var _back_button: Button = $Center/VBox/BackButton


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_back_button.pressed.connect(_on_back)
	_build_level_buttons()
	modulate.a = 0.0
	create_tween().tween_property(self, "modulate:a", 1.0, 0.4)


func _build_level_buttons() -> void:
	for level in range(1, GameState.level_count() + 1):
		var cfg: Dictionary = GameState.get_config(level)
		var button := Button.new()
		button.custom_minimum_size = Vector2(420, 64)
		button.add_theme_font_size_override("font_size", 24)
		button.text = "Уровень %d — %s   (%ds)   Рекорд: %d" % [
			level, cfg["name"], int(cfg["time"]), GameState.get_best(level)
		]
		button.pressed.connect(_on_level_selected.bind(level))
		button.mouse_entered.connect(_on_button_hover.bind(button))
		button.mouse_exited.connect(_on_button_unhover.bind(button))
		_list.add_child(button)


func _on_level_selected(level: int) -> void:
	GameState.selected_level = level
	get_tree().change_scene_to_file(LEVEL_SCENE)


func _on_back() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func _on_button_hover(button: Button) -> void:
	button.pivot_offset = button.size * 0.5
	create_tween().tween_property(button, "scale", Vector2(1.04, 1.04), 0.1)


func _on_button_unhover(button: Button) -> void:
	button.pivot_offset = button.size * 0.5
	create_tween().tween_property(button, "scale", Vector2.ONE, 0.1)
