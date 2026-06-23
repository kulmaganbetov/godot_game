extends Control

class_name MainMenu

# Title screen: Start / Settings / Quit, plus a small settings panel
# (master volume + fullscreen). Set as the project's main scene.

@export var game_scene_path: String = "res://scenes/ui/LevelSelect.tscn"

@onready var _main_root: Control = $Center
@onready var _settings_root: Control = $SettingsCenter
@onready var _title: Label = $Center/MainVBox/Title
@onready var _start_button: Button = $Center/MainVBox/StartButton
@onready var _settings_button: Button = $Center/MainVBox/SettingsButton
@onready var _quit_button: Button = $Center/MainVBox/QuitButton
@onready var _back_button: Button = $SettingsCenter/Panel/Margin/VBox/BackButton
@onready var _volume_slider: HSlider = $SettingsCenter/Panel/Margin/VBox/VolumeRow/VolumeSlider
@onready var _fullscreen_check: CheckButton = $SettingsCenter/Panel/Margin/VBox/FullscreenRow/FullscreenCheck


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_settings_root.visible = false

	_start_button.pressed.connect(_on_start_pressed)
	_settings_button.pressed.connect(_open_settings)
	_quit_button.pressed.connect(_on_quit_pressed)
	_back_button.pressed.connect(_close_settings)
	_volume_slider.value_changed.connect(_on_volume_changed)
	_fullscreen_check.toggled.connect(_on_fullscreen_toggled)

	# Reflect current audio / window state in the controls.
	_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0)) * 100.0
	_fullscreen_check.button_pressed = \
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

	for button in [_start_button, _settings_button, _quit_button, _back_button]:
		button.mouse_entered.connect(_on_button_hover.bind(button))
		button.mouse_exited.connect(_on_button_unhover.bind(button))

	# Soft fade-in for the whole menu, plus a gentle title pulse.
	modulate.a = 0.0
	create_tween().tween_property(self, "modulate:a", 1.0, 0.5) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_pulse_title()


func _pulse_title() -> void:
	_title.pivot_offset = _title.size * 0.5
	_title.scale = Vector2(0.9, 0.9)
	create_tween().tween_property(_title, "scale", Vector2.ONE, 0.6) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _open_settings() -> void:
	_main_root.visible = false
	_settings_root.visible = true


func _close_settings() -> void:
	_settings_root.visible = false
	_main_root.visible = true


func _on_volume_changed(value: float) -> void:
	var linear: float = clamp(value / 100.0, 0.0001, 1.0)
	AudioServer.set_bus_volume_db(0, linear_to_db(linear))


func _on_fullscreen_toggled(pressed: bool) -> void:
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if pressed else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)


func _on_button_hover(button: Button) -> void:
	button.pivot_offset = button.size * 0.5
	create_tween().tween_property(button, "scale", Vector2(1.06, 1.06), 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_button_unhover(button: Button) -> void:
	button.pivot_offset = button.size * 0.5
	create_tween().tween_property(button, "scale", Vector2.ONE, 0.1) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
