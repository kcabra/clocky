extends Camera2D

signal level_changed
const SCREEN_HEIGHT = 720
const PLAYER_NODE_NAME = "player_run"

func _on_newlevel_collided(collider, ground_position):
	if collider.name == PLAYER_NODE_NAME:
		follow_player(ground_position)

func follow_player(ground):
	emit_signal("level_changed")
	position.y = lerp(ground.y, ground.y - SCREEN_HEIGHT, 0.5)
