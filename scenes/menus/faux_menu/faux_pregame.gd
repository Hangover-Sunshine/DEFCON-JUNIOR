extends Control

@onready var label = $Pregame_MC/Pregame_VBox/Button_HBox/Button_VBox/Label
@onready var ap_scare = $AP_Scare

var line = 0
var cur_script = ["SHALL WE MEET THEM?", "1", "2", "3", "4", "5", "6", ""]

func _ready():
	label.text = cur_script[line]
	ap_scare.play("0")

func _on_continue_button_pressed():
	line += 1
	label.text = cur_script[line]
	ap_scare.play(str(line))

func _on_ap_scare_animation_finished(anim_name):
	if anim_name == "7":
		get_tree().quit()
