extends RigidBody3D

var timer : float = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(timer <= 0):
		timer = rng.randf_range(1.0, 5.0)
		linear_velocity = Vector3(rng.randf_range(-5.0, 5.0),rng.randf_range(-5.0, 5.0),rng.randf_range(-5.0, 5.0))
		angular_velocity = Vector3(rng.randf_range(-5.0, 5.0),rng.randf_range(-5.0, 5.0),rng.randf_range(-5.0, 5.0))
		pass
	
	
	timer -= delta
	pass
