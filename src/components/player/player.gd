extends CharacterBody3D

@export var planet_center: Vector3 = Vector3.ZERO
@export var max_speed: float = 15.0
@export var acceleration: float = 30.0
@export var deceleration: float = 15.0
@export var rotation_accel: float = 5.0  # Rotation acceleration
@export var rotation_decel: float = 8.0  # Rotation deceleration
@export var max_rotation_speed: float = 2.0  # Max radians/second
@onready var anim: AnimationPlayer = $"fish_walkAnim/AnimationPlayer"

@export var spawn_radius: float = 1.0  # Maximum distance from bouble center
@onready var bouble: Area3D = %Area3D
@export var spawn_height_offset: float = 1.0
var current_spawns: Array[Node3D] = []
#BOuble mesh and colider
@onready var bouble_mesh: MeshInstance3D = %BoubleMesh
@onready var bouble_colision: CollisionShape3D = $Area3D/CollisionShape3D

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
func _handle_resize_bouble(value: int) -> void:
	print("Bouble Size: %s" % value)
	var mesh_value = value /3 + 4
	var scale_vector: Vector3 = Vector3(mesh_value,mesh_value,mesh_value)
	#bouble_colision.scale = scale_vector 
	bouble_mesh.scale = scale_vector

func _handle_items_changed():
	print("Items changed")
	_handle_resize_bouble(GameManager.items_collected.size())
	# Clear only if we have fewer items than before
	if current_spawns.size() > GameManager.items_collected.size():
		for i in range(GameManager.items_collected.size(), current_spawns.size()):
			current_spawns[i].queue_free()
		current_spawns.resize(GameManager.items_collected.size())
	
	# Add/update items
	for i in range(GameManager.items_collected.size()):
		var item = GameManager.items_collected[i]
		
		if i >= current_spawns.size():  # New item
			if item.item_scene:
				var new_item = item.item_scene.instantiate()
				bouble.add_child(new_item)
				new_item.scale = Vector3(0.3, 0.3, 0.3)
				new_item.global_position = get_deterministic_position(i)
				current_spawns.append(new_item)
			else:
				push_warning("Item '%s' has no scene assigned" % item.item_name)
		else:  # Existing item, update position
			current_spawns[i].global_position = get_deterministic_position(i)

func get_deterministic_position(index: int) -> Vector3:
	var base_pos = bouble.global_position
	var phi = deg_to_rad(index * 137.5)  # Horizontal angle (golden angle)
	var theta = deg_to_rad(index * 137.5 * 0.618)  # Vertical angle using golden ratio
	var radius = spawn_radius * sqrt(index + 1)
	
	# Convert spherical coordinates to Cartesian
	var x = cos(phi) * sin(theta) * radius
	var y = cos(theta) * radius  # This adds vertical variation
	var z = sin(phi) * sin(theta) * radius
	
	return base_pos + Vector3(x, y + spawn_height_offset, z)

##### END
# Extracted input collection function
func get_player_input() -> Dictionary:
	return {
		"rotate": Input.get_axis("turn_left", "turn_right"),
		"move": Input.get_axis("move_backward", "move_forward")
	}

func _physics_process(delta: float) -> void:
	var down_dir := (planet_center - global_position).normalized()
	var desired_up := -down_dir
	self.up_direction = desired_up

	# Only collect input if the game has started
	var input_values = get_player_input() if GameManager.input_enabled else {"rotate": 0.0, "move": 0.0}

	# Handle rotation input with acceleration
	var target_rotation_speed = -input_values["rotate"] * max_rotation_speed
	
	if input_values["rotate"] != 0:
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
	var target_velocity = -transform.basis.z * input_values["move"] * max_speed

	# Apply acceleration/deceleration
	if input_values["move"] != 0:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, deceleration * delta)

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	anim.speed_scale = velocity.length() * 0.4
	bouble.rotate_x(-velocity.length() * 0.01)
	bouble.rotate_y(-target_rotation_speed * 0.05)

	move_and_slide()

func rotate_player(rotation_speed: float, delta: float) -> void:
	rotate_object_local(Vector3.UP, rotation_speed * delta)

func align_with_planet(desired_up: Vector3) -> void:
	var current_basis = global_transform.basis
	var current_forward = -current_basis.z
	var tangent_forward = (current_forward - desired_up * current_forward.dot(desired_up)).normalized()
	var tangent_right = tangent_forward.cross(desired_up).normalized()
	global_transform.basis = Basis(tangent_right, desired_up, -tangent_forward).orthonormalized()
