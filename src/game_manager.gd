extends Node
# AUTOLOAD (Singleton)

signal item_collected(game_item: GameItem)
signal items_extracted()
signal items_changed()

var items_collected: Array[GameItem] = []
var points: int = 0

func _ready() -> void:
	item_collected.connect(_handle_item_collected)
	items_extracted.connect(_handle_items_extracted)

func _handle_item_collected(game_item: GameItem) -> void:
	print("Collected item:", game_item.item_name)
	items_collected.append(game_item)
	items_changed.emit()

func _handle_items_extracted() -> void:
	var total_value: int = 0
	
	for item in items_collected:
		if item:  # Ensure item has value
			#total_value += item.value
			total_value += 1
	print(total_value)
	points += total_value
	print("Items extracted. Total points earned:", total_value)
	print("New total points:", points)

	# Clear collected items
	items_collected.clear()
	items_changed.emit()
