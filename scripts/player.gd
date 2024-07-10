extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var mod_color
var attack_ip = false
var level = 1
const speed = 100
var current_dir = "none"


func _ready():
	mod_color = $AnimatedSprite2D.get_modulate()
	$AnimatedSprite2D.play("front_idle")
	
func _physics_process(delta):
	if global.loading == false:
		global.player_position_x = position.x
		global.player_position_y = position.y
	else:
		global.loading = false
		position.x = global.player_position_x
		position.y = global.player_position_y
	if player_alive:
		player_movement()
		enemy_attack()
		attack()
		current_camera()
		update_health()
		set_level()
		set_exp()
		consume_potion()
		set_potion()
	

	if global.player_health <= 0:
		player_alive = false #add respawn screen
		$AnimatedSprite2D.play("death")
	
	
		
	
func player_movement():
	
	if Input.is_action_pressed("d_right"):
		current_dir = "right"
		global.player_attack_dir = current_dir
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("a_left"):
		current_dir = "left"
		global.player_attack_dir = current_dir
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("s_down"):
		current_dir = "down"
		global.player_attack_dir = current_dir
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("w_up"):
		current_dir = "up"
		global.player_attack_dir = current_dir
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			if attack_ip == false:
				anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			if attack_ip == false:
				anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			if attack_ip == false:
				anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			if attack_ip == false:
				anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown and player_alive == true:
		global.player_health = global.player_health - 5
		enemy_attack_cooldown = false
		$slime_attack_cooldown.start()
		$blink_timer.start()
		$AnimatedSprite2D.set_modulate(Color(2, 2, 2))
		#print("player health = ", global.player_health)

func _on_slime_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_swing")
			$deal_attack.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_swing")
			$deal_attack.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_swing")
			$deal_attack.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_swing")
			$deal_attack.start()

func _on_deal_attack_timeout():
	$deal_attack.stop()
	global.player_current_attack = false
	attack_ip = false

func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$area_2_camera.enabled = false
		$area_3_camera.enabled = false
		$area_32_camera.enabled = false
		$area_4_camera.enabled = false
		$area_42_camera.enabled = false
		$area_43_camera.enabled = false
		$area_44_camera.enabled = false
	elif global.current_scene == "area_2":
		$world_camera.enabled = false
		$area_2_camera.enabled = true
		$area_3_camera.enabled = false
		$area_32_camera.enabled = false
		$area_4_camera.enabled = false
		$area_42_camera.enabled = false
		$area_43_camera.enabled = false
		$area_44_camera.enabled = false
	elif global.current_scene == "area_3":
		$world_camera.enabled = false
		$area_2_camera.enabled = false
		$area_3_camera.enabled = true
		$area_32_camera.enabled = false
		$area_4_camera.enabled = false
		$area_42_camera.enabled = false
		$area_43_camera.enabled = false
		$area_44_camera.enabled = false
	elif global.current_scene == "area_32":
		$world_camera.enabled = false
		$area_2_camera.enabled = false
		$area_3_camera.enabled = false
		$area_32_camera.enabled = true
		$area_4_camera.enabled = false
		$area_42_camera.enabled = false
		$area_43_camera.enabled = false
		$area_44_camera.enabled = false
	elif global.current_scene == "area_4":
		$world_camera.enabled = false
		$area_2_camera.enabled = false
		$area_3_camera.enabled = false
		$area_32_camera.enabled = false
		$area_4_camera.enabled = true
		$area_42_camera.enabled = false
		$area_43_camera.enabled = false
		$area_44_camera.enabled = false
	elif global.current_scene == "area_42":
		$world_camera.enabled = false
		$area_2_camera.enabled = false
		$area_3_camera.enabled = false
		$area_32_camera.enabled = false
		$area_4_camera.enabled = false
		$area_42_camera.enabled = true
		$area_43_camera.enabled = false
		$area_44_camera.enabled = false
	elif global.current_scene == "area_43":
		$world_camera.enabled = false
		$area_2_camera.enabled = false
		$area_3_camera.enabled = false
		$area_32_camera.enabled = false
		$area_4_camera.enabled = false
		$area_42_camera.enabled = false
		$area_43_camera.enabled = true
		$area_44_camera.enabled = false
	elif global.current_scene == "area_44":
		$world_camera.enabled = false
		$area_2_camera.enabled = false
		$area_3_camera.enabled = false
		$area_32_camera.enabled = false
		$area_4_camera.enabled = false
		$area_42_camera.enabled = false
		$area_43_camera.enabled = false
		$area_44_camera.enabled = true

func update_health():
	var healthbar = $CanvasLayer/healthbar
	healthbar.value = global.player_health
	

func _on_animated_sprite_2d_animation_finished():
	global.player_health = -1


func set_level():
	$CanvasLayer/lvl.text = str("Lv", global.player_exp_limit/5)
	
func set_exp():
	$CanvasLayer/expbar.value = global.player_exp
	$CanvasLayer/expbar.max_value = global.player_exp_limit	
	$CanvasLayer/healthbar.max_value = global.player_hp_max

func set_potion():
	$CanvasLayer/potion.text = str(global.player_potion)

func consume_potion():
	if Input.is_action_just_pressed("q_heal") and global.player_potion > 0 and global.player_health < global.player_hp_max:
		global.player_potion -= 1
		global.player_health += global.player_hp_max / 4
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "potion_heal")
		if global.player_health > global.player_hp_max:
			global.player_health = global.player_hp_max



func _on_blink_timer_timeout():
	$AnimatedSprite2D.set_modulate(mod_color)
	
func blink():
	$AnimatedSprite2D.set_modulate(Color(2, 2, 2))
	$blink_timer.start()
