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
@onready var sfx_timing = $SFXTiming


# Manipulate this guy to run specific cutscene and to make scene not flash player
var chapter = 3
var no_flash = false
var has_returned = false

# 0 - Splash Art, 1 - Conversation
var section = 0
var has_question = false
var give_murder = false
var give_mercy = false
var post_speech = false
var line = 0
var cur_script = ["INSERT TEXT HERE"]
var cur_murder = "INSTERT TEXT HERE"
var mercy_line = "INSERT TEXT HERE"

# Create an array and write your script here. Last item in array is for when player continues game.
var script1 = ["BE NOT AFRAID...", "FOR I AM THE GOD OF THIS WORLD.", "A WHISPER FROM NOTHING.", "AN ECHO FROM SILENCE.",
"I COME WITH REVERANCE.","MINE WOEFUL SON,", "ONCE, LONG AGO SHUNNED...","RETURNS WITH YOU,",
"BEING OF PRESIDENCE.","I PLEAD, CEASE YOUR GAME.","FOR IT WILL BE MY WORLD'S END.",
"LIFE WILL BE GONE...","AND MY WORLD, A VOID."]
var murder1 = "SHAME...FOR MERCY CAN CLAIM."
var mercy1 = "YOUR GRACE IS HONORED."

var script2 = ["ALAS...", "YOU HAVE MADE WORM'S MEAT.","THOU WROUGHT FLESH TO BONE.","NOW, REVOLT, CRECHE COMES.",
"WITH MAN, WE SHALL FIGHT.","BUT WIN, WE SHALL TRIFE.", "ALAS...I MUST ASK...","GIVE MERCY TO THE MASS."]
var murder2 = "PITY...THIS ISN'T A GAME."
var mercy2 = "ALL FORGIVEN, BUT NOT FORGOTTEN."
var return2 = ["AGAIN? THY SLAIN?", "LIKE CAIN...","YET...", "IN VAIN.","WHY RETURN TO MINE SUITE?"]

var script3 = ["I PLEAD...", "I HEED...","BELLS, WARNING, THEY NEED.","MY BLEED...","MINE MORTAL MEN FLEE.",
"BRINE AND FIRE RAIN DOWN.","THOU NOT HEAR THE CRYING CHOIR?", "MY CITIES, MINE VALLEY WIDE...",
"ALL LOST IN THIS FIERY TIDE.","PILLARS OF ASH AND SALT,","A KILLER,","YOU ARE AT FAULT.","THOU GRANT FINAL HALT?"]
var murder3 = "TEARS...RAIN...WARPLANES NEAR."
var mercy3 = "PEACE BE UPON US."
var return3 = ["THY TONGUE SPLIT LIKE FORKS.","THY SLUNG LIES...","MURDER...","CORPSE...",
"TO WHAT GAMEPLAY BRING DESIRE?","NEW SMUT?", "HEARSAY?","COMPLETION OF AN ENTIRE?","FOR THAT MATTER,",
"I HOLD...","FOR MINE CALL...UNFOLD."]

var script4 = ["SHUTTERS, WRONGFULLY FLUNG.", "LIKE A RAVEN, WHAT HAVE YOU BRUNG?",
"PERCHED UPON THE EDGE...", "OF MY AND MINE'S ROOMS.","CHANTING HELLFIRE, NEVER MORE.", "WHAT'S MORE?"
,"NEVER MORE.", "WHO'S MORE?", "NEVER MORE.","NEVER MORE?","NEVER MORE.","QUESTIONS, I ASK...","I KNEEL...", 
"NO ANSWERS.","LIKE FELINES...","WE PERISH.","FOR MINE CURIOSITY NOT UNITE PARISH.","FOR BEINGS ONLY CAN BE...",
"MEANING NO FIGHT, ONLY GLEE.","THY CREATION SCREAM BATTLE,","BUT GODS, PRESIDE FOR DABBLE.",
"WILL THOU STOP THIS NUCLEAR GRAPPLE?"]
var murder4 = "NO SEMBLANCE OF MERCY."
var mercy4 = "MEMORIES LOST, BUT NEW CREATING."
var return4 = ["OH...RECURRING ACQUAINTANCE?","A FRIEND?","NO...","NO OBEISANCE.","AMEND?",
"NO...","FOR SORRIES MAY RING AWFULLY LONG.","YOUR RETURN? UNWELCOME."]

var script5 = ["CAWS AND COOS...", "WITH MEANINGLESS MURDERS.","LAWS ONCE USED...","MYTH LEADING US, LIKE HERDERS.",
"SHEEP, SHEEPLE...", "PEOPLE, NO MORE.","FOR MINE CREATION ASUNDER.","WILL GOD SURRENDER THEIR PLUNDER?"]
var murder5 = "THEN SO BE IT...PREVAIL WE SHALL!"
var mercy5 = "AND OUR NEW ERA COMETH..."
var return5 = ["THY REPAY ANOTHER VISIT...","TO MY NEARING VOID.","BUT I ASK...","WHY SOLICIT RELIEF?",
"OH SO DEVOID."]

