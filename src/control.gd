extends Control

# Reference to the VBoxContainer node
@export var vbox_container: VBoxContainer
@export var add_item_button: Button
var rng = RandomNumberGenerator.new()

func _ready():
	# Assuming GameManager is a singleton or globally accessible
	add_item_button.pressed.connect(add_item_to_collected)
	if GameManager:
		update_collected_items()
		
# Function to add an item to the GameManager.items_collected array
func add_item_to_collected():
	print("Add Item")
	var new_item = GameItem.new()
	new_item.item_name = "Item Name something :" + str(rng.randf_range(-10.0, 10.0))
	new_item.value = int(rng.randf_range(1, 100))
	
	if GameManager:
		GameManager.items_collected.append(new_item)
		update_collected_items()  # Update the UI to reflect the new item

func update_collected_items():
	# Clear existing labels (optional, depending on your use case)
	for child in vbox_container.get_children():
		child.queue_free()

	# Iterate through the collected items and add labels
	for item in GameManager.items_collected:
		var label = Label.new()
		label.text = item.item_name
		vbox_container.add_child(label)

# Call this function whenever you want to update the displayed items
func on_item_collected():
	update_collected_items()
