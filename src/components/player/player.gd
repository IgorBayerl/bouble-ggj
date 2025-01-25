extends CharacterBody3D

@export var planet_center: Vector3 = Vector3.ZERO
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 3.0  # Radians per second

func _physics_process(delta: float) -> void:
	var down_dir := (planet_center - global_position).normalized()
	var desired_up := -down_dir
	self.up_direction = desired_up  # For physics
	
	# Handle rotation input
	var rotate_input := Input.get_axis("turn_left", "turn_right")
	if rotate_input != 0:
		rotate_player(rotate_input, delta)
	
	# Align with planetary surface
	align_with_planet(desired_up)
	
	# Handle movement input
	var move_input := Input.get_axis("move_backward", "move_forward")
	var move_direction = -transform.basis.z * move_input  # Forward is -Z
	velocity = move_direction * SPEED
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func rotate_player(input: float, delta: float) -> void:
	# Rotate around local Y axis (which points away from planet)
	rotate_object_local(Vector3.UP, input * ROTATION_SPEED * delta)

func align_with_planet(desired_up: Vector3) -> void:
	# Get current basis vectors
	var current_basis = global_transform.basis
	var current_forward = -current_basis.z  # Get actual forward direction
	
	# Project current forward onto tangent plane
	var tangent_forward = (current_forward - desired_up * current_forward.dot(desired_up)).normalized()
	
	# Create new orthogonal basis
	var tangent_right = desired_up.cross(tangent_forward).normalized()
	global_transform.basis = Basis(tangent_right, desired_up, -tangent_forward).orthonormalized()
