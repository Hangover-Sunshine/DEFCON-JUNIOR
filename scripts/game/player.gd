extends CharacterBody2D
class_name Player

enum UpgradeAvailability {
	NOPE,
	READY,
	ACTIVE,
	RECHARGING
}

@export var BaseMovementSpeed:float = 350
@export var Health:int = 3

@export var TimeToNextDamage:float = 0.8

@export_group("Shield")
@export var ShieldDuration:float = 2
@export var ShieldCooldown:float = 20

@export_group("Movement")
@export var DashMovementIncrease:float = 1.5
@export var DashCooldown:float = 1.2
@export var DashDuration:float = 1.2

@export_group("Weapons")
@export var Weapon:WeaponResource

@onready var shield_timer = $ShieldTimer
@onready var gun_timer = $GunTimer
@onready var dash_restock_timer = $DashRestockTimer
@onready var dash_timer = $DashTimer
@onready var damaged_timer = $DamagedTimer
@onready var reload_timer = $ReloadTimer

const PROJECTILE = preload("res://prefabs/entities/projectile.tscn")

# Health Info =========
var curr_health:int

# Shield Info =========
var shield_status:UpgradeAvailability = UpgradeAvailability.NOPE
var curr_shield_cd:float
var curr_shield_dur:float
@onready var shield = $ShieldArea/CollisionShape2D

# Weapon Info =========
var gun_status:UpgradeAvailability = UpgradeAvailability.NOPE
var curr_weapon_penetration:int = 0
var curr_number_of_bullets:int = 0
var curr_mag_size:int = 0
var max_mag_size:int = 0

# Dash Info =========
var dash_status:UpgradeAvailability = UpgradeAvailability.READY
var curr_dash_amount:int = 0
var curr_dash_max:int = 0

var play_area_size:Vector2

var has_control:bool = true

func _ready():
	if FileAccess.file_exists("user://player.save"):
		var file = FileAccess.open("user://player.save", FileAccess.READ)
		var json_string = file.get_as_text()
		var json = JSON.new()
		var res = json.parse(json_string)
		if res != OK:
			print("error on:", json.get_error_message(), " on line ", json.get_error_line())
			return
		##
		var data = json.get_data()
		
		curr_health = data.health
		
		shield_status = UpgradeAvailability.READY if data["shield"]["has"] else UpgradeAvailability.NOPE
		curr_shield_cd = data["shield"]["cd"]
		curr_shield_dur = data["shield"]["dur"]
		
		gun_status = UpgradeAvailability.READY if data["gun"]["has"] else UpgradeAvailability.NOPE
		curr_weapon_penetration = data["gun"]["pen"]
		max_mag_size = data["gun"]["mag"]
		curr_mag_size = max_mag_size
		curr_number_of_bullets = data["gun"]["bullets"]
		
		dash_status = UpgradeAvailability.READY if data["dash"]["has"] else UpgradeAvailability.NOPE
		curr_dash_max = data["dash"]["stack"]
		curr_dash_amount = curr_dash_max
	else:
		curr_health = Health
		
		curr_shield_dur = 0
		curr_shield_cd = 0
		
		curr_weapon_penetration = 1
		max_mag_size = 0
		curr_mag_size = max_mag_size
		curr_number_of_bullets = 0
		
		curr_dash_max = 1
		curr_dash_amount = curr_dash_max
	##
	
	play_area_size = get_parent().get_play_area_x_limits()
##

func _process(_delta):
	if has_control == false:
		return
	##
	
	if Input.is_action_just_pressed("shield") and shield_status == UpgradeAvailability.READY:
		shield_status = UpgradeAvailability.ACTIVE
		shield_timer.start(curr_shield_dur)
		shield.disabled = false
	##
	
	if Input.is_action_pressed("fire") and gun_timer.is_stopped() and gun_status == UpgradeAvailability.READY:
		_spawn_bullets()
		curr_mag_size -= 1
		
		if curr_mag_size == 0:
			gun_status = UpgradeAvailability.RECHARGING
			reload_timer.start(Weapon.ReloadRate)
			return
		##
		
		gun_timer.start(Weapon.FireRate)
	elif Input.is_action_just_released("fire") or gun_status == UpgradeAvailability.RECHARGING:
		gun_timer.stop()
	##
	
	if Input.is_action_just_pressed("dash") and dash_status == UpgradeAvailability.READY\
		and curr_dash_amount > 0 and velocity.length_squared() > 0:
		dash_timer.start(DashDuration)
		$PC_Skeleton.boost()
		curr_dash_amount -= 1
		if curr_dash_amount == 0:
			dash_status = UpgradeAvailability.RECHARGING
		##
		if dash_restock_timer.is_stopped():
			dash_restock_timer.start(DashCooldown)
		##
	##
	
	if dash_timer.is_stopped() and curr_health > 0:
		$PC_Skeleton.normal()
	##
##

