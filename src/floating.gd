class_name Floating extends Node3D

@export var amplitude: float = 0.5  # How high/low the floating effect goes
@export var speed: float = 2.0  # How fast the floating moves
@export var easing: float = 1.5  # Controls how smooth the motion is

var original_position: Vector3
var time: float = 0.0

func _ready():
	if get_parent() is Node3D:
		original_position = get_parent().position
	else:
		push_warning("Floating script must be added as a child of a Node3D object!")

func _process(delta: float):
	if not get_parent() is Node3D:
		return

	time += delta * speed
	var float_offset = sin(time) * amplitude
	var eased_offset = float_offset * ease_curve(time)
	
	# Update parent position (relative floating effect)
	get_parent().position = original_position + Vector3(0, eased_offset, 0)

func ease_curve(t: float) -> float:
	# Easing function for smoother motion
	return pow(abs(sin(t)), easing) * sign(sin(t))
