extends Node

const PLAYER_RUN_SCENE_PATH = "res://player/player_run.tscn"
const PLAYER_REPAIR_SCENE_PATH = "res://player/player_repair.tscn"
var player_run
var player_repair

export (bool) var godmode = false
export (int, 1, 5) var current_level = 1
onready var timer = $Timer
onready var camera = $Camera
var player

func _enter_tree():
	player_run = preload(PLAYER_RUN_SCENE_PATH)
	player_repair = preload(PLAYER_REPAIR_SCENE_PATH)

func _ready():
	camera.connect("level_changed", self, "_on_level_changed")
	timer.connect("timeout", self, "_on_level_timeout")
	godmode = !godmode
	switch_mode()

func _on_level_timeout():
	if !godmode:
		get_tree().call_group("placed", "queue_free")
	switch_mode()

func _on_level_changed():
	current_level += 1
	if current_level == 7:
		start_game_ending()

func switch_mode():
	if player: player.die()
	godmode = !godmode
	if godmode:
		$"UI/Modulator".play("modulate")
		get_tree().call_group("placed", "queue_free")
		player = player_repair.instance()
		get_tree().set_group("level_transition", "one_way_collision", false)
	else:
		$"UI/Modulator".play_backwards("modulate")
		player = player_run.instance()
		get_tree().set_group("level_transition", "one_way_collision", true)
	# assumes there's only one spawn active, must remove
	# old spawn before adding a new one.
	var spawn_array = get_tree().get_nodes_in_group("spawn")
	player.position = spawn_array[current_level - 1].global_position
	add_child(player)
	timer.start()

func _process(delta):
	$"UI/Label".text = String(floor(timer.time_left))
	if Input.is_action_just_pressed("reset"):
		switch_mode()

func start_game_ending():
	timer.stop()
	$UI/Label.visible = false
	yield(get_tree().create_timer(3.0), "timeout")
	$Ending.play("ending")
	yield($Ending, "animation_finished")
	get_tree().change_scene("res://holders/menu/main menu loop the loop.tscn")
