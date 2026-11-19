extends Control
@onready var grid_container: GridContainer = $LevelMenu/ClipControl/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level_box()
	_connect_level_selected()

func _setup_level_box()-> void:
	for box in grid_container.get_children():
		box.level_num = box.get_index() + 1
		box.locked = false

func _connect_level_selected():
	for box in grid_container.get_children():
		box.connect("level_selected", _change_to_scene)

func _change_to_scene(level:int):
	pass
