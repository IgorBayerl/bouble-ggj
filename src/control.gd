extends Control

@onready var vbox_container: VBoxContainer = %VBoxContainer
@onready var point_count: Label = %PointCount
@onready var items_left: Label = %ItemsLeft
@onready var final_points_label: Label = %Points
@onready var timer_label: Label = %TimerLabel
@onready var timer: Timer = %Timer
@onready var items_not_delivered: Label = %ItemsNotDelivered
@onready var items_left_in_the_map_label: Label = %ItemsLeftInTheMapLabel

func _ready():
	# Ensure GameManager exists before connecting
	if GameManager:
		update_collected_items()
		GameManager.items_changed.connect(update_collected_items)

func _process(_delta: float) -> void:
	items_left.text = "Items left: " + str(GameManager.count_game_items())
	timer_label.text = str(int(timer.time_left))
	#Game over screen
	items_not_delivered.text = "Not delivered: " + str(GameManager.items_collected.size())
	items_left_in_the_map_label.text = "Items left: " + str(GameManager.count_game_items())
func update_collected_items():
	point_count.text = str(GameManager.points)
	final_points_label.text = "Total points: " + str(GameManager.points)
	
	# Clear existing labels
	for child in vbox_container.get_children():
		child.queue_free()

	# Get the last 3 items (if less than 3, take available items)
	#var last_items = GameManager.items_collected.slice(-3, GameManager.items_collected.size())
	var last_items = GameManager.items_collected

	# Iterate through the last collected items and add labels
	for item in last_items:
		var label = Label.new()
		label.text = item.item_name
		vbox_container.add_child(label)
	
	
	
