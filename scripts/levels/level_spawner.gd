extends Node3D

class_name LevelSpawner

# Keeps up to `max_alive` training targets alive at random spawn points.
# When one is destroyed, it reports the kill and schedules a replacement.

signal target_killed

@export var spawn_points_path: NodePath
@export var max_alive: int = 4
@export var respawn_delay: float = 0.8

var _target_scene: PackedScene = preload("res://scenes/TrainingTarget.tscn")
var _points: Array[Node3D] = []
var _alive: Array[Node] = []
var _active: bool = false


func _ready() -> void:
	var sp := get_node_or_null(spawn_points_path)
	if sp:
		for child in sp.get_children():
			var p := child as Node3D
			if p:
				_points.append(p)


func start() -> void:
	_active = true
	for i in max_alive:
		_spawn_one()


func stop() -> void:
	_active = false


func _spawn_one() -> void:
	if not _active or _points.is_empty():
		return
	var target := _target_scene.instantiate() as TrainingTarget
	if target == null:
		return
	# The spawner owns respawn timing, so disable the target's own respawn.
	target.auto_respawn = false
	add_child(target)
	target.global_transform.origin = _pick_point()
	target.died.connect(_on_target_died.bind(target))
	_alive.append(target)


func _pick_point() -> Vector3:
	return _points[randi() % _points.size()].global_transform.origin


func _on_target_died(_killer: Node, target: Node) -> void:
	_alive.erase(target)
	target_killed.emit()
	if _active:
		get_tree().create_timer(respawn_delay).timeout.connect(_spawn_one)
