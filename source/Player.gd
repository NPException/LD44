extends Area2D

signal hit

export var speed := 400 # How fast the player will move (pixels/sec)

var velocity := Vector2()
var target := Vector2()

var screen_size : Vector2


func _ready():
	hide()
	screen_size = get_viewport_rect().size


func start(pos : Vector2):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false


func _input(event):
	if event is InputEventScreenTouch and event.pressed or event is InputEventScreenDrag:
		target = event.position


func _on_Player_body_entered(_body):
	hide() # Player disappears after beeing hit.
	emit_signal("hit")
	$CollisionShape2D.call_deferred("set_disabled", true)


func _process(delta):
	# Move towards the target and stop when close
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if velocity.x != 0:
			$AnimatedSprite.animation = "right"
		elif velocity.y != 0:
			$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.offset.y = -12 if velocity.y > 0 else 12
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