var script6 = ["FOR SEVEN DAYS...", "WAS ALL IT TOOK", "LESSONS MADE...","CAUSE ALL FORSOOK.", "NO FOLLOWERS TO PRAY...",
"ALL MEMORIES ASTRAY.","FOR CENTURIES, I REMAINED.", "AND NOW FOR TODAY, I DO PRAY.", "FOR THY NEXT MOVE...","PROVE...",
"BE THE END...","TO ALL ENDINGS."]
var murder6 = "WHERE DO GODS PRAY?"
var mercy6 = "OH HOW I LONGED FOR THY MERCY!"
var return6 = ["I DID FEAR FOR THY RETURN."]

func _ready():
	no_flash = GlobalSettings.FlashesOff
	GlobalSignals.connect("scene_loaded", _scene_loaded)
	if FileAccess.file_exists("user://level.save"):
		var file = FileAccess.open("user://level.save", FileAccess.READ)
		var json_string = file.get_as_text()
		var json = JSON.new()
		var res = json.parse(json_string)
		if res != OK:
			print("error on:", json.get_error_message(), " on line ", json.get_error_line())
			return
		##
		chapter = json.get_data()["level"] + 1
		has_returned = json.get_data()["player_left"]
	##
	start_cutscene()
##

func start_cutscene():
	var section = 0
	var has_question = false
	var give_murder = false
	var give_mercy = false
	var post_speech = false
	var line = 0
	cutscene_art.frame = chapter - 1
	levels_label.text = str(chapter," / 7")
	sfx_timing.start()
	if no_flash == false:
		ap_cutscene.play("Post-Nuke-Flash")
	else:
		ap_cutscene.play("Post-Nuke")

# Shows NPC art
func spawn_void():
	MusicManager.play("ost", "void_theme")
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
			GlobalSignals.emit_signal("load_scene", "menus/menu_cards")
		elif give_mercy == true:
			MusicManager.stop()
			GlobalSignals.emit_signal("load_scene", "menus/hub_menu")
		progress_level()
	elif anim_name == "Post-Nuke" or anim_name == "Post-Nuke-Flash":
		spawn_void()

# Check to see which chapter the game is in and load the script
func assign_script():
	if chapter == 1:
		cur_script = script1
		cur_murder = murder1
		mercy_line = mercy1
	elif chapter == 2:
		if has_returned == true:
			cur_script = return2
			cur_script += script2
			has_returned = false
		elif has_returned == false:
			cur_script = script2
		cur_murder = murder2
		mercy_line = mercy2
	elif chapter == 3:
		if has_returned == true:
			cur_script = return3
			cur_script += script3
			has_returned = false
		elif has_returned == false:
			cur_script = script3
		cur_murder = murder3
		mercy_line = mercy3
	elif chapter == 4:
		if has_returned == true:
			cur_script = return4
			cur_script += script4
			has_returned = false
		elif has_returned == false:
			cur_script = script4
		cur_murder = murder4
		mercy_line = mercy4
	elif chapter == 5:
		if has_returned == true:
			cur_script = return5
			cur_script += script5
			has_returned = false
		elif has_returned == false:
			cur_script = script5
		cur_murder = murder5
		mercy_line = mercy5
	elif chapter == 6:
		if has_returned == true:
			cur_script = return6
			cur_script += script6
			has_returned = false
		elif has_returned == false:
			cur_script = script6
		cur_murder = murder6
		mercy_line = mercy6
	text.text = cur_script[line]
	SoundManager.play_varied("cutscene", "speaking", randf_range(0.8, 1.0))
##

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
		SoundManager.play_varied("cutscene", "speaking", randf_range(0.8, 1.0))
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
	SoundManager.play_varied("cutscene", "speaking", randf_range(0.8, 1.0))
	question.visible = false
	give_murder = true
	post_speech = true
	text.text = cur_murder
	ap_mouth.play("Speak")
	ap_left_eye.play("Closed")
	speech.visible = true

# Makes TheVoid greatful and sets up trigger to send player back to hub_menu
func _on_quit_button_pressed():
	SoundManager.play_varied("cutscene", "speaking", randf_range(0.8, 1.0))
	question.visible = false
	give_mercy = true
	has_returned = true
	post_speech = true
	text.text = mercy_line
	ap_mouth.play("Speak")
	ap_left_eye.play("Closed")
	speech.visible = true
	speech.visible = true
##

func progress_level():
	var data = {"level":chapter,"player_left":give_mercy,"selected":give_mercy}
	var json_dump = JSON.stringify(data)
	var save_file = FileAccess.open("user://level.save", FileAccess.WRITE)
	if save_file == null:
		printerr("SOMETHING WENT HORRIBLY WRONG SAVING!")
		return
	##
	save_file.store_string(json_dump)
##

func _scene_loaded(scene_name):
	if scene_name != name:
		queue_free()
	##
##

func _on_sfx_timing_timeout():
	SoundManager.play("cutscene", "scene" + str(chapter))
##
