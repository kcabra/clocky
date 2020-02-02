 extends KinematicBody2D

const MOVE_TOLERANCE = 5
const SPEED = 300
onready var sprite = $AnimatedSprite

var move_vec = Vector2.ZERO
var block = true

func _ready():
    randomize()
    sprite.animation = "born"
    sprite.playing = true
    yield(sprite, "animation_finished")
    block = false

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
    if !block:
        if sprite.frame != 0:
            print_debug("pre")
        sprite.animation = "default"
        if move_vec.x > 0:
            sprite.flip_h = true
        elif move_vec.x < 0:
            sprite.flip_h = false
        
        if sprite.frame != 0:
            print_debug("mid")
            
        if move_vec.y < -MOVE_TOLERANCE:
            sprite.frame = 2
        elif move_vec.y > MOVE_TOLERANCE:
            sprite.frame = 3
        elif abs(move_vec.x) > MOVE_TOLERANCE:
            sprite.frame = 1
        else:
            sprite.frame = 0
        
        if sprite.frame != 0:
            print_debug("post")
        move_vec = lerp(move_vec, get_input_dir() * SPEED, 0.1)
        move_vec = move_and_slide(move_vec)

var blocks = [
        preload("res://obj/player_plat_default.tscn"),
        preload("res://obj/player_plat_alt.tscn"),
        preload("res://obj/player_plat_vert.tscn"),
        ]

func _input(event):
    if event.is_action_pressed("place"):
        var node = blocks[randi() % blocks.size()].instance()
        node.position = self.position
        get_parent().add_child(node)

func die():
    block = true
    sprite.animation = "die"
    sprite.playing = true
    
