extends Node2D

@onready var pause_menu: Control = $UI/pause_menu
var paused = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pausemenu()
	


func pausemenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else :
		pause_menu.show()
		Engine.time_scale = 0
		
		
	paused = !paused
