class_name GameItemGeneric extends Node3D

@onready var placeholder_mesh: MeshInstance3D = $MeshInstance3D
var item_data: GameItem = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	var new_item_scene:= item_data.item_scene.instantiate()
	add_child(new_item_scene)
	placeholder_mesh.queue_free()
