extends Control

@onready var menu_text = $Menu_Text
@onready var menu_art = $Menu_Art

var chapter = 0
var cur_script = ["please put\ntext","MY FATHER\nTELLS LIES!","YOU HAVE\nKILLED NOONE!",
"NO PEACE\nCAN EXIST!","NO MEMORIES\nARE LOST!","WE ARE\nNOT GODS!","WE MUST\nDEFEAT\nTHEM!"]
# Called when the node enters the scene tree for the first time.
func _ready():
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

func junior_speak():
	if chapter == 0:
		menu_art.visible = true
		menu_text.visible = false
	elif chapter > 0:
		menu_art.visible = false
		menu_text.text = cur_script[chapter]
		menu_text.visible = true
