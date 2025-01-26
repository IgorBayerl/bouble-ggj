extends Node3D

var localPos : Vector3
#@export var copyObject : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	localPos = position + Vector3.DOWN*0.1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position = copyObject.position
	#rotation = copyObject.rotation
	position = localPos + Vector3.UP * cos(Time.get_ticks_msec() / 250.0) * 0.3
	position += Vector3.LEFT * cos(Time.get_ticks_msec() / 400.0) * 0.1
	pass
