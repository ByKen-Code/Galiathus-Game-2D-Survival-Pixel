extends Node

var highscore = 0

func _ready() -> void:
	highscore = 0
	load_highscore()
	save_highscore()

func save_highscore():
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	
	file.store_var(highscore)
	
func load_highscore():
	if FileAccess.file_exists("user://save.dat"):
		var file = FileAccess.open("user://save.dat", FileAccess.READ)
		if file.get_length() > 0:
			highscore = file.get_var()
		else:
			highscore = 0
