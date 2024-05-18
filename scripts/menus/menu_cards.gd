extends Control

@onready var card_boost = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Boost
@onready var card_boost_jetfuel = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Boost_Jetfuel

@onready var card_bubble = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Bubble
@onready var card_bubble_airtime = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Bubble_Airtime
@onready var card_bubble_gurgle = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Bubble_Gurgle

@onready var card_spitfire = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Spitfire
@onready var card_spitfire_piercing = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Spitfire_Piercing
@onready var card_spitfire_spew = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Spitfire_Spew
@onready var card_spitfire_upchuck = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Spitfire_Upchuck

@onready var card_radiation = $Cards_MC/Levelup_VBox1/LevelUp_VBox2/Card_Hbox/Card_Radiation

var curr_health

var shield_status
var curr_shield_cd
var curr_shield_dur

var gun_status
var curr_weapon_penetration
var max_mag_size
var curr_number_of_bullets

var dash_status
var curr_dash_max

var all_data
var player_data
var curr_level

func _ready():
	var file = FileAccess.open("user://player.save", FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var res = json.parse(json_string)
	if res != OK:
		print("error on:", json.get_error_message(), " on line ", json.get_error_line())
		return
	##
	var data = json.get_data()
	
	curr_health = data.health
	
	shield_status = data["shield"]["has"]
	curr_shield_cd = data["shield"]["cd"]
	curr_shield_dur = data["shield"]["dur"]
	
	gun_status = data["gun"]["has"]
	curr_weapon_penetration = data["gun"]["pen"]
	max_mag_size = data["gun"]["mag"]
	curr_number_of_bullets = data["gun"]["bullets"]
	
	dash_status = data["dash"]["has"]
	curr_dash_max = data["dash"]["stack"]
	
	var cards = []
	
	if shield_status:
		cards.push_back(card_bubble_airtime)
		cards.push_back(card_bubble_gurgle)
	else:
		cards.push_back(card_bubble)
	##
	
	if gun_status:
		cards.push_back(card_spitfire_piercing)
		cards.push_back(card_spitfire_spew)
		cards.push_back(card_spitfire_upchuck)
	else:
		cards.push_back(card_spitfire)
	##
	
	if dash_status:
		cards.push_back(card_boost_jetfuel)
	else:
		cards.push_back(card_boost)
	##
	
	cards.push_back(card_radiation)
	
	var randex:int = randi() % cards.size()
	cards[randex].visible = true
	cards.remove_at(randex)
	
	randex = randi() % cards.size()
	cards[randex].visible = true
	cards.remove_at(randex)
##

func save():
	var data = {}
	
	data["health"] = curr_health
	
	data["shield"] = {}
	data["shield"]["has"] = shield_status
	data["shield"]["dur"] = curr_shield_dur
	data["shield"]["cd"] = curr_shield_cd
	
	data["gun"] = {}
	data["gun"]["has"] = gun_status
	data["gun"]["pen"] = curr_weapon_penetration
	data["gun"]["mag"] = max_mag_size
	data["gun"]["bullets"] = curr_number_of_bullets
	
	data["dash"] = {}
	data["dash"]["has"] = dash_status
	data["dash"]["stack"] = curr_dash_max
	
	var content = JSON.stringify(data)
	
	var save_file = FileAccess.open("user://player.save", FileAccess.WRITE)
	if save_file == null:
		printerr("SOMETHING WENT HORRIBLY WRONG SAVING!")
		return
	##
	save_file.store_string(content)
##

func _on_card_boost_pressed():
	dash_status = true
	curr_dash_max += 1
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_bubble_pressed():
	shield_status = true
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_radiation_pressed():
	curr_health += 1
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_spitfire_pressed():
	gun_status = true
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_boost_jetfuel_pressed():
	curr_dash_max += 1
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_bubble_airtime_pressed():
	curr_shield_dur *= 1.2
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_bubble_gurgle_pressed():
	curr_shield_cd *= 0.9
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_spitfire_piercing_pressed():
	curr_weapon_penetration += 1
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_spitfire_spew_pressed():
	curr_number_of_bullets += 1
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##

func _on_card_spitfire_upchuck_pressed():
	max_mag_size += 1
	save()
	GlobalSignals.emit_signal("load_scene", "GameScene")
##
