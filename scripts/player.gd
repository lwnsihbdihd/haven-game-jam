extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $Sprite


const SPEED = 150.0
const JUMP_VELOCITY = -500.0

signal player_died

var corpse: Node = null
var can_move: bool = true
var is_alive: bool = true

func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_move:
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if direction == 1:
			sprite.flip_h = false
		elif direction == -1:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()

func die() -> void:
	if not is_alive:
		return
	
	is_alive = false
	player_died.emit(self)
	
func revive() -> void:
	is_alive = true

func _on_hitbox_area_entered(area: Area2D) -> void:	
	if area.collision_layer == 2 and area.collision_mask == 1:
		die()
