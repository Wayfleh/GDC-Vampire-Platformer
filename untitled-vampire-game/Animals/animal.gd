class_name Animal
extends Area2D

@export var type: GlobalData.Animals

#animal fall off screen death settings
@export var death_pop_speed: float = -260.0
@export var death_fall_gravity: float = 900.0
@export var death_horizontal_push: float = 60.0
@export var death_spin_speed: float = 0.0
@export var delete_y_margin: float = 200.0

var is_dead: bool = false
var death_velocity: Vector2 = Vector2.ZERO
var death_started: bool = false

func _ready():
	add_to_group("animals")
	print("Animal ready:", name, " group_count=", get_tree().get_nodes_in_group("animals").size())
	if has_node("AnimatedSprite2D"):
		var sprite = $AnimatedSprite2D
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("snooze"):
			sprite.play("snooze")

func _physics_process(delta: float) -> void:
	if is_dead:
		death_velocity.y += death_fall_gravity * delta
		global_position += death_velocity * delta
		rotation += death_spin_speed * delta

		var viewport_bottom := get_viewport_rect().size.y + delete_y_margin
		if global_position.y > viewport_bottom:
			queue_free()

func die_from_bite_dash(from_dir: int) -> void:
	if is_dead:
		return

	is_dead = true
	death_started = true

	# Stop this animal from being hit again
	monitoring = false
	monitorable = false

	_disable_collision_shapes(self)

	$DeathSound.play()
	
	# If the frog has a sprite animation and a "death" animation exists, play it
	if has_node("AnimatedSprite2D"):
		var sprite = $AnimatedSprite2D
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("death"):
			sprite.play("death")

	# launch upward and slightly sideways
	death_velocity = Vector2(from_dir * death_horizontal_push, death_pop_speed)

func _disable_collision_shapes(node: Node) -> void:
	for child in node.get_children():
		if child is CollisionShape2D:
			child.disabled = true
		_disable_collision_shapes(child)
