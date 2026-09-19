extends TurretState

@export var wander_radius: Vector2
@export var speed: float
@export var max_speed: float
@export var pathfinding_step_threshold: float = 5.0

var path: Array = []


func enter() -> void:
	if character.pathfinding != null:
		var random_point: Vector2 = character.global_position + Vector2(
			randf_range(-wander_radius.x, wander_radius.x),
			randf_range(-wander_radius.y, wander_radius.y)
		)
		path = character.pathfinding.get_simple_path(character.global_position, random_point)

		if path.is_empty() || path.size() < 1:
			finished.emit(&"idle")
		else:
			character._play_animation(&"walk")
	else:
		finished.emit(&"idle")


func exit() -> void:
	path = []


func handle_input(event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	if character._can_see_target():
		finished.emit(&"alert")
		return

	if path.is_empty():
		finished.emit(&"idle")
		return
	
	var next_point: Vector2 = path.front()

	while character.global_position.distance_to(next_point) < pathfinding_step_threshold:
		path.pop_front()
		if path.is_empty():
			finished.emit(&"idle")
			return
		next_point = path.front()

	character.velocity = (character.velocity + character.global_position.direction_to(next_point) * speed).limit_length(max_speed)
	character._apply_movement()
	character.body_anim.flip_h = character.velocity.x < 0

func _on_animation_finished(anim_name: StringName) -> void:
	return


# En este callback manejamos, por el momento, solo los impactos
func handle_event(event: StringName, value = null) -> void:
	super.handle_event(event, value)