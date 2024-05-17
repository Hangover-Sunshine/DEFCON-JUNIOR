extends Control

@onready var text = $Text_Label

var chapter = 1
var line = 0
var length = 0
var cur_script = ["INSERT TEXT HERE"]
var script1 = ["Hello", "How are you", "Good", "Goodbye"]
var script2 = ["Hola", "Coma Estas", "Bien", "Choi"]

func _ready():
	assign_script()
	print(script1.size())

func assign_script():
	if chapter == 1:
		cur_script = script1
	text.text = cur_script[line]
		
func _input(event):
	if event.is_pressed():
		line += 1
	next_line()

func next_line():
	if line < cur_script.size():
		text.text = cur_script[line]
	elif line >= cur_script.size():
		text.text = "SCENE END"
