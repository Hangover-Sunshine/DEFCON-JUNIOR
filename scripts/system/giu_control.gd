extends Control

@onready var health_label = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Health_HBox/Label
@onready var spitfire_cooldown = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Spitfire_HBox/Spitfire_Ability/Spitfire_Cooldown
@onready var bubble_cooldown = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Bubble_HBox/Bubble_Ability/Bubble_Cooldown
@onready var boost_cooldown = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Boost_HBox/Boost_Ability/Boost_Cooldown
@onready var v_slider = $GIU_MC/GIU_HBox/Right_MC/HBoxContainer/VSlider

@onready var spitfire_h_box = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Spitfire_HBox
@onready var boost_h_box = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Boost_HBox
@onready var bubble_h_box = $GIU_MC/GIU_HBox/Left_MC/Left_VBox/Abilities_VBox/Bubble_HBox

var player:Player
var level_timer:Timer

func late_ready():
	spitfire_h_box.visible = player.gun_status == player.UpgradeAvailability.READY
	boost_h_box.visible = player.dash_status == player.UpgradeAvailability.READY
	bubble_h_box.visible = player.shield_status == player.UpgradeAvailability.READY
##

func _process(delta):
	if player.gun_status == player.UpgradeAvailability.RECHARGING:
		spitfire_cooldown.value = 100 * (player.reload_timer.time_left / player.ReloadRate)
	elif player.gun_status == player.UpgradeAvailability.READY:
		spitfire_cooldown.value = 0
	##
	
	if player.dash_status == player.UpgradeAvailability.RECHARGING:
		boost_cooldown.value = 100 * (player.dash_restock_timer.time_left / player.DashCooldown)
	elif player.dash_status == player.UpgradeAvailability.READY:
		boost_cooldown.value = 0
	##
	
	if player.shield_status == player.UpgradeAvailability.RECHARGING or player.shield_status == player.UpgradeAvailability.ACTIVE:
		bubble_cooldown.value = 100 * (player.shield_restock_timer.time_left / player.curr_shield_cd)
	elif player.shield_status == player.UpgradeAvailability.READY:
		bubble_cooldown.value = 0
	##
	
	health_label.text = str(player.curr_health)
	v_slider.value = 100 * (level_timer.time_left / level_timer.wait_time)
##
