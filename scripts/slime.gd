extends CharacterBody2D

var speed = 44
var player_chase = false
var player = null
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if player_chase :
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
