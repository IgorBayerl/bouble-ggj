extends AnimationPlayer

@onready var menu: Control = %Menu
@onready var speed_lines: ColorRect = %SpeedLines

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("menu")



func enable_inputs():
	GameManager.input_enabled = true


func _on_button_pressed() -> void:
	self.play("starting")
	menu.hide()
	speed_lines.hide()
