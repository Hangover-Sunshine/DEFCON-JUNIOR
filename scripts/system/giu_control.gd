extends Control

@onready var health_label = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Health_HBox/Label
@onready var spitfire_cooldown = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Spitfire_HBox/Spitfire_Ability/Spitfire_Cooldown
@onready var bubble_cooldown = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Bubble_HBox/Bubble_Ability/Bubble_Cooldown
@onready var boost_cooldown = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Boost_HBox/Boost_Ability/Boost_Cooldown

var player:Player

func _process(delta):
	if player.gun_status == player.UpgradeAvailability.RECHARGING:
		spitfire_cooldown.value = 100 * (player.reload_timer.time_left / player.Weapon.ReloadRate)
	elif player.gun_status == player.UpgradeAvailability.READY:
		spitfire_cooldown.value = 0
	##
	
	if player.dash_status == player.UpgradeAvailability.RECHARGING:
		boost_cooldown.value = 100 * (player.dash_restock_timer.time_left / player.DashCooldown)
	elif player.dash_status == player.UpgradeAvailability.READY:
		boost_cooldown.value = 0
	##
	
	if player.shield_status == player.UpgradeAvailability.RECHARGING:
		bubble_cooldown.value = 100 * (player.shield_timer.time_left / player.ShieldCooldown)
	elif player.shield_status == player.UpgradeAvailability.READY:
		bubble_cooldown.value = 0
	##
	
	health_label.text = str(player.curr_health)
##
