extends Resource

## Base class for gun addons/attachments modifiers.
##
## To create a new kit (or attachment), create a custom resource and assign it this script.
## Simply write a percentage and modify_weapon_stats will take care of the math,
## your only limitation is how much the float type can handle.

## The percentage by which to increase or decrease the size of the magazine.
@export var mag_size_modifier:float
## The percentage by which to increase or decrease the maximum ammunition.
@export var max_ammo_modifier:float
## The percentage by which to increase or decrease the reload speed.
@export var reload_time_modifier:float
## The percentage by which to increase or decrease the reload speed when the magazine is empty.
## (reload time + reload time empty = actual reload time).
@export var reload_time_empty_modifier:float
## The percentage by which to increase or decrease the rate of fire.
@export var fire_rate_modifier:float
