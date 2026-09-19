extends CharacterBody2D
class_name EnemyTurret

signal hit(amount: int)

@onready var fire_position: Node2D = $FirePosition
@onready var raycast: RayCast2D = $RayCast2D
@onready var body_anim: AnimatedSprite2D = $Body

@export var projectile_scene: PackedScene
@export var pathfinding: PathfindAstar
@export var wander_radius: Vector2 = Vector2(10.0, 10.0)
@export var speed: float = 10.0
@export var max_speed: float = 100.0
@export var pathfinding_step_threshold: float = 5.0

var target: Node2D
var projectile_container: Node

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false


func initialize(turret_pos: Vector2, _projectile_container: Node) -> void:
	global_position = turret_pos
	self.projectile_container = _projectile_container

func fire() -> void:
	if target != null:
		var proj_instance: Node = projectile_scene.instantiate()
		if projectile_container == null:
			projectile_container = get_parent()
		projectile_container.add_child(proj_instance)
		proj_instance.initialize(
			fire_position.global_position,
			fire_position.global_position.direction_to(target.global_position)
		)
		_play_animation(&"attack")


func _look_at_target() -> void:
	body_anim.flip_h = raycast.target_position.x < 0
	
func _can_see_target() -> bool:
	if target == null:
		return false

	raycast.set_target_position(raycast.to_local(target.global_position))
	raycast.force_raycast_update()
	return raycast.is_colliding() && raycast.get_collider() == target


func _apply_movement() -> void:
	move_and_slide()


## Esta función ya no llama directamente a remove, sino que inhabilita las
## colisiones con el mundo, pausa todo lo demás y ejecuta una animación de muerte
## dependiendo de si el enemigo esta o no alerta
func notify_hit(amount: int = 1) -> void:
	hit.emit(amount)

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


## Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
## (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: StringName) -> void:
	if body_anim.sprite_frames.has_animation(animation):
		body_anim.play(animation)

func get_current_animation() -> StringName:
	return body_anim.animation
