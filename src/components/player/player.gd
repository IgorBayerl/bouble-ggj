extends CharacterBody3D

@export var planet_center: Vector3 = Vector3.ZERO
@export var max_speed: float = 15.0
@export var acceleration: float = 30.0
@export var deceleration: float = 15.0
@export var rotation_accel: float = 5.0  # Rotation acceleration
@export var rotation_decel: float = 8.0  # Rotation deceleration
@export var max_rotation_speed: float = 2.0  # Max radians/second
@onready var anim: AnimationPlayer = $"fish_walkAnim/AnimationPlayer"

@export var spawn_radius: float = 2.0  # Maximum distance from bouble center
@onready var bouble: Area3D = %Area3D
@export var spawn_height_offset: float = 1.0
var current_spawns: Array[Node3D] = []

var current_rotation_velocity: float = 0.0

func _ready() -> void:
	GameManager.items_changed.connect(_handle_items_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_M:
		var new_item := GameItem.new()
		new_item.item_scene = preload("res://assets/Models/Gem.blend")
		GameManager.item_collected.emit(new_item)
		_handle_items_changed()
###### INIT
func _handle_items_changed():
	print("Items changed")
	
	# Clear existing spawned items
	for spawn in current_spawns:
		spawn.queue_free()
	current_spawns.clear()
	
	# Spawn new items inside the bouble
	for item in GameManager.items_collected:
		if item.item_scene:
			var new_item = item.item_scene.instantiate()
			bouble.add_child(new_item)
			
			# Scale the item to 30% of its original size
			new_item.scale = Vector3(0.3, 0.3, 0.3)
			
			# Set its position randomly inside bouble within the radius
			new_item.global_position = get_random_position_inside_radius()
			
			current_spawns.append(new_item)
		else:
			push_warning("Item '%s' has no scene assigned" % item.item_name)

func get_random_position_inside_radius() -> Vector3:
	var base_pos = bouble.global_position
	
	# Generate a random point inside a sphere
	var random_offset = Vector3(
		randf_range(-1, 1),
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized() * randf_range(0, spawn_radius)  # Scale within the radius
	
	# Apply offset and height adjustment
	return base_pos + random_offset
##### END

func _physics_process(delta: float) -> void:
	var down_dir := (planet_center - global_position).normalized()
	var desired_up := -down_dir
	self.up_direction = desired_up
	
	# Handle rotation input with acceleration
	var rotate_input := Input.get_axis("turn_left", "turn_right")
	var target_rotation_speed = -rotate_input * max_rotation_speed
	
	if rotate_input != 0:
		# Accelerate rotation
		current_rotation_velocity = move_toward(
			current_rotation_velocity, 
			target_rotation_speed, 
			rotation_accel * delta
		)
	else:
		# Decelerate rotation
		current_rotation_velocity = move_toward(
			current_rotation_velocity, 
			0.0, 
			rotation_decel * delta
		)
	
	# Apply rotation
	if current_rotation_velocity != 0:
		rotate_player(current_rotation_velocity, delta)
	
	# Align with planetary surface
	align_with_planet(desired_up)
	
	# Handle movement input
	var move_input := Input.get_axis("move_backward", "move_forward")
	var target_velocity = -transform.basis.z * move_input * max_speed
	
	# Apply acceleration/deceleration
	if move_input != 0:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, deceleration * delta)
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	anim.speed_scale = velocity.length() * 0.4
	
	move_and_slide()

func rotate_player(rotation_speed: float, delta: float) -> void:
	rotate_object_local(Vector3.UP, rotation_speed * delta)

func align_with_planet(desired_up: Vector3) -> void:
	var current_basis = global_transform.basis
	var current_forward = -current_basis.z
	var tangent_forward = (current_forward - desired_up * current_forward.dot(desired_up)).normalized()
	var tangent_right = tangent_forward.cross(desired_up).normalized()
	global_transform.basis = Basis(tangent_right, desired_up, -tangent_forward).orthonormalized()
