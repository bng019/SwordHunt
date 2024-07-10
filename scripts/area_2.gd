extends Node2D

func _ready():
	global.player_area = 2

func _process(delta):
	death_scene()
	change_scene()
	

func _on_exit_area_2_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_exit_area_2_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "area_2":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.game_area_2_loadin = true
			global.current_scene = "world"


func death_scene():
	if global.player_health == -1:
		global.game_first_loadin = true
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		global.current_scene = "game_over"
		
