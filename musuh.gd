extends CharacterBody2D

var player = null
var speed = 40
var arah = "kanan"
var mati = false
var player_di_area = null
var walking_sound = [
	preload("res://sprites/sound/slime/Slime_small1.ogg"),
	preload("res://sprites/sound/slime/Slime_small2.ogg.mp3"),
	preload("res://sprites/sound/slime/Slime_small3.ogg.mp3"),
	preload("res://sprites/sound/slime/Slime_small4.ogg.mp3"),
	preload("res://sprites/sound/slime/Slime_small5.ogg.mp3")
]
var hit_sound = [
	preload("res://sprites/sound/slime/Slime_attack1.ogg"),
	preload("res://sprites/sound/slime/Slime_attack2.ogg")
]

@onready var sprite = $AnimatedSprite2D
@onready var hitplayer = $HitPlayer
@onready var walkingsound = $walkingsound
@onready var hitsound = $hitsound
@onready var walkingtimer = $WalkingTimer

func _physics_process(delta):
	if mati:
		return
	
	if player != null and player.mati == false:

		if walkingtimer.is_stopped():
			walkingtimer.start()
		var distance = global_position.distance_to(player.global_position)
		var max_distance = 300
		var volume = lerp(2.0, -25.0, distance / max_distance)
		volume = clamp(volume, -25, 2.0)
		walkingsound.volume_db = volume
		
		
		var direction = (player.get_node("TargetMusuh").global_position - global_position).normalized()
		velocity = direction * speed
		
		animasi_jalan(direction)
	else:
		walkingtimer.stop()
		walkingsound.stop()
		velocity = Vector2.ZERO
		animasi_diam()
		
	move_and_slide()
	
func animasi_jalan(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			arah = "kanan"
			sprite.play("jalan")
			sprite.flip_h = false
		else:
			arah = "kiri"
			sprite.play("jalan")
			sprite.flip_h = true
			
	else:
		if direction.y > 0:
			arah = "bawah"
			sprite.play("jalanbawah")
		else:
			arah = "atas"
			sprite.play("jalanatas")
			
func animasi_diam():
	if arah == "kanan":
		sprite.play("diam")
		sprite.flip_h = false
	if arah == "kiri":
		sprite.play("diam")
		sprite.flip_h = true
	if arah == "atas":
		sprite.play("diamatas")
	if arah == "bawah":
		sprite.play("diambawah")

		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null

func musuh_mati():
	mati = true
	velocity = Vector2.ZERO
	player = null
	
	$DamageTimer.stop()
	$HitPlayer.set_deferred("monitoring", false)
	$HitPlayer.set_deferred("monitorable", false)
	
	if arah == "kiri":
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	hitsound.stream = hit_sound.pick_random()
	hitsound.play()
	sprite.play("mati")
	await sprite.animation_finished
	call_deferred("queue_free")

func _on_hit_player_body_entered(body: Node2D) -> void:
	if body.has_method("kena_damage"):
		player_di_area = body
		$DamageTimer.start()



func _on_hit_player_body_exited(body: Node2D) -> void:
	if body == player_di_area:
		player_di_area = null
		$DamageTimer.stop()

func _on_damage_timer_timeout() -> void:
	if player_di_area:
		player_di_area.kena_damage()


func _on_walking_timer_timeout() -> void:
	walkingsound.stream = walking_sound.pick_random()
	walkingsound.play()
