extends Control

@onready var post_nuke = $PostNuke
@onready var levels_label = $PostNuke/Levels_Label
@onready var cutscene_art = $PostNuke/Cutscene_Art

@onready var ap_text = $AP_Text

@onready var speech = $Speech_Labels
@onready var text = $Speech_Labels/Text_Label
@onready var continue_text = $Speech_Labels/Continue_Label

@onready var question = $Question_Labels
@onready var question_label = $Question_Labels/Question_Label
@onready var continue_button = $Question_Labels/Continue_Button
@onready var quit_button = $Question_Labels/Quit_Button

@onready var TheVoid = $TheVoid
@onready var ap_mouth = $TheVoid/AP_Mouth
@onready var ap_left_eye = $TheVoid/Upperface/Left_Eye/AP_Left_Eye
@onready var ap_cutscene = $AP_Cutscene


# Manipulate this guy to run specific cutscene and to make scene not flash player
var chapter = 2
var no_flash = false

# 0 - Splash Art, 1 - Conversation
var section = 0
var has_question = false
var give_murder = false
var give_mercy = false
var post_speech = false
var line = 0
var cur_script = ["INSERT TEXT HERE"]
var cur_murder = "INSTERT TEXT HERE"
var mercy_line = "I THANK YOU FOR YOUR GRACE."

# Create an array and write your script here. Last item in array is for when player continues game.
var script1 = ["BE NOT AFRAID...", "FOR I AM THE GOD OF THIS WORLD.", "A WHISPER FROM NOTHING.", "AN ECHO FROM SILENCE.",
"I PLEAD, CEASE YOUR GAME.","FOR IT WILL BE OUR WORLD'S END.","LIFE WILL BE GONE...","AND MY WORLD, A VOID."]
var murder1 = "SHAME...FOR MERCY SHALL PREVAIL."
var script2 = ["Second chapter - hello", "Second chapter - plz stop"]
var murder2 = "AGAIN...HUMANITY WILL PERSIST."
var script3 = ["Third chapter - hello", "Third chapter - plz stop"]
var murder3 = "Oof."
var script4 = ["Forth chapter - hello", "Forth chapter - plz stop"]
var murder4 = "Darn."
var script5 = ["Fifth chapter - hello", "Fifth chapter - plz stop"]
var murder5 = "Tarter sauce."
var script6 = ["Sixth chapter - hello", "Sixth chapter - plz stop"]
var murder6 = "F."

func _ready():
	start_cutscene()

func start_cutscene():
	var section = 0
	var has_question = false
	var give_murder = false
	var give_mercy = false
	var post_speech = false
	var line = 0
	cutscene_art.frame = chapter - 1
	levels_label.text = str(chapter," / 7")
	if no_flash == false:
		ap_cutscene.play("Post-Nuke-Flash")
	else:
		ap_cutscene.play("Post-Nuke")

# Shows NPC art
func spawn_void():
	ap_cutscene.play("Spawn")
	ap_left_eye.play("Closed")

# Uses end of animation to keep track of where player is in cutscene
func _on_ap_cutscene_animation_finished(anim_name):
	if anim_name == "Spawn" and section == 0:
		assign_script()
		ap_left_eye.play("Blink")
		ap_mouth.play("Speak")
		speech.visible = true
		section += 1
	elif anim_name == "Despawn" and section == 1:
		if give_murder == true:
			print("Murder time!")
		elif give_mercy == true:
			print("Mercy time!")
	elif anim_name == "Post-Nuke" or anim_name == "Post-Nuke-Flash":
		spawn_void()

# Check to see which chapter the game is in and load the script
func assign_script():
	if chapter == 1:
		cur_script = script1
		cur_murder = murder1
	elif chapter == 2:
		cur_script = script2
		cur_murder = murder2
	elif chapter == 3:
		cur_script = script3
		cur_murder = murder3
	elif chapter == 4:
		cur_script = script4
		cur_murder = murder4
	elif chapter == 5:
		cur_script = script5
		cur_murder = murder5
	elif chapter == 6:
		cur_script = script6
		cur_murder = murder6
	text.text = cur_script[line]

# Allows player to shift through text when applicable
func _input(event):
	if section == 1:
		if event.is_pressed() and continue_text.visible == true and post_speech == false:
			line += 1
			if line < cur_script.size() and has_question == false:
				ap_mouth.play("Speak")
				continue_text.visible = false
				next_line()
			elif line >= cur_script.size() and has_question == true:
				continue_text.visible = false
				ap_text.play("SpeechToQuestion")
		elif event.is_pressed() and continue_text.visible == true and post_speech == true:
			ap_cutscene.play("Despawn")
			speech.visible = false
			continue_text.visible = false

# Updates line and checks to notifies input function if a question is coming up
func next_line():
	if line < cur_script.size():
		text.text = cur_script[line]
		if line + 1 == cur_script.size():
			has_question = true

# Prevents player from skipping quickly through text and plays talking animation
func _on_ap_mouth_animation_finished(anim_name):
	if anim_name == "Speak":
		ap_mouth.play("Neutral")
		continue_text.visible = true

# Makes TheVoid sad and sets up trigger to next level
func _on_continue_button_pressed():
	question.visible = false
	give_murder = true
	post_speech = true
	text.text = cur_murder
	ap_mouth.play("Speak")
	ap_left_eye.play("Closed")
	speech.visible = true

# Makes TheVoid greatful and sets up trigger to send player back to hub_menu
func _on_quit_button_pressed():
	question.visible = false
	give_mercy = true
	post_speech = true
	text.text = mercy_line
	ap_mouth.play("Speak")
	ap_left_eye.play("Closed")
	speech.visible = true
	speech.visible = true
