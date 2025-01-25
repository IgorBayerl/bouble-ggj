extends Camera3D

# The node path to your player (RigidBody3D or another 3D node).
@export var player_path: NodePath
@export var planet_center: Vector3 = Vector3.ZERO

# Camera settings
@export var orbit_distance: float = 10.0
@export var orbit_height: float = 2.0
@export var follow_speed: float = 2.0

var _should_reset: bool

# We store the player node after we get it
var player

func _ready():
	# Get the actual node for the player, if it’s valid
	player = get_node_or_null(player_path)
	if player == null:
		push_warning("Player node not found. Check your 'player_path' export.")
