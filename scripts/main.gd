extends Node2D
@onready var level_root: Node2D = $LevelRoot

var current_level_root: Node = null
var level: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	_connect_signals()

func _load_level(level_number: int) -> void:
	
	# Destroy current level
	if current_level_root:
		current_level_root.queue_free()
		
	# Load Level
	var level_path = "res://scenes/levels/level_%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"

func _connect_signals() -> void:
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_next_level)
		
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			print("enemy")
			enemy.player_died.connect(_add_corpse)

func _add_corpse(body) -> void:
	if body.name == "Player":
		body.die()
		var Corpse = preload("res://scenes/corpse.tscn")
		var corpse = Corpse.instantiate()
		call_deferred("add_child", corpse)
		corpse.position = body.position
		_tp_player(20, -20, body)
		body.revive()

func _next_level(body) -> void:
	if body.name == "Player":
		level += 1
		body.can_move = false
		_load_level(level)
	
	
func _tp_player(x: float, y: float, player: Node) -> void:
	player.position = Vector2(x, y)
