extends Node2D

@onready var camera:Node3D = $Camera3D
@onready var visible_area:Area3D = $Camera3D/Area3D
@onready var ui_select:NinePatchRect = $NinePatchRect
@onready var visible_units:Dictionary = {}

var mouse_click:bool = false
var rect_area:Rect2 


func _ready() -> void:
	visible_area.body_entered.connect(_on_visible_area_body_entered)
	visible_area.body_exited.connect(_on_visible_area_body_exited)
	ui_select.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left_Click"):
		rect_area.position = get_global_mouse_position()
		# ui_select.position = get_global_mouse_position()
		mouse_click = true

	if Input.is_action_just_released("Left_Click"):
		ui_select.visible = false
		mouse_click = false
		cast_selection()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_click:
		# ui_select.size = abs(get_global_mouse_position() - ui_select.position)
		ui_select.visible = true
		rect_area.size = get_global_mouse_position() - rect_area.position
		
		ui_select.scale.x = 1
		if get_global_mouse_position().x - ui_select.position.x <= 0:
			ui_select.scale.x = -1
			

		ui_select.scale.y = 1
		if get_global_mouse_position().y - ui_select.position.y <= 10:
			ui_select.scale.y = -1

	ui_select.size = rect_area.size.abs()
	ui_select.position = rect_area.position

func _on_visible_area_body_entered(body: Node3D):
	print(body.name)
	if body.is_in_group("unit"):
		visible_units[body.name] = body


func _on_visible_area_body_exited(body: Node3D):
	if body.is_in_group("unit"):
		visible_units.erase(body.name)

func cast_selection() -> void:
	print("rect_area: ", rect_area.abs())
	
	for unit in visible_units.values():
		if rect_area.abs().has_point(camera.unproject_position(unit.transform.origin)):
			unit.select()
		else:
			unit.deselect()
