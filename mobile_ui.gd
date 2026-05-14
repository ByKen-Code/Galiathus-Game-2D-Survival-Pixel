extends CanvasLayer

@onready var pausemenu = $PauseMenu



func _on_pause_button_pressed() -> void:
	pausemenu.visible = true
	get_tree().paused = true

func _on_resume_button_pressed() -> void:
	pausemenu.visible = false
	get_tree().paused = false

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
