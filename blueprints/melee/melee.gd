class_name Melee extends Node2D

## Base class for melee weapons
##
## The Melee class represents a weapon system in a 2D game using Godot's Node structure.
## It manages weapon stats such as "INSERT NO DOCUMENTATION HERE".
## This class is designed to handle various weapon functionalities, including attacking and recovering.

@export_group("Melee Stats")
@export var base_stats:MeleeStatKit:
	set(val):
		if val:
			attack_rate = val.attack_rate
			recovery_rate = val.recovery_time
			base_stats = val

@export_group("Melee Emissions")
## Slot for field
@export var field:PackedScene
## Slot for projectile
@export var projectile:PackedScene

## The time it takes in Milliseconds to be in the attacking phase
var attack_rate:float
## The time it takes in Milliseconds to be in the recovery phase
var recovery_rate:float

## Emitted when current_state is changed
signal state_updated()
## Emitted when current_state is ready
signal weapon_ready()
## Emitted when current_state is attacking
signal weapon_attacking()
## Emitted when current_state is recovering
signal weapon_recovering()
## Emitted when a MeleeStatKit is equipped
signal stat_kit_equipped(kit:MeleeStatKit)
## Emitted when a MeleeStatKit is unequipped
signal stat_kit_unequipped(kit:MeleeStatKit)
## Emitted when a RangedEmissionKit is equipped
signal emission_kit_equipped(kit:RangedEmissionKit)

## Represents the current state of the weapon.
## It can be one of the states defined in the WEAPON_STATE enum.
var current_state:int = WEAPON_STATE.INITIALIZE :
	set(val):
		current_state = val
		state_updated.emit(_enum_to_str(current_state))

		match current_state:
			WEAPON_STATE.READY: weapon_ready.emit()
			WEAPON_STATE.ATTACKING: weapon_attacking.emit()
			WEAPON_STATE.RECOVERING: weapon_recovering.emit()
			_: print("Invalid state: %s" %[current_state])

enum WEAPON_STATE {
	## The weapon system is being initialized
	INITIALIZE = 0,
	## The weapon is ready to attack or recover.
	READY = 1,
	## The weapon is charging
	CHARGING = 2,
	## The weapon is attacking.
	ATTACKING = 3,
	## The weapon is recovering.
	RECOVERING = 4,
}

func _init() -> void:
	pass

## Handles the weapon's attacking mechanism.
## If the weapon is currently attacking or recovering, it exits without attacking.
func attack() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.ATTACKING

## Handles the weapon's recovery mechanism.
## If the weapon is currently attacking or recovering, it exits without recovering.
func recover() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.RECOVERING

## A list containing the names of currently equipped modifications
var equipped_kits:Array[String]
## Modifies weapon stats by providing a kit.
func equip_stat_kit(kit:MeleeStatKit) -> void:
	if has_stat_kit(kit):
		print("kit already installed")
		return

	equipped_kits.append(kit.kit_name)
	attack_rate += kit.attack_rate if kit.attack_rate_modifier != 0 else attack_rate
	recovery_rate += kit.recovery_rate_modifier if kit.recovery_rate_modifier !=0 else recovery_rate

	stat_kit_equipped.emit(kit)

## Reverses the changes made by equip_kit
func unequip_stat_kit(kit:MeleeStatKit) -> void:
	equipped_kits.erase(kit.kit_name)
	attack_rate -= kit.attack_rate_modifier
	recovery_rate -= kit.recovery_rate_modifier

	stat_kit_unequipped.emit(kit)

func has_stat_kit(kit: MeleeStatKit) -> bool:
	for kit_equipped in equipped_kits:
		if (kit_equipped == kit.kit_name):
			return true

	return false

## Changes the weapon's emissions, null variables will be ignored.
func equip_emission_kit(kit:RangedEmissionKit) -> void:
	if (kit.new_projectile != null):
		projectile = kit.new_projectile
	else:
		print("Null projectile detected, New projectile rejected...")

	if (kit.new_field != null):
		field = kit.new_field
	else:
		print("Null field detected, New field rejected...")

	emission_kit_equipped.emit(kit)

func _enum_to_str(state: int) -> String:
	match state:
		0:
			return "INITILIAZING"
		1:
			return "READY"
		2:
			return "CHARGING"
		3:
			return "ATTACKING"
		4:
			return "RECOVERING"
		_:
			return "ERROR"
