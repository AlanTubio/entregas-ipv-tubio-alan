extends Sprite2D

@onready var fire_marker: Marker2D = $FireMarker

@export var projectile_scene: PackedScene

var projectile_container: Node

func fire():
	var projectile: Projectile = projectile_scene.instantiate()
	projectile_container.add_child(projectile)
	var dir := (fire_marker.global_position - global_position).normalized()
	projectile.set_starting_values(fire_marker.global_position, dir)
	projectile.delete_requested.connect(_on_projectile_delete_requested)

func _on_projectile_delete_requested(projectile: Projectile) -> void:
	projectile_container.remove_child(projectile)
	projectile.queue_free()