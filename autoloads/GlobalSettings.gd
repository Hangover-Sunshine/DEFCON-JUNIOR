extends Node

const SAVE_LOCATION = "user://game_settings.json"

var config:ConfigFile

var MasterVolume:float = 1
var UiSFXVolume:float = 0.8
var GameSFXVolume:float = 0.8
var MusicVolume:float = 0.6

var FullScreen:bool = false
var Hints:bool = false

var os_type:String

func _ready():
	# get all native data
	os_type = OS.get_name()
	# get all native data
	
	config = ConfigFile.new()
	
	# if it exists, load whatever we haved saved
	if FileAccess.file_exists(SAVE_LOCATION):
		config.load(SAVE_LOCATION)
		
		MasterVolume = config.get_value("volume", "master")
		UiSFXVolume = config.get_value("volume", "ui_sfx")
		GameSFXVolume = config.get_value("volume", "game_sfx")
		MusicVolume = config.get_value("volume", "music")
		
		FullScreen = config.get_value("screen", "fullscreen")
		
		return
	##
	
	save_settings()
##

func save_settings():
	# otherwise, save a new config file with our defaults in place
	config.set_value("volume", "master", MasterVolume)
	config.set_value("volume", "ui_sfx", UiSFXVolume)
	config.set_value("volume", "game_sfx", GameSFXVolume)
	config.set_value("volume", "music", MusicVolume)
	
	config.set_value("screen", "fullscreen", FullScreen)
	
	config.save(SAVE_LOCATION)
##
