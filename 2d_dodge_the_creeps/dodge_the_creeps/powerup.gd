extends RigidBody2D

var powerupSpawned: bool = false;
var powerupActive: bool = false;

func _ready() -> void:
	remove_powerup()

func add_powerup(t_position) -> void:
	powerupSpawned = true;
	position = t_position;

func remove_powerup() -> void:
	powerupSpawned = false;
	position = Vector2(-100,-100);

func get_powerup_spawned_status() -> bool:
	return powerupSpawned;

func get_powerup_active_status() -> bool:
	return powerupActive;
