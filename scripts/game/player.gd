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

@export_category("Cooldowns")
@export var ShieldDuration:float = 2
@export var ShieldCooldown:float = 20
#@export var WeaponType:WeaponProjectileType = WeaponProjectileType.BULLET
@export var WeaponCooldown:float = 3
@export var WeaponPenetration:int = 1
@export var DashStacks:int = 0
@export var DashCooldown:float = 1.2
@export var DashDuration:float = 1.2

@onready var shield_timer = $ShieldTimer
@onready var gun_timer = $GunTimer
@onready var dash_restock_timer = $DashRestockTimer
@onready var dash_timer = $DashTimer
@onready var damaged_timer = $DamagedTimer

# Health Info =========
var curr_health:int

# Movement Info =========
var upgrade_movement:float = 1
var dash_multiplier:float = 1.5

# Shield Info =========
var shield_status:UpgradeAvailability = UpgradeAvailability.NOPE
var curr_shield_cd:float
var curr_shield_dur:float

# Weapon Info =========
var gun_status:UpgradeAvailability = UpgradeAvailability.NOPE
var curr_weapon_cd:float
var curr_weapon_penetration:int

# Dash Info =========
var dash_status:UpgradeAvailability = UpgradeAvailability.READY
var curr_dash_amount:int
var curr_dash_max:int = 2
var curr_dash_cd:float
var curr_dash_dur:float

func _ready():
	curr_health = Health
	
	curr_shield_cd = ShieldCooldown
	curr_shield_dur = ShieldDuration
	
	curr_weapon_cd = WeaponCooldown
	curr_weapon_penetration = WeaponPenetration
	
	curr_dash_amount = DashStacks
	curr_dash_cd = DashCooldown
	curr_dash_dur = DashDuration
##

func _process(delta):
	if Input.is_action_just_pressed("shield") and shield_status == UpgradeAvailability.READY:
		shield_status = UpgradeAvailability.ACTIVE
		shield_timer.start(curr_shield_dur)
	##
	
	if Input.is_action_just_pressed("fire") and gun_status == UpgradeAvailability.READY:
		print("fire!")
		gun_status = UpgradeAvailability.RECHARGING
		gun_timer.start(curr_weapon_cd)
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
	else:
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
	
	damaged_timer.start(TimeToNextDamage)
##

func _on_shield_timer_timeout():
	if shield_status == UpgradeAvailability.ACTIVE:
		shield_timer.start(curr_shield_cd)
		shield_status = UpgradeAvailability.RECHARGING
	else:
		shield_status = UpgradeAvailability.READY
	##
##

func _on_shield_area_area_entered(area):
	area.hit()
##

func _on_gun_timer_timeout():
	gun_status = UpgradeAvailability.READY
##

func _on_dash_restock_timer_timeout():
	if curr_dash_amount < curr_dash_max:
		dash_restock_timer.start(DashCooldown)
	##
	curr_dash_amount += 1
##
