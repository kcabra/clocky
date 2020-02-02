extends Node

const PLAYER_RUN_SCENE_PATH = "res://proto2/player/player_run.tscn"
const PLAYER_REPAIR_SCENE_PATH = "res://proto2/player/player_repair.tscn"
var player_run
var player_repair

enum modes {run, repair}
export (modes) var current_mode = modes.run
export (int, 1, 2) var current_level = 1
var player
var camera

func _enter_tree():
    player_run = preload(PLAYER_RUN_SCENE_PATH)
    player_repair = preload(PLAYER_REPAIR_SCENE_PATH)

func _ready():
    get_node("Camera").connect("level_changed", self, "_on_level_changed")
    set_mode()

func _on_level_changed():
    current_level += 1

func set_mode():
    if player: player.queue_free()
    match current_mode:
        modes.run:
            player = player_run.instance()
            get_tree().set_group("chao", "one_way_collision", true)
        modes.repair:
            player = player_repair.instance()
            get_tree().set_group("chao", "one_way_collision", false)
    # assumes there's only one spawn active, must remove
    # old spawn before adding a new one.
    var spawn_array = get_tree().get_nodes_in_group("spawn")
    print_debug(current_level - 1)
    player.position = spawn_array[current_level - 1].global_position
    add_child(player)

func _process(delta):
    if Input.is_action_just_pressed("ui_page_down"):
        if current_mode == modes.repair:
            current_mode = modes.run
        else:
            current_mode = modes.repair
        set_mode()