func _physics_process(_delta):
	if has_control == false:
		return
	##
	
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	direction = direction.normalized()
	
	if direction.x != 0:
		velocity.x = direction.x * BaseMovementSpeed
		if direction.x > 0:
			$PC_Skeleton.to_right()
		elif direction.x < 0:
			$PC_Skeleton.to_left()
	else:
		$PC_Skeleton.to_notmove()
		velocity.x = move_toward(velocity.x, 0, BaseMovementSpeed)
	##
	
	if direction.y != 0:
		velocity.y = direction.y * BaseMovementSpeed
	else:
		velocity.y = move_toward(velocity.y, 0, BaseMovementSpeed)
	##
	
	if dash_timer.is_stopped() == false:
		velocity *= DashMovementIncrease
	##
	
	move_and_slide()
	
	if global_position.x < play_area_size.x + 30:
		global_position.x = play_area_size.x + 30
	elif global_position.x > play_area_size.y - 30:
		global_position.x = play_area_size.y - 30
	##
	
	if global_position.y < 1080 * 0.05:
		global_position.y = 1080 * 0.05
	elif global_position.y > 1080 * 0.85:
		global_position.y = 1080 * 0.85
##

func hit():
	if damaged_timer.is_stopped() == false:
		return
	##
	
	curr_health -= 1
	
	if curr_health <= 0:
		GlobalSignals.emit_signal("player_died")
		$PC_Skeleton.die()
		return
	##
	
	$PC_Skeleton.to_pain()
	damaged_timer.start(TimeToNextDamage)
##

func _on_shield_timer_timeout():
	if shield_status == UpgradeAvailability.ACTIVE:
		shield.disabled = true
		shield_timer.start(curr_shield_cd)
		shield_status = UpgradeAvailability.RECHARGING
	else:
		shield_status = UpgradeAvailability.READY
	###
##

func _on_shield_area_area_entered(area):
	area.hit()
##

func _on_gun_timer_timeout():
	_spawn_bullets()
	curr_mag_size -= 1
	
	if curr_mag_size == 0:
		gun_status = UpgradeAvailability.RECHARGING
		reload_timer.start(Weapon.ReloadRate)
		return
	##
	
	gun_timer.start(Weapon.FireRate)
##

func _spawn_bullets():
	$PC_Skeleton.shoot()
	
	if curr_number_of_bullets == 1:
		for i in range(curr_number_of_bullets):
			var projectile = PROJECTILE.instantiate()
			projectile.z_index = 4
			projectile.penetration = curr_weapon_penetration
			GlobalSignals.emit_signal("spawn_bullet", projectile)
			projectile.setup(Weapon.BulletSpeed, 8, 4, 5)
			projectile.global_position = $BulletSpawnPos.global_position
			projectile.velocity = Weapon.BulletSpeed * Vector2.DOWN.rotated(projectile.rotation)
		##
	else:
		for i in range(curr_number_of_bullets):
			var projectile = PROJECTILE.instantiate()
			projectile.z_index = 4
			projectile.penetration = curr_weapon_penetration
			GlobalSignals.emit_signal("spawn_bullet", projectile)
			projectile.setup(Weapon.BulletSpeed, 8, 4, 5)
			projectile.global_position = $BulletSpawnPos.global_position
			var arc_rad = deg_to_rad(Weapon.DegreeAngleOfCone)
			var increment = arc_rad / (curr_number_of_bullets - 1)
			projectile.rotation = increment * i - arc_rad / 2
			projectile.velocity = Weapon.BulletSpeed * Vector2.DOWN.rotated(projectile.rotation)
		##
	##
##

func _on_dash_restock_timer_timeout():
	curr_dash_amount += 1
	dash_status = UpgradeAvailability.READY
	if curr_dash_amount < curr_dash_max:
		dash_restock_timer.start(DashCooldown)
	##
##

func _on_damaged_timer_timeout():
	$PC_Skeleton.to_happy()
##

func _on_reload_timer_timeout():
	curr_mag_size = max_mag_size
	gun_status = UpgradeAvailability.READY
##

func lean_left():
	$PC_Skeleton.to_left()
##

func lean_right():
	$PC_Skeleton.to_right()
##

func do_nothing():
	$PC_Skeleton.to_notmove()
##

func get_data():
	var data = {}
	data["health"] = Health
	
	data["shield"] = {}
	data["shield"]["has"] = shield_status != UpgradeAvailability.NOPE
	data["shield"]["dur"] = curr_shield_dur
	data["shield"]["cd"] = curr_shield_cd
	
	data["gun"] = {}
	data["gun"]["has"] = gun_status != UpgradeAvailability.NOPE
	data["gun"]["pen"] = curr_weapon_penetration
	data["gun"]["mag"] = max_mag_size
	data["gun"]["bullets"] = curr_number_of_bullets
	
	data["dash"] = {}
	data["dash"]["has"] = dash_status != UpgradeAvailability.NOPE
	data["dash"]["stack"] = curr_dash_max
	
	return data
##
