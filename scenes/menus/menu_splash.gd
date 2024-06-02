extends Control

@onready var menu_text = $Menu_Text
@onready var menu_art = $Menu_Art

var chapter = 0
var cur_script = ["please put\ntext","THE DEVIL\nTELLS LIES","chapter 2"]
# Called when the node enters the scene tree for the first time.
func _ready():
	junior_speak()

func junior_speak():
	if chapter == 0:
		menu_art.visible = true
		menu_text.visible = false
	elif chapter > 0:
		menu_art.visible = false
		menu_text.text = cur_script[chapter]
		menu_text.visible = true
