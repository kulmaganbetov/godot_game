extends CanvasLayer

class_name LevelHUD

# Timer + score overlay for a level, plus the end-of-level result panel.

const LEVEL_SCENE := "res://scenes/levels/TimeAttackLevel.tscn"
const LEVEL_SELECT_SCENE := "res://scenes/ui/LevelSelect.tscn"

@onready var _name_label: Label = $Top/NameLabel
@onready var _timer_label: Label = $Top/TimerLabel
@onready var _score_label: Label = $Top/ScoreLabel
@onready var _result: Control = $ResultCenter
@onready var _result_kills: Label = $ResultCenter/Panel/Margin/VBox/KillsLabel
@onready var _result_stars: Label = $ResultCenter/Panel/Margin/VBox/StarsLabel
@onready var _result_best: Label = $ResultCenter/Panel/Margin/VBox/BestLabel
@onready var _retry_button: Button = $ResultCenter/Panel/Margin/VBox/RetryButton
@onready var _menu_button: Button = $ResultCenter/Panel/Margin/VBox/MenuButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_result.visible = false
	_retry_button.pressed.connect(_on_retry)
	_menu_button.pressed.connect(_on_menu)


func set_level_name(text: String) -> void:
	_name_label.text = text


func set_time(seconds: float) -> void:
	_timer_label.text = "⏱ %d" % int(ceil(seconds))


func set_score(kills: int) -> void:
	_score_label.text = "Убито: %d" % kills


func show_result(kills: int, stars: int, best: int) -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_result_kills.text = "Убито: %d" % kills
	var stars_text := ""
	for i in 3:
		stars_text += "★" if i < stars else "☆"
	_result_stars.text = stars_text
	_result_best.text = "Рекорд: %d" % best
	_result.visible = true
	_result.modulate.a = 0.0
	create_tween().tween_property(_result, "modulate:a", 1.0, 0.25)


func _on_retry() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(LEVEL_SCENE)


func _on_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(LEVEL_SELECT_SCENE)
