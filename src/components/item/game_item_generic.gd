class_name GameItemGeneric extends Node3D

@onready var placeholder_mesh: MeshInstance3D = $MeshInstance3D
@export var item_data: GameItem = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_item_scene:= item_data.item_scene.instantiate()
	add_child(new_item_scene)
	placeholder_mesh.queue_free()
	


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_group"):
		GameManager.item_collected.emit(item_data)
		queue_free()
