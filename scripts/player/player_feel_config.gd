extends Resource

class_name PlayerFeelConfig



@export_group("Movement")

@export var move_speed: float = 5.0

@export var sprint_speed: float = 8.0

@export var crouch_speed: float = 3.0



@export_group("Movement Feel")

# How quickly horizontal velocity ramps up / slows down. Higher = snappier,
# lower = heavier/more momentum. These remove the instant "wooden" stop-start.

@export var ground_acceleration: float = 12.0

@export var ground_deceleration: float = 14.0

@export var air_acceleration: float = 4.0

@export var air_deceleration: float = 2.0



@export_group("Jump")

@export var jump_force: float = 4.5

# Forgiving jump timing: still jump shortly after leaving a ledge (coyote)
# and when pressing jump slightly before landing (buffer).

@export var coyote_time: float = 0.12

@export var jump_buffer_time: float = 0.12



@export_group("Look")

@export var mouse_sensitivity: float = 0.12

@export var ads_sensitivity_multiplier: float = 0.7



@export_group("FOV / ADS")

@export var hip_fov: float = 75.0

@export var ads_fov: float = 55.0

@export var ads_fov_lerp_speed: float = 10.0



@export_group("Recoil / Shake Scales")

@export var recoil_scale: float = 1.0

@export var shake_scale: float = 1.0

