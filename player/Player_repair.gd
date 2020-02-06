 extends KinematicBody2D

const MOVE_TOLERANCE = 5
const SPEED = 300
onready var sprite = $AnimatedSprite

var move_vec = Vector2.ZERO
var block = true

func _ready():
	randomize()
	blockspawn_timer.connect("timeout", self, "_hold_block")
	sprite.animation = "born"
	sprite.frame = 0
	sprite.playing = true
	yield(sprite, "animation_finished")
	block = false
	blockspawn_timer.start()

func die():
	halt()
	block = true
	sprite.animation = "die"
	sprite.playing = true
	yield(sprite, "animation_finished")
	self.queue_free()

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

func halt():
	move_vec = Vector2.ZERO

func _physics_process(delta):
	if !block:
		if sprite.animation == 'default':
			sprite.playing = false
			if move_vec.x >= 0:
				sprite.flip_h = true
			elif move_vec.x < 0:
				sprite.flip_h = false
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

var blocks = [
		preload("res://obj/player_plat_default.tscn"),
		preload("res://obj/player_plat_alt.tscn"),
		preload("res://obj/player_plat_vert.tscn"),
		]

onready var blockspawn_timer = $Timer
var holding = false

func _hold_block():
	holding = true
	var node = blocks[randi() % blocks.size()].instance()
	$Position2D.add_child(node)

func _release_block():
	holding = false
	var node = $Position2D.get_child(0)
	var pos = node.global_position
	$Position2D.remove_child(node)
	node.position = pos
	get_parent().add_child(node)
	blockspawn_timer.start()

func _input(event):
	if event.is_action_pressed("action"):
		if holding:
			_release_block()
			sprite.animation = "jazz"
			sprite.frame = 0
			sprite.playing = true
			sprite.connect("animation_finished", self,
					"_on_sprite_animation_finished", [],
					CONNECT_ONESHOT)

func _on_sprite_animation_finished():
	sprite.animation = "default"
	sprite.playing = false
	sprite.frame = 0
	
