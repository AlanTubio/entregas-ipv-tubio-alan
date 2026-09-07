extends StaticBody2D

@onready var fire_position: Node2D = $TurretSprite/FirePosition
@onready var fire_timer: Timer = $FireTimer
@onready var ray_cast: RayCast2D = $RayCast2D

@export var projectile_scene: PackedScene

var target: Node2D
var projectile_container: Node

func _ready() -> void:
	fire_timer.timeout.connect(fire_at_player)

func initialize(turret_pos: Vector2, projectile_container: Node) -> void:
	global_position = turret_pos
	self.projectile_container = projectile_container

func fire_at_player() -> void:
	ray_cast.target_position = ray_cast.to_local(target.global_position)
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding() and ray_cast.get_collider() == target:
			var proj_instance = projectile_scene.instantiate()
			proj_instance.initialize(
				projectile_container,
				fire_position.global_position,
				fire_position.global_position.direction_to(target.global_position)
			)

func _on_detect_area_body_entered(body: Node2D) -> void:
	if target == null:
		target = body
		fire_timer.start()


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		fire_timer.stop()
