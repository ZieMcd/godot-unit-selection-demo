extends CharacterBody3D

@onready var _camera: Camera3D = $"../Player_Interface/Camera3D"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var selected_sprite: Sprite3D = $Sprite3D
var selected:bool = false

func _ready():
	selected = get_meta("is_selected")
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and selected:
		# Get closest point on navmesh for the current mouse cursor position.
		var mouse_cursor_position = event.position
		var camera_ray_length := 1000.0
		var camera_ray_start := _camera.project_ray_origin(mouse_cursor_position)
		var camera_ray_end := camera_ray_start + _camera.project_ray_normal(mouse_cursor_position) * camera_ray_length

		var closest_point_on_navmesh := NavigationServer3D.map_get_closest_point_to_segment(
			get_world_3d().navigation_map,
			camera_ray_start,
			camera_ray_end
			)
		nav_agent.set_target_position(closest_point_on_navmesh)

func _physics_process(delta: float) -> void:
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * 5.0
	move_and_slide()

func _process(delta: float) -> void:
	if selected:
		selected_sprite.visible = true
	else:
		selected_sprite.visible = false

func select() -> void:
	selected = true

func deselect():
	selected = false
