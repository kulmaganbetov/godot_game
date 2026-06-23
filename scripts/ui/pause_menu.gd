extends CanvasLayer

class_name PauseMenu

# Simple ESC pause menu: dim the screen, free the mouse, and offer
# Resume / Quit. Works while the SceneTree is paused via PROCESS_MODE_ALWAYS.

@onready var _panel: Control = $Center/Panel
@onready var _resume_button: Button = $Center/Panel/Margin/VBox/ResumeButton
@onready var _quit_button: Button = $Center/Panel/Margin/VBox/QuitButton

var _is_paused: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_resume_button.pressed.connect(resume_game)
	_quit_button.pressed.connect(_on_quit_pressed)
	for button in [_resume_button, _quit_button]:
		button.mouse_entered.connect(_on_button_hover.bind(button))
		button.mouse_exited.connect(_on_button_unhover.bind(button))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _is_paused:
			resume_game()
		else:
			pause_game()
		get_viewport().set_input_as_handled()


func pause_game() -> void:
	if _is_paused:
		return
	_is_paused = true
	get_tree().paused = true
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Ease the panel in so it doesn't pop.
	_panel.pivot_offset = _panel.size * 0.5
	_panel.modulate.a = 0.0
	_panel.scale = Vector2(0.92, 0.92)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(_panel, "modulate:a", 1.0, 0.18)
	tween.tween_property(_panel, "scale", Vector2.ONE, 0.22) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func resume_game() -> void:
	if not _is_paused:
		return
	_is_paused = false
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_button_hover(button: Button) -> void:
	button.pivot_offset = button.size * 0.5
	create_tween().tween_property(button, "scale", Vector2(1.08, 1.08), 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_button_unhover(button: Button) -> void:
	button.pivot_offset = button.size * 0.5
	create_tween().tween_property(button, "scale", Vector2.ONE, 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
