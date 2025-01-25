extends Control

# Reference to the VBoxContainer node
@export var vbox_container: VBoxContainer
@onready var point_count: Label = %PointCount

func _ready():
	# Ensure GameManager exists before connecting
	if GameManager:
		update_collected_items()
		GameManager.items_changed.connect(update_collected_items)

func update_collected_items():
	point_count.text = str(GameManager.points)
	# Clear existing labels
	for child in vbox_container.get_children():
		child.queue_free()

	# Get the last 3 items (if less than 3, take available items)
	var last_items = GameManager.items_collected.slice(-3, GameManager.items_collected.size())

	# Iterate through the last collected items and add labels
	for item in last_items:
		var label = Label.new()
		label.text = item.item_name
		vbox_container.add_child(label)
