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
@export var DashStacks:int = 0
@export var DashCooldown:float = 1.2
@export var DashDuration:float = 1.2

@export_group("Weapons")
@export var Weapon:WeaponResource
@export var WeaponPenetration:int = 1

@onready var shield_timer = $ShieldTimer
@onready var gun_timer = $GunTimer
@onready var dash_restock_timer = $DashRestockTimer
@onready var dash_timer = $DashTimer
@onready var damaged_timer = $DamagedTimer
@onready var reload_timer = $ReloadTimer

const PROJECTILE = preload("res://prefabs/entities/projectile.tscn")

# Health Info =========
var curr_health:int

# Movement Info =========
var upgrade_movement:float = 1
var dash_multiplier:float = 1.5

# Shield Info =========
var shield_status:UpgradeAvailability = UpgradeAvailability.NOPE
var curr_shield_cd:float
var curr_shield_dur:float
var shield_stack:int
var max_shield_stack:int = 0
@onready var shield = $ShieldArea/CollisionShape2D

# Weapon Info =========
var gun_status:UpgradeAvailability = UpgradeAvailability.NOPE
var curr_weapon_fr:float = 0
var curr_reload_rate:float = 0
var curr_weapon_penetration:int
var curr_number_of_bullets:int

# Dash Info =========
var dash_status:UpgradeAvailability = UpgradeAvailability.NOPE
var curr_dash_amount:int
var curr_dash_max:int = 2
var curr_dash_cd:float
var curr_dash_dur:float

var play_area_size:Vector2

func _ready():
	curr_health = Health
	
	curr_shield_cd = ShieldCooldown
	curr_shield_dur = ShieldDuration
	
	curr_weapon_fr = Weapon.FireRate
	curr_weapon_penetration = WeaponPenetration
	curr_number_of_bullets = Weapon.MagSize
	
	curr_dash_amount = DashStacks
	curr_dash_cd = DashCooldown
	curr_dash_dur = DashDuration
	
	play_area_size = get_parent().get_play_area_x_limits()
##

func _process(_delta):
	if Input.is_action_just_pressed("shield") and shield_stack > 0:
		shield_status = UpgradeAvailability.ACTIVE
		shield_stack -= 1
		shield_timer.start(curr_shield_dur)
		shield.disabled = false
	##
	
	if Input.is_action_pressed("fire") and gun_timer.is_stopped() and gun_status == UpgradeAvailability.READY:
		_spawn_bullets()
		curr_number_of_bullets -= 1
		
		if curr_number_of_bullets == 0:
			gun_status = UpgradeAvailability.RECHARGING
			reload_timer.start(Weapon.ReloadRate * (1 + curr_reload_rate))
			return
		##
		
		gun_timer.start(curr_weapon_fr)
	elif Input.is_action_just_released("fire") or gun_status == UpgradeAvailability.RECHARGING:
		gun_timer.stop()
	##
	
	if Input.is_action_just_pressed("dash") and dash_status == UpgradeAvailability.READY\
		and curr_dash_amount > 0 and velocity.length_squared() > 0:
		dash_timer.start(DashDuration)
		curr_dash_amount -= 1
		if dash_restock_timer.is_stopped():
			dash_restock_timer.start(DashCooldown)
		##
	##
##

func _physics_process(_delta):
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
	
	velocity *= upgrade_movement
	
	if dash_timer.is_stopped() == false:
		velocity *= dash_multiplier
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
		# play player's death anims + sounds + particles
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
	curr_number_of_bullets -= 1
	
	if curr_number_of_bullets == 0:
		gun_status = UpgradeAvailability.RECHARGING
		reload_timer.start(Weapon.ReloadRate * (1 + curr_reload_rate))
		return
	##
	
	gun_timer.start(curr_weapon_fr)
##

func _spawn_bullets():
	var projectiles = []
	$PC_Skeleton.shoot()
	
	if Weapon.UseSpeedVariance == false:
		for i in range(Weapon.BulletsSpawnedPerFire):
			var projectile = PROJECTILE.instantiate()
			projectile.z_index = 4
			GlobalSignals.emit_signal("spawn_bullet", projectile)
			projectile.setup(Weapon.BulletSpeed, 8, 4, 5)
			projectile.global_position = $BulletSpawnPos.global_position
			var arc_rad = deg_to_rad(Weapon.DegreeAngleOfCone)
			var increment = arc_rad / (Weapon.BulletsSpawnedPerFire - 1)
			projectile.rotation = increment * i - arc_rad / 2
			projectile.velocity = Weapon.BulletSpeed * Vector2.DOWN.rotated(projectile.rotation)
			
			projectiles.push_back(projectile)
		##
	else:
		for i in range(Weapon.BulletsSpawnedPerFire):
			var projectile = PROJECTILE.instantiate()
			GlobalSignals.emit_signal("spawn_bullet", projectile)
			projectile.setup(0, 8, 4, 5)
			projectile.global_position = $BulletSpawnPos.global_position
			var speed = Weapon.BulletSpeed + Weapon.BulletSpeed *\
								randf_range(-Weapon.BulletSpeedVariance, Weapon.BulletSpeedVariance)
			var arc_rad = deg_to_rad(Weapon.DegreeAngleOfCone)
			var increment = arc_rad / (Weapon.BulletsSpawnedPerFire - 1)
			projectile.rotation = increment * i - arc_rad / 2
			projectile.velocity = speed * Vector2.DOWN.rotated(projectile.rotation)
			
			projectiles.push_back(projectile)
		##
	##
##

func _on_dash_restock_timer_timeout():
	if curr_dash_amount < curr_dash_max:
		dash_restock_timer.start(DashCooldown)
	##
	curr_dash_amount += 1
##

func _on_damaged_timer_timeout():
	$PC_Skeleton.to_happy()
##

func _on_reload_timer_timeout():
	if Weapon.ExpendAllToReload:
		curr_number_of_bullets = Weapon.MagSize
	else:
		curr_number_of_bullets += 1
		if curr_number_of_bullets < Weapon.MagSize:
			reload_timer.start(Weapon.ReloadRate * (1 + curr_reload_rate))
		##
	##
	
	gun_status = UpgradeAvailability.READY
##

func apply_upgrade(upgrade:String, amount):
	match upgrade:
		"dash":
			pass
		"dash_dur":
			pass
		"dash_cd":
			pass
		"shield":
			pass
		"shield_cd":
			pass
		"shield_dur":
			pass
		"gun":
			pass
		"gun_cd":
			pass
		"gun_spray":
			pass
		"gun_penetration":
			pass
		##
	##
##

func apply_weapon(new_weapon:WeaponResource):
	Weapon = new_weapon
##

func reset_character():
	# TODO: reset all stats
	pass
##
