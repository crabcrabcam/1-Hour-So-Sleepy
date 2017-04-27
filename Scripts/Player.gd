extends KinematicBody2D

const SLOW_DOWN = 1
const JUMP_HEIGHT = -200
const GRAVITY = 400

var velocity = Vector2()
var move_speed = 120

func _fixed_process(delta):
	velocity.y += delta * GRAVITY
	
	#If not moving left OR right, stay still
	if(!Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left")):
		velocity.x = 0
	
	var motion = velocity * delta
	move(motion)
	
	if (is_colliding()):
		#The normal
		var normal = get_collision_normal()
		motion = normal.slide(motion)
		velocity = normal.slide(velocity)
		move(motion)
		
		if(Input.is_action_pressed("ui_up")):
			print("jumping")
			velocity.y = JUMP_HEIGHT
	


func _input(event):
	#Handle left
	if event.is_action_pressed("ui_left"):
		velocity.x = -move_speed
	#Handle right
	if event.is_action_pressed("ui_right"):
		velocity.x = move_speed
		
	


func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	connect("body_enter", self, "_on_Area2D_body_enter")
	
	#To slow the player down
	var _timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_Timer_timeout():
	print("Timeout")
	print(move_speed)
	move_speed -= SLOW_DOWN
	
	if move_speed < 10:
		#Game ends
		set_process_input(false)
		#Changes the scene to the end of the game scene
		get_tree().change_scene("res://Scenes/you_lose.tscn")

func _on_Area2D_body_enter( body ):
	print("Entered")
	get_tree().change_scene("res://Scenes/you_win.tscn")
