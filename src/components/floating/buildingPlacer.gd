extends Node3D

@export var planet_center: Vector3 = Vector3.ZERO  # The center of the planet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var down_dir := (planet_center - global_transform.origin).normalized()
	var desired_up := -down_dir  # The item should be facing away from the planet
	
	# Compute tangent vectors
	var current_basis = global_transform.basis
	var current_forward = -current_basis.z
	var tangent_forward = (current_forward - desired_up * current_forward.dot(desired_up)).normalized()
	var tangent_right = tangent_forward.cross(desired_up).normalized()
	
	# Apply the new rotation
	global_transform.basis = Basis(tangent_right, desired_up, -tangent_forward).orthonormalized()
	pass # Replace with function body.
