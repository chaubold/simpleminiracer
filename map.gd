extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var cam = $MultiTargetCamera
	cam.add_target($Player1)
	cam.add_target($Player2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
