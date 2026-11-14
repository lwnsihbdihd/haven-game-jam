extends Node2D
@onready var level_root: Node2D = $LevelRoot

var corpse: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	_connect_signals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func _connect_signals() -> void:
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
		_tp_player(540, 440, body)
		body.revive()
		
		
	
func _tp_player(x: float, y: float, player: Node) -> void:
	player.position = Vector2(x, y)
