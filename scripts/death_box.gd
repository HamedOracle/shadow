extends Area2D


@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(body: Node2D) -> void:
	timer.start()
	




func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
