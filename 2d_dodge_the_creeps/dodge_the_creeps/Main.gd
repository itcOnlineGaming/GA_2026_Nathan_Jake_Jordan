extends Node

@export var mob_scene: PackedScene
@export var powerup: RigidBody2D
@export var player: Area2D
var score

#Var to print
var player_speed = 0;
var enemy_speed = 100.0;
var time_count = 0.0;
var powerup_spawn_timer = 30.0;

var powerup_timer_hard = 15;
var powerup_timer_medium = 10;
var timer_picked = 0;

func get_score_timer():
	var score_timer: Timer = $ScoreTimer
	time_count = score
	print(time_count);
	
func change_var_on_conditions():
	powerup_spawn_timer = timer_picked;


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	get_score_timer();
	write_statistics();

func write_statistics():
	var path = "user://statistics.csv"
	print(OS.get_user_data_dir())
	#var file = FileAccess.open("res://statistics.csv", FileAccess.WRITE)
	var file = FileAccess;
	# Check if file path is valid
	if (FileAccess.file_exists(path)):
		file = FileAccess.open(path, FileAccess.READ_WRITE);
		file.seek_end(); # Go to end of file
	else:
		file = FileAccess.open(path, FileAccess.WRITE)
		file.store_csv_line(["Timestamp", "Condition", "Survival", "ValueTime", "Powerup", "ValuePowerup"]) # Heading
	
	var run_id : int = Time.get_unix_time_from_system();

	
	# Timers
	if (timer_picked == 15.0):
		file.store_csv_line([run_id, "A", "Survival Time", time_count, "Powerup Timer rate", powerup_spawn_timer])
	else:
		file.store_csv_line([run_id, "B", "Survival Time", time_count, "Powerup Timer rate", powerup_spawn_timer])
	
	file.close()


func _process(_delta):
	player_collecting_powerup()


func new_game():
	get_tree().call_group(&"mobs", &"queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	powerup.remove_powerup();
	timer_picked = choose_a_or_b(powerup_timer_hard, powerup_timer_medium);
	change_var_on_conditions();

func choose_a_or_b(a, b):
	return a if randi() % 2 == 0 else b


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	mob_spawn_location.progress = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var minSpeed = 150.0;
	var maxSpeed = 250.0;
	if (powerup.powerupActive):
		minSpeed -= 50;
		maxSpeed -= 50;
	var velocity = Vector2(randf_range(minSpeed, maxSpeed), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	if (powerup.powerupSpawned):
		powerup.powerupTime += 1;
		if (powerup.powerupTime == 6):
			powerup.powerupSpawned = false;
	elif (score % 5 == 0 && score != 0 && !powerup.powerupSpawned):
		var powerupPos = Vector2(240,360); 
		powerup.add_powerup(powerupPos);


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func player_collecting_powerup() -> void:
	if (player.position.x >= powerup.position.x && player.position.x <= powerup.position.x + 32 &&
		player.position.y >= powerup.position.y && player.position.y <= powerup.position.y + 32):
		powerup.remove_powerup()
		powerup.powerupActive = true;
