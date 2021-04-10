extends KinematicBody2D

# kindly stolen from: https://kidscancode.org/godot_recipes/2d/car_steering/

export (int) var wheel_base = 70  # Distance from front to rear wheel

export (int) var steering_angle = 15  # Amount that front wheel turns, in degrees

export (int) var engine_power = 800  # Forward acceleration force.

export (float) var friction = -0.9
export (float) var drag = -0.0015

export (float) var braking = -450
export (int) var max_speed_reverse = 250

export (int) var slip_speed = 400  # Speed where traction is reduced

export (float) var traction_fast = 0.1  # High-speed traction

export (float) var traction_slow = 0.7  # Low-speed traction

export (int) var player_id = 1 setget set_player_id

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_angle

func set_player_id(value):
	match value:
		1:
			var frames = preload("car_yellow_sprites.tres")
			$AnimatedSprite.set_sprite_frames(frames)
			player_id = value
		2:
			var frames = preload("car_yellow_sprites.tres")
			$AnimatedSprite.set_sprite_frames(frames)
			player_id = value
		_:
			print("Invalid player ID")	

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_action_pressed("p%s_left" % player_id):
		turn += 1
	if Input.is_action_pressed("p%s_right" % player_id):
		turn -= 1
	steer_angle = turn * steering_angle
	if Input.is_action_pressed("p%s_up" % player_id):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("p%s_down" % player_id):
		acceleration = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
