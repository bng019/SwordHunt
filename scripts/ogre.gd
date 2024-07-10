extends CharacterBody2D

var speed = 70
var player_chase = false
var player = null
var roam = false
var left_roam = false
var origin = false
var health = 300
var player_inattack_zone = false
var can_take_damage = true
var can_deal_damage = true
var play_death = false
var count_down = false
var player_dir = "none"
var right = false
var left = false
var attacking = false
var dealt_dmg = false
var strike_dir = "none"
var pos
var mod_color
var rng = RandomNumberGenerator.new()
var dead = false

func _ready():
	mod_color = $AnimatedSprite2D.get_modulate()
	pos = position
	$idle_timer.wait_time = rng.randf_range(3, 4)
	

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
	elif roam and !attacking:
		if left_roam == true:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk")
			position.x -= 0.15
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk")
			position.x += 0.15
	elif player_chase and !attacking:
		$aggro_timer.stop()
		origin = false
		if left and abs(player.position + Vector2(12, -10) - position) > Vector2(1,1):
			position += (player.position + Vector2(12, -10) - position).normalized() * 0.7
		elif right and abs(player.position + Vector2(-12, -10) - position) > Vector2(1,1):
			position += (player.position + Vector2(-12, -10) - position).normalized() * 0.7
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x-position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif origin and !attacking:
		var norm = ((pos - position)/speed).normalized()
		position += norm * 0.5
		if pos.x < position.x:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk")
		if abs(pos - position) < Vector2(1,1):
			origin = false
			left_roam = false
			$idle_timer.start()
	elif !attacking:
		$AnimatedSprite2D.play("idle")
	
	

	
func ogre():
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
			$AnimatedSprite2D.set_modulate(Color(2, 2, 2))
			$blink_timer.start()
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
	if !dealt_dmg and attacking and ($AnimatedSprite2D.frame >= 4 and $AnimatedSprite2D.frame <= 6) and ((strike_dir == "right" and $AnimatedSprite2D.flip_h == false) or (strike_dir == "left" and $AnimatedSprite2D.flip_h == true)) :
		dealt_dmg = true
		global.player_health -= 30
		player.blink()
		

func _on_death_timer_timeout():
	play_death = true

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_atk_cooldown_timeout():
	can_deal_damage = true
	dealt_dmg = false

func _on_idle_timer_timeout():
	if roam == false:
		if left_roam == true:
			left_roam = false
		else:
			left_roam = true
		if (left or right) and !player_chase:
			player_chase = true
			roam = false
			$idle_timer.stop()
		else:
			roam = !roam
			$idle_timer.start()
	else:
		roam = !roam
		$idle_timer.start()


func _on_detection_area_left_body_entered(body):
	if body.has_method("player"):
		left = true
		player = body
		if $AnimatedSprite2D.flip_h == true:
			player_chase = true
			roam = false
			$idle_timer.stop()
		
func _on_detection_area_left_body_exited(body):
	if body.has_method("player"):
		left = false
		if right == false:
			$aggro_timer.start()
			player = null
			player_chase = false


func _on_detection_area_right_body_entered(body):
	if body.has_method("player"):
		right = true
		player = body
		if $AnimatedSprite2D.flip_h == false:
			player_chase = true
			roam = false
			$idle_timer.stop()


func _on_detection_area_right_body_exited(body):
	if body.has_method("player"):
		right = false
		if left == false:
			$aggro_timer.start()
			player = null
			player_chase = false


func _on_aggro_timer_timeout():
	$aggro_timer.stop()
	origin = true

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
		global.player_exp += 7
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




func _on_blink_timer_timeout():
	$AnimatedSprite2D.set_modulate(mod_color)
