@tool
extends Button

signal level_selected

@export var level_num = 1
@export var locked: bool = true:
	set(value):
		locked = value
		level_locked() if locked else level_unlocked()

func level_locked() -> void:
	level_state(true)

func level_unlocked() -> void:
	level_state(false)
	var level_label = get_node_or_null("LevelNum")
	
	if level_label:
		$LevelNum.text = str(level_num)


func level_state(value: bool) -> void:
	disabled = value
	var level_label = get_node_or_null("LevelNum")
	
	if level_label:
		$LevelNum.visible = not value

func _on_pressed():
	level_selected.emit(level_num)
