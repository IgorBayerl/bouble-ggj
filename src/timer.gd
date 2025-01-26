extends Timer

@onready var game_over: Control = %GameOver

func _ready() -> void:
	game_over.hide()

func _on_timeout() -> void:
	GameManager.input_enabled = false
	game_over.show()
