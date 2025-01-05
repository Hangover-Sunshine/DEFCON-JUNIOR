extends Control

@onready var label = $Pregame_MC/Pregame_VBox/Button_HBox/Button_VBox/Label
@onready var ap_scare = $AP_Scare

var line = 0
var cur_script = ["SHALL WE MEET THEM?", "BE NOT AFRAID!", "FOR HE IS LOVING!",
 "FOR SHE IS LONELY!", "FOR THEY ARE LONGING!", "FOR IT IS LIGHT!", "BE NOT AFRAID!",""]

func _ready():
	label.text = cur_script[line]
	ap_scare.play("0")

func _on_continue_button_pressed():
	line += 1
	MusicManager.set_volume(-24 + 3 * line)
	label.text = cur_script[line]
	ap_scare.play(str(line))
	if line == 6:
		MusicManager.stop(2.5)
	##
##

func _on_ap_scare_animation_finished(anim_name):
	if anim_name == "7":
		get_tree().quit()
