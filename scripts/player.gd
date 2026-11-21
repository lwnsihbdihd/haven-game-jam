extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $Sprite


const SPEED = 150.0
const JUMP_VELOCITY = -450.0

signal player_died

var corpse: Node = null
var can_move: bool = true
var is_alive: bool = true
var just_jumped: bool = false
var can_jump:bool = true

var frame_count: int = 0
var start_frame_count: bool = false
var coyote_frames: int = 3

func _physics_process(delta: float) -> void:
	if start_frame_count:
		frame_count += 1
	
	if frame_count == coyote_frames:
		start_frame_count = false
		frame_count = 0
		can_jump = false
		
	elif frame_count < coyote_frames and start_frame_count:
		can_jump = true
	
	if not is_alive:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_move:
		
		if is_on_floor():
			can_jump = true
			just_jumped = false
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and can_jump and not just_jumped:
			just_jumped = true
			velocity.y = JUMP_VELOCITY
		elif not is_on_floor() and not just_jumped:
			start_frame_count = true
			can_jump = true

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
