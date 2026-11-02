extends GridMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for id in mesh_library.get_item_list():
		print(id, ": ", mesh_library.get_item_name(id))
