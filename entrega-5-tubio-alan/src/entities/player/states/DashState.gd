extends PlayerState

@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.15

var elapsed_time: float = 0.0
var dash_direction: float = 1.0

func enter() -> void:
	elapsed_time = 0.0
	dash_direction = character.h_movement_direction
	if dash_direction == 0.0:
		dash_direction = sign(character.body_pivot.scale.x)
	if dash_direction == 0.0:
		dash_direction = 1.0
	character.velocity = Vector2(dash_direction * dash_speed, 0.0)

func exit() -> void:
	character.velocity.x = 0.0


func update(delta: float) -> void:
	elapsed_time += delta
	character.velocity.x = dash_direction * dash_speed
	character._apply_movement(delta)

	if elapsed_time >= dash_duration:
		if character.h_movement_direction == 0:
			finished.emit(&"idle")
		else:
			finished.emit(&"walk")


func handle_input(_event: InputEvent) -> void:
	pass


func handle_event(_event: StringName, _value = null) -> void:
	pass

func _on_animation_finished(_anim_name: StringName) -> void:
	pass
