extends Control

@onready var label = $Pregame_MC/Pregame_VBox/Button_HBox/Button_VBox/Label
@onready var ap_scare = $AP_Scare
@onready var timer = $Timer

var sfx = null
var line = 0
var cur_script = ["SHALL WE MEET THEM?", "BE NOT AFRAID!", "FOR HE IS LOVING!",
 "FOR SHE IS LONELY!", "FOR THEY ARE LONGING!", "FOR IT IS LIGHT!", "BE NOT AFRAID!",""]

var increase_level:int = 0

func _ready():
	label.text = cur_script[line]
	ap_scare.play("0")

func _on_continue_button_pressed():
	line += 1
	MusicManager.set_volume(-16 + 3 * line)
	label.text = cur_script[line]
	ap_scare.play(str(line))
	if line == 7:
		MusicManager.stop(0)
		timer.start(2.0)
		MusicManager.set_volume(-24)
		MusicManager.play("ost", "approaching")
	##
##

func _on_ap_scare_animation_finished(anim_name):
	if anim_name == "7":
		get_tree().quit()
	##
##

func _on_timer_timeout():
	increase_level += 1
	
	MusicManager.set_volume(-24 + 3 * increase_level)
	
	if increase_level < 8:
		timer.start(2 + 0.1 * increase_level)
	else:
		MusicManager.stop(0.5)
	##
##
