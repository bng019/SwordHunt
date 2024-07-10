extends Node2D

var near_chest = false
var near_bed = false
var bed_healing_cooldown = true

func _ready():
	global.player_area = 1
	print(global.current_scene)
	if global.game_first_loadin == true:
		global.player_health = 100
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	elif global.game_area_2_loadin == true:
		$player.position.x = global.player_exit_homevillage_posx
		$player.position.y = global.player_exit_homevillage_posy
	elif global.game_area_3_loadin == true:
		$player.position.x = global.player_exit_homevillage2_posx
		$player.position.y = global.player_exit_homevillage2_posy
	elif global.game_area_4_loadin == true:
		$player.position.x = global.player_exit_homevillage3_posx
		$player.position.y = global.player_exit_homevillage3_posy
	

func _process(delta):
	change_scene()
	change_scene2()
	change_scene3()
	respawn()
	bed_heal()
	potion_fill()
	button_bed_show()
	button_chest_show()

func _on_area_2_transition_body_entered(body):
	if body.has_method("player"):
			global.transition_scene = true


func _on_area_2_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/area_2.tscn")
			global.game_first_loadin = false
			global.game_area_2_loadin = false
			global.game_area_3_loadin = false
			global.game_area_4_loadin = false

			global.current_scene = "area_2"
			
func change_scene2():
	if global.transition2_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/area_3.tscn")
			global.game_first_loadin = false
			global.game_area_3_loadin = false
			global.game_area_2_loadin = false
			global.game_area_4_loadin = false

			global.current_scene = "area_3"

func change_scene3():
	if global.transition3_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/area_4.tscn")
			global.game_first_loadin = false
			global.game_area_3_loadin = false
			global.game_area_2_loadin = false
			global.game_area_4_loadin = false

			global.current_scene = "area_4"
			
func respawn():
	if global.player_health == 0:
		_ready()

func _on_bed_healing_body_entered(body):
	if body.has_method("player"):
		near_bed = true

func _on_bed_healing_body_exited(body):
	near_bed = false

func bed_heal():
	if near_bed and global.player_health < global.player_hp_max == true and Input.is_action_just_pressed("e_use"):
		global.player_health = global.player_hp_max
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "bed_heal")

func _on_potion_refill_body_entered(body):
	if body.has_method("player"):
		near_chest = true

func _on_potion_refill_body_exited(body):
	near_chest = false

func potion_fill():
	if near_chest and global.player_potion < global.player_max_potion and Input.is_action_just_pressed("e_use"):
		global.player_potion = global.player_max_potion
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "potion_chest")

func button_bed_show():
	$button_bed/AnimatedSprite2D.visible = false
	if near_bed:
		$button_bed/AnimatedSprite2D.visible = true
		$button_bed/AnimatedSprite2D.play("pressing")
		
func button_chest_show():
	$button_chest/AnimatedSprite2D.visible = false
	if near_chest:
		$button_chest/AnimatedSprite2D.visible = true
		$button_chest/AnimatedSprite2D.play("pressing")


func _on_area_3_transition_body_entered(body):
	if body.has_method("player"):
		if global.player_exp_limit >= 25: #change later for level cap
			global.level_1_lock = false
			global.transition2_scene = true
		else:
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "level_1_lock")
			return


func _on_area_3_transition_body_exited(body):
	if body.has_method("player"):
		global.transition2_scene = false


func _on_area_4_transition_body_entered(body):
	if body.has_method("player"):
		if global.player_exp_limit >= 50: #change later for level cap
			global.level_2_lock = false
			global.transition3_scene = true
		else:
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "level_2_lock")
			return


func _on_area_4_transition_body_exited(body):
	if body.has_method("player"):
		global.transition3_scene = false
