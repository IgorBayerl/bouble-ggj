class_name Floating extends Node3D

@export var amplitude: float = 0.5  # How high/low the floating effect goes
@export var speed: float = 2.0  # How fast the floating moves
@export var easing: float = 1.5  # Controls how smooth the motion is
@export var rotation_speed: float = -50  # Speed of rotation (degrees per second)

var original_position: Vector3
var time: float = 0.0

func _ready():
	if get_parent() is Node3D:
		original_position = get_parent().position  # Store the initial local position
	else:
		push_warning("Floating script must be added as a child of a Node3D object!")

func _process(delta: float):
	if not get_parent() is Node3D:
		return

	# Floating motion
	time += delta * speed
	var float_offset = sin(time) * amplitude
	var eased_offset = float_offset * ease_curve(time)
	get_parent().position = original_position + Vector3(0, eased_offset, 0)

	# Local rotation motion
	var rotation_amount = rotation_speed * delta
	get_parent().rotate_object_local(Vector3.UP, deg_to_rad(rotation_amount))  # Rotate around local Y-axis

func ease_curve(t: float) -> float:
	# Easing function for smoother motion
	return pow(abs(sin(t)), easing) * sign(sin(t))
