@abstract
class_name TurretState extends AbstractState

var character: EnemyTurret

func handle_event(event: StringName, value = null) -> void:
	match event:
		&"body_entered":
			_handle_body_entered(value)
		&"body_exited":
			_handle_body_exited(value)

func _handle_body_entered(body: Node2D) -> void:
	if character.target == null && !character.dead:
		character.target = body

func _handle_body_exited(body: Node2D) -> void:
	if character.target == body && !character.dead:
		character.target = null