extends Node2D
# This demo is an example of controling a high number of 2D objects with logic
# and collision without using nodes in the scene. This technique is a lot more
# efficient than using instancing and nodes, but requires more programming and
# is less visual. Bullets are managed together in the `bullets.gd` script.

# The number of bullets currently touched by the player.
var touching = 0

onready var sprite = $AnimatedSprite
onready var original
onready var blue = false
onready var health = 15 
var label
var isInvincible = false
var invincibleTimer = 0
var invincibleTimerConstant = 2
var blueMeter = 5
var blueMeterMax = 5
var maxMeterWidth
var meter

func _ready():
	# The player follows the mouse cursor automatically, so there's no point
	# in displaying the mouse cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	original = sprite.modulate
	label = get_node("/root/Shower/Label")
	label.text = "Health:" + str(health)
	meter = get_node("/root/Shower/Meter")
	maxMeterWidth = meter.rect_size.x

func _process(delta):
	if isInvincible == true:
		sprite.frame = 1
		invincibleTimer -= delta
		if invincibleTimer <= 0:
			isInvincible = false
	elif touching >= 1: #and blue == false:
		sprite.frame = 1
		health = health - 1
		label.text = "Health:" + str(health)
		isInvincible = true
		invincibleTimer = invincibleTimerConstant
	else: 
		sprite.frame = 0
	if blue:
		blueMeter -= delta
		meter.rect_size.x = maxMeterWidth*blueMeter/blueMeterMax
	elif blueMeter < blueMeterMax:
		blueMeter += delta
		meter.rect_size.x = maxMeterWidth*blueMeter/blueMeterMax

func _input(event):
	if event is InputEventMouseMotion:
		position = event.position - Vector2(0, 16)
	if event is InputEventMouseButton:
		if event.pressed and blueMeter > 0:
			sprite.modulate = Color(0.1,0.50,1)
			blue = true
		else:
			sprite.modulate = modulate
			blue = false

func _on_body_shape_entered(_body_id, _body, _body_shape, _local_shape):
	touching += 1



func _on_body_shape_exited(_body_id, _body, _body_shape, _local_shape):
	touching -= 1
