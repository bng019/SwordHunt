extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

var health = 40
var player_inattack_zone = false
var can_take_damage = true
var play_death = false
var count_down = false
var player_dir = "none"
var mod_color = Color(0, 0, 0)
var dead = false

func _ready():
	mod_color = $AnimatedSprite2D.get_modulate()

func _physics_process(delta):
	deal_with_damage()
	#update_health()
	check_direction()
	
	if health <= 0:
		if play_death == true:
			$AnimatedSprite2D.play("death")
			dead = true
		elif count_down == false:
			count_down = true
			$death_timer.start()
	
	elif player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x-position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		
	
		
		
		
func _on_detection_area_body_entered(body):
		player = body
		player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass

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
	player_dir = "none"


func _on_hit_right_body_exited(body):
	player_dir = "none"


func _on_hit_up_body_exited(body):
	player_dir = "none"


func _on_hit_down_body_exited(body):
	player_dir = "none"


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
			$blink_timer.start()
			$AnimatedSprite2D.set_modulate(Color(2, 2, 2))
			can_take_damage = false

func _on_death_timer_timeout():
	play_death = true

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
#func update_health():
#	var healthbar = $healthbar
#	
#	healthbar.value = health
#	if health >= 100:
#		healthbar.visible = false
#	else:
#		healthbar.visible = true


func _on_animated_sprite_2d_animation_finished():
	if dead:
		global.player_exp += 2
		if global.player_exp >= global.player_exp_limit:
			global.player_exp -= global.player_exp_limit
			global.player_exp_limit += 5
			global.player_atk += 5
			global.player_hp_max += 20
			global.player_health += 20
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "level_up")
			if global.player_exp_limit % 10 == 5:
				global.player_max_potion += 1
		self.queue_free()


func _on_blink_timer_timeout():
	$AnimatedSprite2D.set_modulate(mod_color)
