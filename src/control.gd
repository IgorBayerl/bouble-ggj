extends Control

# Reference to the VBoxContainer node
@export var vbox_container: VBoxContainer

func _ready():
	# Assuming GameManager is a singleton or globally accessible
	if GameManager:
		update_collected_items()
	GameManager.item_collected.connect(add_item_to_collected)
		
# Function to add an item to the GameManager.items_collected array
func add_item_to_collected(new_item: GameItem):
	print("Add Item")
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
