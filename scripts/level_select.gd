extends Control
@onready var grid_container: GridContainer = $LevelMenu/ClipControl/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level_box()

func _setup_level_box()-> void:
	for box in grid_container.get_children():
		box.level_num = box.get_index() + 1
		box.locked = false
