extends Node2D

func _ready():
	$AnimationPlayer.advance(0)

func destroy():
	$AnimationPlayer.play("destroy")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
