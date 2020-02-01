extends Node

const PLAYER_RUN_SCENE_PATH = "res://proto2/player/player_run.tscn"
const PLAYER_REPAIR_SCENE_PATH = "res://proto2/player/player_repair.tscn"
var player_run
var player_repair

enum modes {run, repair}
export (modes) var current_mode = modes.run
var player

func _enter_tree():
    player_run = preload(PLAYER_RUN_SCENE_PATH)
    player_repair = preload(PLAYER_REPAIR_SCENE_PATH)

func _ready():
    # assumes there's only one spawn active, must remove
    # old spawn before adding a new one.
    var spawn = get_tree().get_nodes_in_group("spawn")[0]
    match current_mode:
        modes.run:
            player = player_run.instance()
        modes.repair:
            player = player_repair.instance()
    player.position = spawn.global_position
    add_child(player)
    
        
