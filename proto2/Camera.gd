extends Camera2D

const SCREEN_HEIGHT = 720
const PLAYER_NODE_NAME = "player_run"

func _on_newlevel_collided(collider, ground_position):
    print_debug(collider.name + " collided with newlevel")
    if collider.name == PLAYER_NODE_NAME:
        follow_player(ground_position)

func follow_player(ground):
    print_debug(ground.y)
    position.y = lerp(ground.y, ground.y - SCREEN_HEIGHT, 0.5)
