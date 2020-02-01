extends StateMachine

const MOVE_TOLERANCE = 0.01
const JUMP_TOLERANCE = 0.1
const IDLE_WAIT = 6.0
var stand_timer = 0
var jump_timer = 0
var ground_timer = 0

onready var animator = null
onready var sprite = $"../AnimatedSprite"
enum states {stand, idle, walk, fall, jump}

func _ready():
    if animator: $AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
    call_deferred("set_state", states.fall)

func _state_logic(delta):
    ground_timer -= delta
    jump_timer -= delta
    if Input.is_action_just_pressed("move_up"):
        jump_timer = JUMP_TOLERANCE
    match state:
        states.stand:
            stand_timer += delta
            if stand_timer > IDLE_WAIT:
                if animator: animator.travel("idle")
                stand_timer = 0
            continue
        states.walk, states.jump:
            if parent.move_vec.x > 0:
                sprite.flip_h = false
            elif parent.move_vec.x < 0:
                sprite.flip_h = true
            continue
        states.stand, states.walk, states.fall:
            if jump_timer >= 0 and ground_timer >= 0:
                parent.jump()
                jump_timer = 0
                ground_timer = 0
            continue
        states.jump:
            if Input.is_action_just_released("move_up"):
                parent.cut_jump()
            continue
        states.stand, states.walk:
            ground_timer = JUMP_TOLERANCE
            parent.hor_move(_get_input_dir(), false)
        states.fall, states.jump:
            parent.apply_gravity(true)
            parent.hor_move(_get_input_dir(), true)
                
    parent.apply_movement()


func _get_transition():
    match state:
        states.walk, states.stand:
            if parent.move_vec.y < 0:
                return states.jump
            if not parent.is_on_ground():
                return states.fall
            continue
        states.stand:
            if abs(parent.move_vec.x) > MOVE_TOLERANCE:
                return states.walk
        states.walk:
            if abs(parent.move_vec.x) <= MOVE_TOLERANCE:
                return states.stand
        states.fall:
            if parent.is_on_ground():
                return states.stand
        states.jump:
            if parent.move_vec.y > 0:
                return states.fall 
    return null

func _enter_state(new_state, old_state): 
    match new_state:
        states.stand:
            if jump_timer < 0:
                sprite.animation = "stand"
                sprite.frame = 0
                sprite.playing = false
        states.walk:
                sprite.animation = "walk"
                sprite.playing = true
        states.fall:
                sprite.animation = "fall"
                sprite.frame = 0
                sprite.playing = true
        states.jump:
                sprite.animation = "jump"
                sprite.frame = 0
                sprite.playing = true

func _exit_state(old_state, new_state):
    match old_state:
        states.walk:
            parent.halt()

func _get_input_dir():
    var dir = 0
    if Input.is_action_pressed("move_right"):
        dir += 1
    if Input.is_action_pressed("move_left"):
        dir -= 1
    return dir
