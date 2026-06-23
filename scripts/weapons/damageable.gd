extends StaticBody3D

class_name Damageable



signal died(killer: Node)



@export var max_health: float = 100.0



var _current_health: float



func _ready() -> void:

	_current_health = max_health



func apply_damage(amount: float, killer: Node = null) -> bool:

	# Ignore hits while already dead (e.g. waiting to respawn).

	if _current_health <= 0.0:

		return false

	_current_health -= amount

	if _current_health <= 0.0:

		emit_signal("died", killer)

		if killer != null and killer.has_signal("kill_confirmed"):

			killer.emit_signal("kill_confirmed", self)

		_handle_death(killer)

		return true  # Return true if killed

	return false  # Return false if still alive



# Overridable death behavior. Base implementation removes the node;
# subclasses (e.g. TrainingTarget) can respawn instead.
func _handle_death(_killer: Node) -> void:

	queue_free()
