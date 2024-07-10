extends Node2D

func _ready():
	global.player_area = 3
	print(global.current_scene)
	if global.game_area_3_loadin == true:
		$player.position.x = global.player_exit_homevillage2_posx
		$player.position.y = global.player_exit_homevillage2_posy
	elif global.game_area_32_loadin == true:
		$player.position.x = global.player_exit_area_32_posx 
		$player.position.y = global.player_exit_area_32_posy 
		
		
func _process(delta):
	death_scene()
	change_scene2()
	change_scene32()
	
func change_scene2():
	if global.transition2_scene == true:
		if global.current_scene == "area_3":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.game_area_3_loadin = true
			global.game_area_32_loadin = false
			global.current_scene = "world"
			
func change_scene32():
	if global.transition32_scene == true:
		if global.current_scene == "area_3":
			get_tree().change_scene_to_file("res://scenes/area_32.tscn")
			global.game_area_32_loadin = true
			global.game_area_3_loadin = false
			global.current_scene = "area_32"

func death_scene():
	if global.player_health == -1:
		global.game_first_loadin = true
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		global.current_scene = "game_over"


func _on_exit_area_3_body_entered(body):
	if body.has_method("player"):
		global.transition2_scene = true


func _on_exit_area_3_body_exited(body):
	if body.has_method("player"):
		global.transition2_scene = false


func _on_enter_area_32_body_entered(body):
	if body.has_method("player"):
		global.transition32_scene = true


func _on_enter_area_32_body_exited(body):
	if body.has_method("player"):
		global.transition32_scene = false
