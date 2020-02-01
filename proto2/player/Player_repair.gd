 extends KinematicBody2D

const MOVE_TOLERANCE = 1
const SPEED = 300

onready var sprite = $AnimatedSprite

var move_vec = Vector2.ZERO

func get_input_dir():
    var dir = Vector2.ZERO
    if Input.is_action_pressed("move_right"):
        dir.x += 1
    if Input.is_action_pressed("move_left"):
        dir.x -= 1
    if Input.is_action_pressed("move_up"):
        dir.y -= 1
    if Input.is_action_pressed("move_down"):
        dir.y += 1
    return dir.normalized()

func _physics_process(delta):
    if move_vec.x > 0:
        sprite.flip_h = false
    elif move_vec.x < 0:
        sprite.flip_h = true
    
    if move_vec.y < -MOVE_TOLERANCE:
        sprite.frame = 2
    elif move_vec.y > MOVE_TOLERANCE:
        sprite.frame = 3
    elif abs(move_vec.x) > MOVE_TOLERANCE:
        sprite.frame = 1
    else:
        sprite.frame = 0
    
    move_vec = lerp(move_vec, get_input_dir() * SPEED, 0.1)
    move_vec = move_and_slide(move_vec)

func _input(event):
    pass
#    if event.is_action_pressed()
