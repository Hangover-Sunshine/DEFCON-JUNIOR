extends AudioStreamPlayer

var _fade_tween:Tween

func fade_in(length:float):
	if _fade_tween:
		_fade_tween.kill()
	##
	play()
	_fade_tween = create_tween()
	_fade_tween.tween_method(set_volume, db_to_linear(volume_db), 1.0, length)
##

func fade_out(length:float):
	if _fade_tween:
		_fade_tween.kill()
	##
	_fade_tween = create_tween()
	_fade_tween.tween_method(set_volume, db_to_linear(volume_db), 0, length)
	_fade_tween.chain().tween_callback(stop)
##

func set_volume(vol:float):
	volume_db = linear_to_db(vol)
##
