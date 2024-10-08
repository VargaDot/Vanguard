class_name Armature
extends Node

@export_group("Weapon Stats")
@export var fire_rate:int
@export var mag_size:int
@export var max_ammo:int
@export var reload_time:int
@export var reload_time_empty:int
@export var recoil:int
@export var payload:PackedScene # Place a bullet, melee weapon ext...
@export_enum("Automatic", "Semi", "Burst") var fire_mode:int

@export_group("Noise Stats")
@export var noise_field:PackedScene
@export var has_silencer:bool
@export var noise_radius:int

@export_group("Payload Stats")
@export_enum("Projectile", "Melee") var payload_type:int
@export var damage:int
@export var accuracy:float # 1.0 very accurate / 0.0 complete trash
@export var max_spread:int # the maximum angle in which the bullet the launched when at 0 accuracy
@export var p_range:int # to evade warning "The variable "range" has the same name as a built-in function."
@export var speed:int
@export var knockback:int
@export var crit_chance:int

@export_group("Payload Field Stats")
@export var radius:int
@export var propagation_speed:float # speed at which a field expands and reaches its max radius
@export var field_fade_time:int # time it takes for the field to be removed once it reached its full radius

var TIMER:Timer
func _ready() -> void:
	if (payload == null):
		print("Payload undefined, please set a bullet or a melee weapon")
		return
	TIMER = $Timer

var current_ammo:int = max_ammo
var current_mag:int = mag_size
var current_state:int = WEAPON_STATE.READY
enum WEAPON_STATE {
	READY,
	SHOOTING,
	RELOADING,
}

func _shoot() -> void:
	if (current_mag == 0):
		_reload()
	if (current_state != WEAPON_STATE.READY):
		return
	
	current_state = WEAPON_STATE.SHOOTING
	TIMER.wait_time = fire_rate
	payload.instantiate()
	payload._configure_payload(
		damage,
		accuracy,
		max_spread,
		p_range,
		radius,
		propagation_speed,
		field_fade_time,
		speed,
		knockback,
		crit_chance
	)
	current_mag -= 1
	
	TIMER.start()
	

func _reload() -> void:
	if (current_mag == mag_size && current_ammo == 0 || current_state != WEAPON_STATE.READY):
		return
	
	current_state = WEAPON_STATE.RELOADING
	
	if (current_mag == 0):
		TIMER.wait_time = reload_time + reload_time_empty
	else:
		TIMER.wait_time = reload_time
	
	var ammo_to_load = min(mag_size - current_mag, current_ammo)
	current_ammo -= ammo_to_load
	current_mag += ammo_to_load
	
	TIMER.start()

func _on_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
