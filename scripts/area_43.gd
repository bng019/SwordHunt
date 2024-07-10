extends Node2D

func _ready():
	global.player_area = 43
	print(global.current_scene)
	if global.game_area_44_loadin == true:
		$player.position.x = global.player_exit_area_44_posx  
		$player.position.y = global.player_exit_area_44_posy  
		
		
func _process(delta):
	death_scene()
	change_scene43()
	change_scene44()
	
func change_scene43():
	if global.transition43_scene == true:
		if global.current_scene == "area_43":
			get_tree().change_scene_to_file("res://scenes/area_42.tscn")
			#global.game_area_43_loadin = true
			global.game_area_44_loadin = false
			global.current_scene = "area_42"
			
func change_scene44():
	if global.transition44_scene == true:
		if global.current_scene == "area_43":
			get_tree().change_scene_to_file("res://scenes/area_44.tscn")
			global.game_area_44_loadin = true
			#global.game_area_43_loadin = false
			global.current_scene = "area_44"

func death_scene():
	if global.player_health == -1:
		global.game_first_loadin = true
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		global.current_scene = "game_over"

func _on_exit_area_43_body_entered(body):
	if body.has_method("player"):
		global.transition43_scene = true


func _on_exit_area_43_body_exited(body):
	if body.has_method("player"):
		global.transition43_scene = false


func _on_enter_area_44_body_entered(body):
	if body.has_method("player"):
		global.transition44_scene = true


func _on_enter_area_44_body_exited(body):
	if body.has_method("player"):
		global.transition44_scene = false
