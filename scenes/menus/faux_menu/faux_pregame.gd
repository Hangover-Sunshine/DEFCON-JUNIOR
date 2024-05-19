extends Control

@onready var label = $Pregame_MC/Pregame_VBox/Button_HBox/Button_VBox/Label
@onready var ap_scare = $AP_Scare
@onready var ap_flash = $AP_Flash

var line = 0
var no_flash = false
var cur_script = ["SHALL WE MEET THEM?", "BE NOT AFRAID!", "FOR THEY ARE LOVING",
 "FOR THEY ARE LONELY", "FOR THEY ARE LONGING", "FOR THEY ARE LIGHT", "FOR THEY...",""]

func _ready():
	label.text = cur_script[line]
	ap_scare.play("0")

func _on_continue_button_pressed():
	line += 1
	label.text = cur_script[line]
	ap_scare.play(str(line))
	if line == 7 and no_flash == false:
		ap_flash.play("Flash")

func _on_ap_scare_animation_finished(anim_name):
	if anim_name == "7":
		get_tree().quit()
