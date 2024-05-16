extends Node2D

const INDICATOR = preload("res://prefabs/systems/indicator.tscn")

var missile_2_indicator:Dictionary = {}

func _show_indicator(missile:Missile):
	if missile in missile_2_indicator.keys():
		missile_2_indicator[missile].show_indicator()
	else:
		var indicator = INDICATOR.instantiate()
	##
##

func _hide_indicator(missile:Missile):
	pass
##

func _delete_indicator(missile:Missile):
	pass
##
