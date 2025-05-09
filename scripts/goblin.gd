extends CharacterBody2D

var speed = 67
var player_chase = false
var player = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta) -> void:
	
		# Apply gravity
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if player_chase:
			position +=(player.position - position)/speed
			$AnimatedSprite2D.play("walk")
			
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false

		else:
			$AnimatedSprite2D.play("idle")

# Move the character
		move_and_slide()
		
		


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
