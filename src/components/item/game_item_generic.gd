class_name GameItemGeneric extends Node3D

@export var floating_enabled: bool = true  # Enable floating effect
@export var item_data: GameItem  # The GameItem resource

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D  # Placeholder cube
@onready var collision_shape: CollisionShape3D = %CollisionShape3D

var item_name: String = ""
var value: int = 0
var instantiated_item: Node3D = null  # Stores the real item instance

func _ready():
	if item_data:
		item_name = item_data.item_name
		value = item_data.value
		replace_placeholder_with_real_item()
	
	if floating_enabled:
		add_floating_behavior()

func replace_placeholder_with_real_item():
	if item_data.item_scene:
		# Instantiate the real item scene
		instantiated_item = item_data.item_scene.instantiate()
		if instantiated_item:
			add_child(instantiated_item)
			instantiated_item.global_transform = self.global_transform  # Keep position
			#mesh_instance.visible = false  # Hide placeholder cube
		else:
			print("Failed to load item scene for:", item_name)

func add_floating_behavior():
	var floating = Floating.new()
	add_child(floating)
	floating.owner = self  # Ensures it saves correctly

func _on_pickup():
	print("Picked up:", item_name, "with value:", value)
	queue_free()  # Remove the item
