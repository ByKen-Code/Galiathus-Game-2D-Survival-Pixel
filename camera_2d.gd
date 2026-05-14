extends Camera2D

var shake_strength = 0.0
var posisi_awal

func _ready():
	posisi_awal = position

func _process(delta):
	if shake_strength > 0:
		position = posisi_awal + Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		
		shake_strength = lerpf(shake_strength, 0.0, 0.2)
	else:
		position = posisi_awal
