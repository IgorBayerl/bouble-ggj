extends Node3D

@export var target : Node3D
@export var lookTarget : Node3D
@export var moveLerpSpeed : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	global_position = global_position.lerp(target.global_position,moveLerpSpeed)
	rotation = lookTarget.rotation
	pass
