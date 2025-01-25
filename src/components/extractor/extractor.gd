extends Node3D

@onready var base_mesh: MeshInstance3D = $BaseMesh
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var absorb_items_sound: AudioStreamPlayer3D = %AbsorbItemsSound
@onready var area: Area3D = $Area3D  # Ensure you have an Area3D for collision detection

var player: Node3D = null
var is_absorbing: bool = false

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_group"):
		GameManager.items_extracted.emit()
		absorb_items_sound.play()
		animation_player.play("extract")
