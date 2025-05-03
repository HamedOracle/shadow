extends CanvasLayer




func _on_retry_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/lvl_1.tscn")


func _on_exit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
