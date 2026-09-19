extends TurretState

@onready var idle_timer: Timer = $IdleTimer

func enter() -> void:
	character.velocity = Vector2.ZERO

	if character.target != null:
		character._play_animation(&"idle_alert")
	else:
		character._play_animation(&"idle")

	idle_timer.start()


func exit() -> void:
	idle_timer.stop()


func handle_input(event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	character._apply_movement()

	if character._can_see_target():
		finished.emit(&"alert")


func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		&"alert":
			character._play_animation(&"idle_alert")
		&"go_normal":
			character._play_animation(&"idle")

func _on_idle_timer_timeout() -> void:
	finished.emit(&"walk")

func handle_event(event: StringName, value = null) -> void:
	super.handle_event(event, value)

func _handle_body_entered(body: Node2D) -> void:
	super._handle_body_entered(body)
	character._play_animation(&"alert")

func _handle_body_exited(body: Node2D) -> void:
	super._handle_body_exited(body)
	character._play_animation(&"go_normal")
