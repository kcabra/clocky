extends Area2D

func _ready():
    var camera = get_tree().get_nodes_in_group("camera")
    if camera.size() == 1:
        camera = camera[0]
        self.connect("body_entered", camera, "_on_newlevel_collided",
                [self.global_position], CONNECT_ONESHOT)
    else: print_debug("multiple cameras detected")
