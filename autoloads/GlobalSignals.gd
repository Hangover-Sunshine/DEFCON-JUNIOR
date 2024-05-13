extends Node

# System Loading ###################################################
signal load_scene(next_scene:String)
signal scene_loaded(new_scene:String)
signal scene_transition_started
signal scene_transition_done
# System Loading ###################################################

signal player_died

signal spawn_bullet(bullet:Projectile)
signal rand_point_request(missile:Missile)
