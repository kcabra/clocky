tool 
extends KinematicBody2D

## MOVEMENT
export var BLOCK_SIZE = 90
export var MAX_GRAV = 500
export var SPEED = 200
export var jump_duration = 0.3
export var jump_height = 1.5
export var jump_min_height = 1.0
var move_vec = Vector2.ZERO

func is_on_ground():
    return $RayCast2D.is_colliding() or $RayCast2D2.is_colliding()

func hor_move(dir, falling):
    move_vec.x = lerp(move_vec.x, dir * SPEED, 0.5)

func halt():
    move_vec.x = 0

func apply_movement():
    move_vec = move_and_slide(move_vec)

func apply_gravity(falling):
    move_vec.y += _get_gravity() if move_vec.y < MAX_GRAV else 0

func _get_gravity():
    return (2 * jump_height) / pow(jump_duration, 2)

func cut_jump():
    if move_vec.y < _get_jump_min_vel():
        move_vec.y = _get_jump_min_vel()

func jump():
    move_vec.y = _get_jump_max_vel()

func _get_jump_max_vel():
    return (-2 * jump_height * BLOCK_SIZE) / jump_duration

func _get_jump_min_vel():
    return (-2 * jump_min_height * BLOCK_SIZE) / jump_duration

func die():
    $FSM.die()
