extends CharacterBody2D

const kecepatan = 150
var arah = "kanan"
var gerak = false
var sedang_attack = false
var hp = 5
var mati = false
var knockback = Vector2.ZERO
var hp5 = preload("res://sprites/UI/ui hp/hp_5.png")
var hp4 = preload("res://sprites/UI/ui hp/hp_4.png")
var hp3 = preload("res://sprites/UI/ui hp/hp_3.png")
var hp2 = preload("res://sprites/UI/ui hp/hp_2.png")
var hp1 = preload("res://sprites/UI/ui hp/hp_1.png")
var hp0 = preload("res://sprites/UI/ui hp/hp_0.png")

@onready var sprite = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var hpbar = $"../Control2/UI_HP/HP_bar"
@onready var gameover = $"../Control2/UI_HP/Game_Over"
@onready var restartbutton = $"../Control2/UI_HP/RestartButton"
@onready var exitbutton = $"../Control2/UI_HP/ExitButton"
@onready var color = $"../Control2/UI_HP/ColorRect2"
@onready var hitsound = $Hitsound
@onready var attacksound = $Attacksound
@onready var walkingsound = $Walkingsound
@onready var damageblinktimer = $DamageBlinkTimer
@onready var control = $"../Control3/MobileUI"

func _physics_process(delta: float) -> void:
	if mati:
		return
		
	knockback = knockback.lerp(Vector2.ZERO, 0.2)
	gerak_player()
	
func gerak_player():
	if sedang_attack:
		return

	gerak = false
	velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("attack"):
		attack()
		return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = input_vector.normalized() * kecepatan
	
	if input_vector != Vector2.ZERO:
		gerak = true
		
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				arah = "kanan"
			else:
				arah = "kiri"
		else:
			if input_vector.y > 0:
				arah = "bawah"
			else:
				arah = "atas"
	if arah == "kanan":
		sprite.play("jalan" if gerak else "diam")
		sprite.flip_h = false
	if arah == "kiri":
		sprite.play("jalan" if gerak else "diam")
		sprite.flip_h = true
	if arah == "atas":
		sprite.play("jalanatas" if gerak else "diamatas")
	if arah == "bawah":
		sprite.play("jalanbawah" if gerak else "diambawah")

	velocity += knockback
	if gerak:
		if !walkingsound.playing:
			walkingsound.play()
	else:
		walkingsound.stop()

	
	move_and_slide()

func attack():
	
	sedang_attack = true
	attacksound.play()
	
	if arah == "kanan":
		sprite.flip_h = false
		attack_area.position = Vector2(15, 8)
	if arah == "kiri":
		sprite.flip_h = true
		attack_area.position = Vector2(-15, 8)
	if arah == "atas":
		attack_area.position = Vector2(0, -10)
	if arah == "bawah":
		attack_area.position = Vector2(0, 20)

	sprite.play("attack_" + arah)
	attack_area.monitoring = true
	await get_tree().create_timer(0.5).timeout
	attack_area.monitoring = false
	sedang_attack = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("musuh"):
		body.musuh_mati()

func kena_damage():
	if mati == false:
		hitsound.play()
		
	sprite.modulate = Color(1, 0.3, 0.3)
	damageblinktimer.start()
	
	knockback = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * 200
	
	if mati == false:
		$Camera2D.shake_strength = 8

	
	hp -= 1
	
	if hp == 5:
		hpbar.texture = hp5
	elif hp == 4:
		hpbar.texture = hp4
	elif hp == 3:
		hpbar.texture = hp3
	elif hp == 2:
		hpbar.texture = hp2
	elif hp == 1:
		hpbar.texture = hp1
	elif hp <= 0 and mati == false:
		hpbar.texture = hp0
		if arah == "kiri":
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		sprite.play("mati")
		var current_wave = $"../EnemySpawner".wave
		
		if current_wave > Global.highscore:
			Global.highscore = current_wave
			Global.save_highscore()
		walkingsound.stop()
		mati = true


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "mati":
		gameover.visible = true
		restartbutton.visible = true
		exitbutton.visible = true
		color.visible = true
		control.visible = false



func _on_damage_blink_timer_timeout() -> void:
	sprite.modulate = Color(1, 1, 1)


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
