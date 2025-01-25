extends Node
#AUTOLOAD

signal item_collected(game_item: GameItem)

var items_collected : Array[GameItem] = []


func _ready() -> void:
	item_collected.connect(handle_item_collected)
	

func handle_item_collected(game_item: GameItem) -> void:
	print(game_item)
