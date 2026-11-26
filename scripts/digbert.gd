extends Area2D

const SPEED: int = 1
var direction: int = 1

func _physics_process(_delta: float) -> void:
	position.x += SPEED * direction

func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer == 4:
		direction *= -1


func _on_body_entered(body: Node2D) -> void:
	if body.collision_layer == 8:
		body.queue_free()
