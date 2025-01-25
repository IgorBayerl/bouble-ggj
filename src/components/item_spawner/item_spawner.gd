extends Node3D

@export var planet_center: Vector3 = Vector3.ZERO  # The center of the planet
@export var items: Array[GameItem]  # List of possible items to spawn
@export var randomize_rotation: bool = false
@onready var game_item_generic: PackedScene = preload("res://src/components/item/game_item_generic.tscn")

func _ready():
	await get_tree().process_frame  # Ensures nodes are initialized
	spawn_random_item()
	queue_free()  # Removes spawner after spawning


func spawn_random_item():
	if items.is_empty():
		print("No items available to spawn!")
		return
	
	# Select a random item from the list
	var selected_item: GameItem = items[randi() % items.size()]
	
	# Instantiate the generic item wrapper
	var new_item_instance: GameItemGeneric = game_item_generic.instantiate()
	if new_item_instance:
		# Assign the GameItem data to the generic wrapper
		new_item_instance.item_data = selected_item
		
		# Set position at spawn point
		get_parent().add_child(new_item_instance)
		new_item_instance.global_transform.origin = self.global_transform.origin
		
		# Align the item with the planetary surface
		align_with_planet(new_item_instance)
		# Add floating behavior if assigned
		var floating_instance = Floating.new()
		new_item_instance.add_child(floating_instance)
		floating_instance.owner = new_item_instance  # Ensures it saves in the scene
		print("Floating behavior added to:", selected_item.item_name)
		
		print("Spawned item:", selected_item.item_name)
	else:
		print("Error instantiating game_item_generic!")

func align_with_planet(item: Node3D) -> void:
	var down_dir := (planet_center - item.global_transform.origin).normalized()
	var desired_up := -down_dir  # The item should be facing away from the planet
	
	# Compute tangent vectors
	var current_basis = item.global_transform.basis
	var current_forward = -current_basis.z
	var tangent_forward = (current_forward - desired_up * current_forward.dot(desired_up)).normalized()
	var tangent_right = desired_up.cross(tangent_forward).normalized()
	
	# Apply the new rotation
	item.global_transform.basis = Basis(tangent_right, desired_up, -tangent_forward).orthonormalized()
	
	# Optional: Apply random Y-axis rotation for variation
	if randomize_rotation:
		item.rotate_object_local(Vector3.UP, randf() * TAU)  # TAU = 2 * PI
