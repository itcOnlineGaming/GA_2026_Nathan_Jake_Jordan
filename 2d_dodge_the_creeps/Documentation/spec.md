Game Spec:
Player moves the character and must avoid the enemies that are spawned in from offscreen and move in a random direction. The player's goal is to survive for the longest possible time.

Powerup:
Player can collect a powerup that can assist with their survival. This slows down the enemies that are currently on screen and allows the player to navigate around the enemies easier, thus avoiding being killed.

Tasks:
- Jake
	Create the timing variable that is assigned either 15 ( Condition A ) or 10 ( Condition B ) at random everytime the game is started.
	Write the data that was recorded to a CSV file that can be used later for measuring the different results.
	EXAMPLE: file.store_csv_line(["Timestamp", "Condition", "Survival", "ValueTime", "Powerup", "ValuePowerup"]) # Header row data