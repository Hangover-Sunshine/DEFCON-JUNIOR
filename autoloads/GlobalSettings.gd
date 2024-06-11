extends Node

const SAVE_LOCATION = "user://game_settings.config"

var config:ConfigFile

var MasterVolume:float = 1
var UiSFXVolume:float = 0.8
var GameSFXVolume:float = 0.8
var MusicVolume:float = 0.6

var FullScreen:bool = false
var FlashesOff:bool = false

var os_type:String

func _ready():
	# get all native data
	os_type = OS.get_name()
	# get all native data
	
	if os_type == "Web":
		var p = InputEventKey.new()
		p.physical_keycode = KEY_P
		InputMap.action_erase_events("pause")
		InputMap.action_add_event("pause", p)
	##
	
	config = ConfigFile.new()
	
	# if it exists, load whatever we haved saved
	if FileAccess.file_exists(SAVE_LOCATION):
		config.load(SAVE_LOCATION)
		
		MasterVolume = config.get_value("volume", "master")
		UiSFXVolume = config.get_value("volume", "ui_sfx")
		GameSFXVolume = config.get_value("volume", "game_sfx")
		MusicVolume = config.get_value("volume", "music")
		
		FullScreen = config.get_value("screen", "fullscreen")
		FlashesOff = config.get_value("screen", "flashes_off")
		
		var bus = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(bus, linear_to_db(MusicVolume))
		
		bus = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(bus, linear_to_db(UiSFXVolume))
		
		bus = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(bus, linear_to_db(GlobalSettings.MasterVolume))
		
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
	config.set_value("screen", "flashes_off", FlashesOff)
	
	config.save(SAVE_LOCATION)
##
