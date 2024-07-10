extends Node2D
func _ready():
	global.player_area = 44	
	print(global.current_scene)

func _process(delta):
	death_scene()
	change_scene44()

func change_scene44():
	if global.transition44_scene == true:
		if global.current_scene == "area_44":
			get_tree().change_scene_to_file("res://scenes/area_43.tscn")
			global.current_scene = "area_43"

func death_scene():
	if global.player_health == -1:
		global.game_first_loadin = true
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		global.current_scene = "game_over"


func _on_exit_area_44_body_entered(body):
	if body.has_method("player"):
		global.transition44_scene = true


func _on_exit_area_44_body_exited(body):
	if body.has_method("player"):
		global.transition44_scene = false
