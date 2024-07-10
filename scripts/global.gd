extends Node

var player_current_attack = false

var loading = false

var current_scene = "world"
var transition_scene = false
var transition2_scene = false
var transition3_scene = false
var transition32_scene = false
var transition42_scene = false
var transition43_scene = false
var transition44_scene = false

var player_exit_homevillage_posx = 485
var player_exit_homevillage_posy = 206
var player_exit_homevillage2_posx = 3
var player_exit_homevillage2_posy = 205
var player_exit_homevillage3_posx = 236
var player_exit_homevillage3_posy = 336
var player_exit_area_32_posx = -329
var player_exit_area_32_posy = 107
var player_exit_area_42_posx = 831
var player_exit_area_42_posy = 57
var player_exit_area_43_posx = 591
var player_exit_area_43_posy = 330
var player_exit_area_44_posx = 1405
var player_exit_area_44_posy = 528
var player_start_posx = 239
var player_start_posy = 54

var game_first_loadin = true
var game_area_2_loadin = false
var game_area_3_loadin = false
var game_area_4_loadin = false
var game_area_32_loadin = false
var game_area_42_loadin = false
var game_area_43_loadin = false
var game_area_44_loadin = false

var player_health = 100
var player_exp = 0
var player_exp_limit = 5
var player_atk = 20
var player_hp_max = 100
var player_potion = 1
var player_max_potion = 1
var player_position_x = 0
var player_position_y = 0
var player_area = 1

var player_attack_dir = "none"

var level_1_lock = true
var level_2_lock = true
