extends Area2D

# we use this signal to connect to whatver projectile we want to fling
signal vector_created(vector)

# this var is used as a limit to strength of fling
export var maximum_length := 500

var touch_down := false
var position_start := Vector2.ZERO
var position_end := Vector2.ZERO

#what we will emit on signal
var vector := Vector2.ZERO

# makes sure our values are reset between flings
func _reset() -> void:
	position_start = Vector2.ZERO
	position_end = Vector2.ZERO
	vector = Vector2.ZERO
	update()
	
func _ready():
	connect("_input_event", self, "_on_input_event")

func _draw() -> void:
	draw_line(position_start - global_position,
			(position_end - global_position),
			Color.blue, # blue line the length of the differe
			8)
	draw_line(position_start - global_position,
		position_start - global_position + vector,
		Color.red,
		16)
			
func _input(event) -> void:
		if not touch_down:
			return
			
		if event.is_action_released("ui_touch"):
			touch_down = false
			emit_signal("vector_created", vector)
			_reset()
			
		if event is InputEventMouseMotion:
			position_end = event.position
			vector = -(position_end - position_start).clamped(maximum_length)
			update()
func _input_event(_viewport, event, _shape_idx) -> void:
	
	if event.is_action_pressed("ui_touch"):
		touch_down = true
		position_start = event.position
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
