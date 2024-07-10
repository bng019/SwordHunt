extends Node2D

func _ready():
	global.player_area = 4
	print(global.current_scene)
	if global.game_area_4_loadin == true:
		$player.position.x = global.player_exit_homevillage3_posx 
		$player.position.y = global.player_exit_homevillage3_posy 
	elif global.game_area_42_loadin == true:
		$player.position.x = global.player_exit_area_42_posx  
		$player.position.y = global.player_exit_area_42_posy  
		
		
func _process(delta):
	death_scene()
	change_scene3()
	change_scene42()
	
func change_scene3():
	if global.transition3_scene == true:
		if global.current_scene == "area_4":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.game_area_4_loadin = true
			global.game_area_42_loadin = false
			global.current_scene = "world"
			
func change_scene42():
	if global.transition42_scene == true:
		if global.current_scene == "area_4":
			get_tree().change_scene_to_file("res://scenes/area_42.tscn")
			global.game_area_42_loadin = true
			global.game_area_4_loadin = false
			global.current_scene = "area_42"

func death_scene():
	if global.player_health == -1:
		global.game_first_loadin = true
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		global.current_scene = "game_over"

func _on_exit_area_4_body_entered(body):
	if body.has_method("player"):
		global.transition3_scene = true


func _on_exit_area_4_body_exited(body):
	if body.has_method("player"):
		global.transition3_scene = false


func _on_enter_area_42_body_entered(body):
	if body.has_method("player"):
		global.transition42_scene = true


func _on_enter_area_42_body_exited(body):
	if body.has_method("player"):
		global.transition42_scene = false
