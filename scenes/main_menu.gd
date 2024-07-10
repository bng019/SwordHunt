class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var load_button = $MarginContainer/HBoxContainer/VBoxContainer/Load_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@export var start_level = preload("res://scenes/world.tscn") as PackedScene
var save_path = "user://save.save" #Users/YourUserName/AppData/Roaming/Godot/app_userdata/SwordQuest


func _ready():
	handle_connecting_signals()
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_load_pressed() -> void:
	var game_first_loadin = false
	#get_tree().change_scene_to_file("res://scenes/world.tscn")
	load_data()
	
func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	
func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false
	
func on_exit_pressed() -> void:
	get_tree().quit()

func load_data():
	global.game_first_loadin = false
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
		file.close()
		global.loading = true
	else:
		print("No data saved")

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	load_button.button_down.connect(on_load_pressed)
	options_button.button_down.connect(on_options_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	exit_button.button_down.connect(on_exit_pressed)

