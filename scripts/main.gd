extends Node2D

var main_menu: Node = null
var pause_menu: Node = null

var is_paused: bool = false

var current_level_root: Node = null
var level: int = 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause_game()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu = get_node("MainMenu")
	pause_menu = get_node("PauseMenu")
	_setup_main_menu(main_menu)
	_set_up_pause_menu(pause_menu)

func _setup_main_menu(menu: Node) -> void:
	var play = menu.get_node_or_null("PlayButton")
	if play:
		play.pressed.connect(_press_play)
	var quit = menu.get_node_or_null("QuitButton")
	if quit:
		quit.pressed.connect(_quit_game)

func _press_play() -> void:
	main_menu.visible = false
	_load_level(level, true)

func _go_to_main_menu() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	main_menu.visible = true
	
	if current_level_root:
		current_level_root.queue_free()
		
func _quit_game() -> void:
	get_tree().quit()

	# PAUSE MENU

func _set_up_pause_menu(menu: Node) -> void:
	var main_Menu = menu.get_node_or_null("PausePanel/MainMenuButton")
	if main_Menu:
		main_Menu.pressed.connect(_go_to_main_menu)
	
	var back = menu.get_node_or_null("PausePanel/ResumeButton")
	if back:
		back.pressed.connect(_pause_game)

func _pause_game() -> void:
	if not main_menu.visible:
		if not is_paused:
			is_paused = true
			pause_menu.visible = true
			get_tree().paused = true
			return
		if is_paused:
			is_paused = false
			pause_menu.visible = false
			get_tree().paused = false
			return

func _load_level(level_number: int, destroy_corpses: bool) -> void:
	
	# Destroy current level
	if current_level_root:
		current_level_root.queue_free()
	
	# Load Level
	var level_path = "res://scenes/levels/level_%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_set_up_level(current_level_root)
	_set_up_hud(current_level_root)
	
	if destroy_corpses:
		_destroy_corpses()
	
	# get player camera to change the camera limits as per level
	var player = current_level_root.get_node_or_null("Player")
	var camera = player.get_node("Camera")
	if level_number == 1:
		camera.limit_right = 496
	elif level_number == 2:
		camera.limit_right = 480
	elif level_number == 3:
		camera.limit_right = 560
	elif level_number == 4:
		camera.limit_right = 400

func _set_up_level(level_root: Node) -> void:
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_next_level)
	
	var player = level_root.get_node_or_null("Player")
	if player:
		player.player_died.connect(_add_corpse)
	

func _set_up_hud(level_root: Node) -> void:
	var reset_level = level_root.get_node_or_null("HUD/ResetLevel")
	if reset_level:
		reset_level.pressed.connect(_reset_level)

func _reset_level() -> void:
	_load_level(level, true)
	

func _add_corpse(body) -> void:
	if body.name == "Player":
		var Corpse = preload("res://scenes/corpse.tscn")
		var corpse = Corpse.instantiate()
		$Corpses.call_deferred("add_child", corpse)
		corpse.position = body.position
		_tp_player(52, -8, body)
		body.revive.call_deferred()
		#body.die()
		#call_deferred("_load_level", 1)

func _next_level(body) -> void:
	if body.name == "Player":
		level += 1
		body.can_move = false
		call_deferred("_load_level", level, true)

func _destroy_corpses() -> void:
	var corpses = get_node("Corpses")
	if corpses:
		print("corpses node found")
		for corpse in corpses.get_children():
			print("corpse found")
			corpse.queue_free()
	else:
		return


func _tp_player(x: float, y: float, player: Node) -> void:
	player.position = Vector2(x, y)
	player.velocity = Vector2(0, 0)
