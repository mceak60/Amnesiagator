class_name Bar
extends Node2D

const CELL_SIZE := Vector2(32, 32)
const HALF_CELL_SIZE := Vector2(16, 16)
const QUARTER_CELL_SIZE := Vector2(8, 8)

@onready var draggable_mover: DraggableMover = $DraggableMover
@onready var draggable_spawner: DraggableSpawner = $DraggableSpawner

func _ready() -> void:
	draggable_spawner.ingredient_spawned.connect(draggable_mover.setup_ingredient)
	draggable_spawner.drink_spawned.connect(draggable_mover.setup_drink)
