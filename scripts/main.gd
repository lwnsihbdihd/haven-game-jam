extends Node2D
@onready var player: CharacterBody2D = $"Player"

signal player_died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _connect_signals(body: Node) -> void:
	var player = body.get_node_or_null("Player")
	if player:
		body.player_died.connect(_add_corpse)

func _add_corpse() -> void:
	pass
