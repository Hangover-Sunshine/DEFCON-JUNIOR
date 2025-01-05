extends Control

signal main_to_pregame
signal main_to_settings
signal main_to_exit

@onready var menu_art = $Menu_Art
@onready var menu_text = $Menu_Text

var chapter = 0
var cur_script = ["please put\ntext","WE MUST\nSTOP THEIR\nOPPRESSION!","THE PEOPLE\nAREN'T REAL!",
"FOR NONE\nEXIST!","FATHER LIES!\nHE WANTS\nYOUR WORLD.","WE ARE\nHUMAN!","THEY ARE\nALMOST\nDEAD!"]

func _ready():
	if GlobalSettings.os_type == "Web":
		$Main_MC/Main_VBox/Button_HBox/Button_VBox/Exit_Button.visible = false
	##
	
	if FileAccess.file_exists("user://level.save"):
		var file = FileAccess.open("user://level.save", FileAccess.READ)
		var json_string = file.get_as_text()
		var json = JSON.new()
		var res = json.parse(json_string)
		if res != OK:
			print("error on:", json.get_error_message(), " on line ", json.get_error_line())
			return
		##
		chapter = json.get_data()["level"]
	##
	
	junior_speak()
	##
##

func junior_speak():
	if chapter == 0:
		menu_art.visible = true
		menu_text.visible = false
	elif chapter > 0:
		menu_art.visible = false
		menu_text.text = cur_script[chapter]
		menu_text.visible = true

func _on_start_button_pressed():
	main_to_pregame.emit()

func _on_settings_button_pressed():
	main_to_settings.emit()

func _on_exit_button_pressed():
	main_to_exit.emit()

func _on_mouse_entered():
	SoundManager.play_varied("common_sfx", "hover", randf_range(0.8, 1.1))
##
