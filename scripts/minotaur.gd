extends CharacterBody2D

var speed = 70
var player_chase = false
var player = null
var health = 1000
var player_inattack_zone = false
var can_take_damage = true
var can_deal_damage = true
var play_death = false
var count_down = false
var player_dir = "none"
var attacking = false
var dealt_dmg = false
var strike_dir = "none"
var attack_num = 1
var mod_color
var attack1 = false
var attack2 = false
var attack3 = false

var rng = RandomNumberGenerator.new()

var dead = false

func _ready():
	mod_color = $AnimatedSprite2D.get_modulate()
	$CanvasLayer/healthbar.max_value = health
	$CanvasLayer/healthbar.value = health

func _physics_process(delta):
	deal_with_damage()
	check_direction()
	attack()
	
	if health <= 0:
		if play_death == true:
			$AnimatedSprite2D.play("death")
			dead = true
		elif count_down == false:
			count_down = true
			$death_timer.start()
	elif player_chase and !attacking:
		if (player.position.x-position.x) < 0:
			position += (player.position + Vector2(10, 10) - position).normalized() * 0.5
		else:
			position += (player.position + Vector2(-10, 10) - position).normalized() * 0.5
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x-position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif !attacking:
		$AnimatedSprite2D.play("idle")
	
	

	
func minotaur():
	pass

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true

func check_direction():
	if player_dir == global.player_attack_dir:
		player_inattack_zone = true
	else:
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - global.player_atk
			$take_damage_cooldown.start()
			$AnimatedSprite2D.set_modulate(Color(2,2,2))
			$blink_timer.start()
			can_take_damage = false
			$CanvasLayer/healthbar.value = health

func attack():
	
	if player_chase and can_deal_damage and (strike_dir == "right" or strike_dir == "left"):
		attack_num = rng.randi_range(1, 3)
		while (attack_num == 1 and attack1 == false) or (attack_num == 2 and attack2 == false) or (attack_num == 3 and attack3 == false):
			attack_num = rng.randi_range(1, 3)
		attacking = true
		can_deal_damage = false
		$atk_cooldown.start()
		if strike_dir == "right":
			$AnimatedSprite2D.flip_h = false
		elif strike_dir == "left":
			$AnimatedSprite2D.flip_h = true
		if attack_num == 1 and attack1:
			$AnimatedSprite2D.play("attack1")
		elif attack_num == 2 and attack2:
			$AnimatedSprite2D.play("attack2")
		elif attack_num == 3 and attack3:
			$AnimatedSprite2D.play("attack3")
	if !dealt_dmg and attacking and (attack_num == 1 and $AnimatedSprite2D.frame >= 1 and $AnimatedSprite2D.frame <= 3) and ((strike_dir == "right" and $AnimatedSprite2D.flip_h == false) or (strike_dir == "left" and $AnimatedSprite2D.flip_h == true)) :
		dealt_dmg = true
		global.player_health -= 75
		player.blink()
	elif !dealt_dmg and attacking and (attack_num == 2 and $AnimatedSprite2D.frame >= 1 and $AnimatedSprite2D.frame <= 2) and ((strike_dir == "right" and $AnimatedSprite2D.flip_h == false) or (strike_dir == "left" and $AnimatedSprite2D.flip_h == true)) :
		dealt_dmg = true
		global.player_health -= 50
		player.blink()
	elif !dealt_dmg and attacking and (attack_num == 3 and $AnimatedSprite2D.frame >= 3 and $AnimatedSprite2D.frame <= 7) and ((strike_dir == "right" and $AnimatedSprite2D.flip_h == false) or (strike_dir == "left" and $AnimatedSprite2D.flip_h == true)) :
		dealt_dmg = true
		global.player_health -= 100
		player.blink()

func _on_death_timer_timeout():
	play_death = true

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_atk_cooldown_timeout():
	can_deal_damage = true
	dealt_dmg = false



func _on_hit_left_body_entered(body):
	if body.has_method("player"):
		player_dir = "right"

func _on_hit_right_body_entered(body):
	if body.has_method("player"):
		player_dir = "left"

func _on_hit_up_body_entered(body):
	if body.has_method("player"):
		player_dir = "down"

func _on_hit_down_body_entered(body):
	if body.has_method("player"):
		player_dir = "up"
		
func _on_hit_left_body_exited(body):
	if body.has_method("player"):
		player_dir = "none"

func _on_hit_right_body_exited(body):
	if body.has_method("player"):
		player_dir = "none"

func _on_hit_up_body_exited(body):
	if body.has_method("player"):
		player_dir = "none"

func _on_hit_down_body_exited(body):
	if body.has_method("player"):
		player_dir = "none"
	
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack1":
		attacking = false
	elif $AnimatedSprite2D.animation == "attack2":
		attacking = false
	elif $AnimatedSprite2D.animation == "attack3":
		attacking = false
	elif dead:
		global.player_exp += 50
		while global.player_exp >= global.player_exp_limit:
			global.player_exp -= global.player_exp_limit
			global.player_exp_limit += 5
			global.player_atk += 5
			global.player_hp_max += 20
			global.player_health += 20
			if global.player_exp_limit % 10 == 5:
				global.player_max_potion += 1
		self.queue_free()




func _on_attack_1_right_body_entered(body):
	if body.has_method("player"):
		strike_dir = "right"
		attack1 = true

func _on_attack_1_right_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"
		attack1 = false

func _on_attack_1_left_body_entered(body):
	if body.has_method("player"):
		strike_dir = "left"
		attack1 = true

func _on_attack_1_left_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"
		attack1 = false

func _on_attack_2_right_body_entered(body):
	if body.has_method("player"):
		strike_dir = "right"
		attack2 = true

func _on_attack_2_right_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"
		attack2 = false

func _on_attack_2_left_body_entered(body):
	if body.has_method("player"):
		strike_dir = "left"
		attack2 = true

func _on_attack_2_left_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"
		attack2 = false

func _on_attack_3_right_body_entered(body):
	if body.has_method("player"):
		strike_dir = "right"
		attack3 = true

func _on_attack_3_right_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"
		attack3 = false

func _on_attack_3_left_body_entered(body):
	if body.has_method("player"):
		strike_dir = "left"
		attack3 = true

func _on_attack_3_left_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"
		attack3 = false


func _on_blink_timer_timeout():
	$AnimatedSprite2D.set_modulate(mod_color)
