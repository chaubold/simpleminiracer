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
func _process(_delta):
	$HUD/Player1Health.text = 'Player 1 health: %s' % $Player1.health
	$HUD/Player2Health.text = 'Player 2 health: %s' % $Player2.health
