extends Node2D
@onready var player: CharacterBody2D = $"Player"
@onready var level_root: Node2D = $LevelRoot

var corpse: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		player.die()
		var corpse_path = "res://scenes/corpse.tscn"
		corpse = load(corpse_path).instantiate()
		corpse.x = body.x
		corpse.y = body.y
	
