extends Control

@onready var options_menu = $Options_Menu as OptionsMenu
@onready var grid_container = $GridContainer as GridContainer

var save_path = "user://save.save" #Users/YourUserName/AppData/Roaming/Godot/app_userdata/SwordQuest

func _ready():
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	
func on_exit_options_menu() -> void:
	grid_container.visible = true
	options_menu.visible = false
	
var _is_paused:bool = false:
	set = set_paused
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if options_menu.visible == true:
			grid_container.visible = true
			options_menu.visible = false
		elif options_menu.visible == false:
			_is_paused = !_is_paused
		
func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_pressed() -> void:
	_is_paused = false

func _on_save_pressed() -> void:
	_is_paused = false
	save()

func _on_load_pressed() -> void:
	_is_paused = false
	global.loading = true
	load_data()

func _on_options_pressed() -> void:
	grid_container.visible = false
	options_menu.set_process(false)
	options_menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(global.player_health)
	file.store_var(global.player_exp)
	file.store_var(global.player_exp_limit)
	file.store_var(global.player_atk)
	file.store_var(global.player_hp_max)
	file.store_var(global.player_potion)
	file.store_var(global.player_max_potion)
	file.store_var(global.player_position_x)
	file.store_var(global.player_position_y)
	file.store_var(global.player_area)
	file.store_string(global.current_scene)
	file.close()
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		global.player_health = file.get_var(global.player_health)
		global.player_exp = file.get_var(global.player_exp)
		global.player_exp_limit = file.get_var(global.player_exp_limit)
		global.player_atk = file.get_var(global.player_atk)
		global.player_hp_max = file.get_var(global.player_hp_max)
		global.player_potion = file.get_var(global.player_potion)
		global.player_max_potion = file.get_var(global.player_max_potion)
		global.player_position_x = file.get_var(global.player_position_x)
		global.player_position_y = file.get_var(global.player_position_y)
		global.player_area = file.get_var(global.player_area)
		print(global.player_area)
		if global.player_area == 1:
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.current_scene = "world"
		elif global.player_area == 2:
			get_tree().change_scene_to_file("res://scenes/area_2.tscn")
			global.current_scene = "area_2"
		elif global.player_area == 3:
			get_tree().change_scene_to_file("res://scenes/area_3.tscn")
			global.current_scene = "area_3"
		elif global.player_area == 4:
			get_tree().change_scene_to_file("res://scenes/area_4.tscn")
			global.current_scene = "area_4"
		elif global.player_area == 32:
			get_tree().change_scene_to_file("res://scenes/area_32.tscn")
			global.current_scene = "area_32"
		elif global.player_area == 42:
			get_tree().change_scene_to_file("res://scenes/area_42.tscn")
			global.current_scene = "area_42"
		elif global.player_area == 43:
			get_tree().change_scene_to_file("res://scenes/area_43.tscn")
			global.current_scene = "area_43"
		elif global.player_area == 44:
			get_tree().change_scene_to_file("res://scenes/area_44.tscn")
			global.current_scene = "area_44"
			
		#var temp_location = global.current_scene
		#global.current_scene = file.get_line()
		file.close()
		#below is experimental code for loading back to your previous position, currently I'm not sure how to implement and seems unnecessary for minimum turn in so I left it
		#if global.current_scene == "world":
		#	if temp_location == "area_2":
		#		get_tree().change_scene_to_file("res://scenes/world.tscn")
		#		global.game_area_2_loadin = true
		#		global.current_scene = "world"
	else:
		print("No data saved")


