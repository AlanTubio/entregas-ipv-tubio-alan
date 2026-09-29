extends Control

## Menú de pausa genérico, abierto utilizando la acción "pause_menu"
## (por default la tecla Esc).
signal return_selected()
@onready var options_menu: Control = %OptionMenu

func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pause_menu") && !options_menu.visible:
		visible = !visible
		get_tree().paused = visible


func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_return_button_pressed() -> void:
	return_selected.emit()
