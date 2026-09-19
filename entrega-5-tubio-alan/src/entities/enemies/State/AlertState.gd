extends TurretState

func enter() -> void:
	character.velocity = Vector2.ZERO
	fire()

func fire() -> void:
	character.fire()
	character._play_animation(&"attack")


func exit() -> void:
	pass


func handle_input(event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	character._look_at_target()


func _on_animation_finished(anim_name: StringName) -> void:
	if character.target == null:
		finished.emit(&"idle")
	else:
		match anim_name:
			&"attack":
				character._play_animation(&"alert")
			&"alert":
				if character._can_see_target():
					fire()
				else:
					finished.emit(&"idle")
				
func _handle_body_exited(body: Node2D) -> void:
	super._handle_body_exited(body)
	if character.target == null:
		if character.body_anim.animation == &"attack":
			finished.emit(&"idle")

# En este callback manejamos, por el momento, solo los impactos
func handle_event(event: StringName, value = null) -> void:
	super.handle_event(event, value)