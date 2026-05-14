extends Control

var highscore = 0

@onready var highscoretext = $HighScoreText

func _ready() -> void:
	highscoretext.text = "High Score : " + str(Global.highscore)
	
func _physics_process(delta: float) -> void:
	pencet()

func _on_play_button_pressed()  -> void:
	get_tree().change_scene_to_file("res://world.scn")
	
func pencet():
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://world.scn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
