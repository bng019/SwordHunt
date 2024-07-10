extends CharacterBody2D

var speed = 70
var player_chase = false
var player = null
var health = 500
var player_inattack_zone = false
var can_take_damage = true
var can_deal_damage = true
var play_death = false
var count_down = false
var player_dir = "none"
var attacking = false
var dealt_dmg = false
var strike_dir = "none"

var dead = false

	

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
			position += (player.position + Vector2(10, 10) - position).normalized() * 0.1
		else:
			position += (player.position + Vector2(-10, 10) - position).normalized() * 0.1
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x-position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif !attacking:
		$AnimatedSprite2D.play("idle")
	
	

	
func cursed():
	pass



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
			can_take_damage = false

func attack():
	if player_chase and can_deal_damage and (strike_dir == "right" or strike_dir == "left"):
		attacking = true
		can_deal_damage = false
		$atk_cooldown.start()
		if strike_dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack")
		elif strike_dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack")
	if !dealt_dmg and attacking and ($AnimatedSprite2D.frame >= 12 and $AnimatedSprite2D.frame <= 16) and ((strike_dir == "right" and $AnimatedSprite2D.flip_h == false) or (strike_dir == "left" and $AnimatedSprite2D.flip_h == true)) :
		dealt_dmg = true
		global.player_health -= 65
		

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
	if $AnimatedSprite2D.animation == "attack":
		attacking = false
		if strike_dir == "right":
			$AnimatedSprite2D.flip_h = false
		elif strike_dir == "left":
			$AnimatedSprite2D.flip_h = true
	elif dead:
		global.player_exp += 10
		if global.player_exp >= global.player_exp_limit:
			global.player_exp -= global.player_exp_limit
			global.player_exp_limit += 5
			global.player_atk += 5
			global.player_hp_max += 20
			global.player_health += 20
			if global.player_exp_limit % 10 == 5:
				global.player_max_potion += 1
		self.queue_free()

func _on_strike_right_body_entered(body):
	if body.has_method("player"):
		strike_dir = "right"

func _on_strike_right_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"

func _on_strike_left_body_entered(body):
	if body.has_method("player"):
		strike_dir = "left"

func _on_strike_left_body_exited(body):
	if body.has_method("player"):
		strike_dir = "none"


