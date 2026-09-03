extends Sprite2D
class_name Projectile

signal delete_requested(projectile: Projectile)

var direction: Vector2
@export var speed: float = 400

func _ready():
    set_physics_process(false)

func set_starting_values(start_position: Vector2, direction: Vector2):
    global_position = start_position
    self.direction = direction
    $Timer.start()
    set_physics_process(true)

func _physics_process(delta):
    position += direction * speed * delta

func _on_timer_timeout() -> void:
    delete_requested.emit(self)