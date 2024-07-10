extends Node2D

func _ready():
	global.player_area = 42
	print(global.current_scene)
	#if global.game_area_42_loadin == true:
		#$player.position.x = global.player_exit_area_42_posx  
		#$player.position.y = global.player_exit_area_42_posy  
	if global.game_area_43_loadin == true:
		$player.position.x = global.player_exit_area_43_posx  
		$player.position.y = global.player_exit_area_43_posy  
		
		
func _process(delta):
	death_scene()
	change_scene42()
	change_scene43()
	
func change_scene42():
	if global.transition42_scene == true:
		if global.current_scene == "area_42":
			get_tree().change_scene_to_file("res://scenes/area_4.tscn")
			#global.game_area_42_loadin = true
			global.game_area_43_loadin = false
			global.current_scene = "area_4"
			
func change_scene43():
	if global.transition43_scene == true:
		if global.current_scene == "area_42":
			get_tree().change_scene_to_file("res://scenes/area_43.tscn")
			global.game_area_43_loadin = true
			global.game_area_44_loadin = false
			global.current_scene = "area_43"

func death_scene():
	if global.player_health == -1:
		global.game_first_loadin = true
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		global.current_scene = "game_over"


func _on_exit_area_42_body_entered(body):
	if body.has_method("player"):
		global.transition42_scene = true


func _on_exit_area_42_body_exited(body):
	if body.has_method("player"):
		global.transition42_scene = false


func _on_enter_area_43_body_entered(body):
	if body.has_method("player"):
		global.transition43_scene = true


func _on_enter_area_43_body_exited(body):
	if body.has_method("player"):
		global.transition43_scene = false
