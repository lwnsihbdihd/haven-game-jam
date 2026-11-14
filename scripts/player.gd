extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()

func die() -> void:
	is_alive = false
	queue_free()
	
func revive() -> void:
	is_alive = true
