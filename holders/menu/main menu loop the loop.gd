extends Control

onready var new_game = preload("res://levels/proto2.tscn")

func _on_newgame_pressed():
	get_tree().change_scene_to(new_game)

func _on_instrucoes_pressed():
	get_tree().change_scene("res://holders/menu/controles.tscn")
